clear all; clc;
% Parâmetros
n_bits = 1000;                % Número de bits
T = 500;                      % Tempo de símbolo OFDM
Ts = 2;                       % Tempo de símbolo em portadora única
K = T/Ts;                     % Número de subportadoras independentes
N = 2*K;                      % DFT de N pontos
%
% Gerar bits aleatórios
dataIn=rand(1,n_bits);   % Sequência de números entre 0 e 1 uniformemente distribuídos
dataIn=sign(dataIn-.5);  % Sequência de -1 e 1
% Conversor serial paralelo
dataInMatrix = reshape(dataIn,n_bits/4,4);
%
% Gerar constelaçao 16-QAM
seq16qam = 2*dataInMatrix(:,1)+dataInMatrix(:,2)+1i*(2*dataInMatrix(:,3)+dataInMatrix(:,4)); 
seq16=seq16qam';
% Garantir propriedadade da simetria
X = [seq16 conj(seq16(end:-1:1))]; 

% Construindo xn
ofdmsym_sp = ifft(reshape(X,length(X)/10, 10));
xn = reshape(ofdmsym_sp,1,length(X));

EbN0dB = 0:1:14;
snrdb =  EbN0dB+10*log10(log2(16)*(50/50));

Eb = xn*xn'/length(xn);

sigmas= zeros(0,length(snrdb));             % Vetor de variâncias do ruído
for i = 1:length(snrdb)
    N0 = Eb*(10^(-snrdb(i)/10));
    sigmas(i) = N0/2;
end

BER_BPSK = zeros(1,length(snrdb));
BER_QAM = zeros(1,length(snrdb));
% Loop de variâncias
for ik = 1:length(sigmas)
    %
    % Adição de ruído
    variance = sigmas(ik);
    BER_QAM_MC = zeros(1,5000);
    for jk = 1:5000
        %wgn = sqrt(variance) * [1 j] *  randn(2, length(xn));
        noise = sqrt(variance)*randn(1,N)+1i*sqrt(variance)*randn(1,N);
        %
        % sinal recebido QAM = xn + ruído 
        rn = xn;

        % FFT do rn
        Y = fft(reshape(rn,50,length(rn)/(50)));
        Y = reshape(Y,1,length(X));
        
        % Plots
        %{
        scatterplot(Y)
        hold on
        scatter(real(seq16),imag(seq16), 'r', '+')
        hold off
        title(['Sinal com ruído de variância ', num2str(variance)]);
        %}
        
        % Demodulação sinal recebido
        bits_recebidos = zeros(1, length(Y));
        for k= 1:length(Y) % Para percorrer todo o vetor Yk 
            if real(Y(1,k)) > 0 % Para parte real de Yk positiva
                if real(Y(1,k)) > 2
                    bits_recebidos(1,k) = 1;
                    bits_recebidos(1,k+1)= 1;
                else
                    bits_recebidos(1,k) = 1;
                    bits_recebidos(1,k+1)= 0;
                end
            else % Para parte real de Yk negativa ou igual a zero
                if real(Y(1,k)) < -2
                     Z(1,k) = -3;
                else
                     Z(1,k) = -1;
                end
            end

            if imag(Y(1,k)) > 0 % Para parte imaginaria de Yk positiva
                if imag(Y(1,k)) > 2
                    Z(1,k) = Z(1,k) + 1i*3;
                else
                    Z(1,k) = Z(1,k) + 1i;
                end
            else % Para parte imaginaria de Yk negativa ou igual a zero
                if imag(Y(1,k)) < -2
                     Z(1,k) = Z(1,k) - 1i*3;
                else
                     Z(1,k) = Z(1,k) - 1i;
                end
            end
        end

        % Contagem de erro
        
        error = length(find(Z(1,2:K)-X(1,2:K)));
        BER_QAM_MC(jk) = error/length(X);
    end 
    BER_QAM(ik) = mean(BER_QAM_MC); %BER QAM simulado
    disp(['Para variância de ', num2str(variance), ' houve ', num2str(error), ' símbolos errados.']);
end

%BER Teórico
symErrTheory = zeros(0,length(snrdb));
for i = 1:length(snrdb)
    symErrTheory(i) = (4/log2(16))*(1-1/sqrt(16))*erfc(sqrt(3*(4/log2(16))*((10^(snrdb(i)/10))/(16-1))));
end

symErrTheory = ber_QAM(EbN0dB,16,'a');

figure;
semilogy(EbN0dB,symErrTheory,'r-');
hold on;
semilogy(EbN0dB,BER_QAM,'b-');
legend('16QAM-BER Teórico','16QAM- BER SImulado');
xlabel('Eb/N0(dB)');
ylabel('Symbol Error Rate (Ps)');