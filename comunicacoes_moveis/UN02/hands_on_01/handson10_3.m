clear all; clc; close all
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
xn = zeros(1,N);
xn = ifft(X);
xn = sqrt(N) * xn;

EbN0dB = 0:1:14;


Eb = 1;

sigmas= zeros(0,length(EbN0dB));             % Vetor de variâncias do ruído
for i = 1:length(EbN0dB)
    N0 = Eb/10^(EbN0dB(i)/10);
    sigmas(i) = N0/2;
end

BER_BPSK = zeros(1,length(EbN0dB));
BER_QAM = zeros(1,length(EbN0dB));
% Loop de variâncias
for ik = 1:length(sigmas)
    %
    % Adição de ruído
    variance = sigmas(ik);
    noise = sqrt(variance)*randn(1,N)+1i*sqrt(variance)*randn(1,N);
    %
    % sinal recebido QAM = xn + ruído 
    rn = xn + noise;
    
    % FFT do rn
    Y = fft(rn);
    Y = (1/sqrt(N))*Y(1:K);
    
    % Plots
    %{
    scatterplot(Y)
    hold on
    scatter(real(seq16),imag(seq16), 'r', '+')
    hold off
    title(['Sinal com ruído de variância ', num2str(variance)]);
    %}
    % Demodulação QAM
    for k= 1:length(Y) % Para percorrer todo o vetor Yk 
        if real(Y(1,k)) > 0 % Para parte real de Yk positiva
            if real(Y(1,k)) > 2
                Z(1,k) = 3;
            else
                Z(1,k) = 1;
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
    BER_QAM(ik) = error/length(X); %BER simulado
    disp(['Para variância de ', num2str(variance), ' houve ', num2str(error), ' símbolos errados.']);
end

%BER Teórico
symErrTheory = zeros(0,length(EbN0dB));
for i = 1:length(EbN0dB)
    N0 = Eb*10^(EbN0dB(i)/10);
    symErrTheory(i) = 2*(1-1/sqrt(16))*erfc(sqrt(3/2*log2(16)*10^(EbN0dB(i)/10)/(16-1)));
end

semilogy(EbN0dB,symErrTheory,'r-');
hold on;
semilogy(EbN0dB,BER_QAM,'b-');
legend('16QAM-BER Teórico','16QAM- BER SImulado');
xlabel('Eb/N0(dB)');
ylabel('Symbol Error Rate (Ps)');