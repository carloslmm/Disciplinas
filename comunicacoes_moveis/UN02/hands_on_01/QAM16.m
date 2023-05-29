clear all; clc;
% Parâmetros
n_bits = 1000;                % Número de bits
T = 500;                      % Tempo de símbolo OFDM
Ts = 2;                       % Tempo de símbolo em portadora única
K = T/2;                     % Número de subportadoras independentes
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

bits_transmitidos = zeros(1, length(X));
index = 1;
for k= 1:length(X) % Para percorrer todo o vetor Yk 
    if real(X(1,k)) > 0 % Para parte real de Yk positiva
        if real(X(1,k)) > 2
            bits_transmitidos(1,index) = 1;
            index = index + 1;
            bits_transmitidos(1,index)= 1;
            index = index + 1;
        else
            bits_transmitidos(1,index) = 1;
            index = index + 1;
            bits_transmitidos(1,index)= 0;
            index = index + 1;
        end
    else % Para parte real de Yk negativa ou igual a zero
        if real(X(1,k)) < -2
            bits_transmitidos(1,index) = 0;
            index = index + 1;
            bits_transmitidos(1,index)= 0;
            index = index + 1;
        else
            bits_transmitidos(1,index) = 0;
            index = index + 1;
            bits_transmitidos(1,index)= 1;
            index = index + 1;
        end
    end

    if imag(X(1,k)) > 0 % Para parte imaginaria de Yk positiva
        if imag(X(1,k)) > 2
            bits_transmitidos(1,index) = 1;
            index = index + 1;
            bits_transmitidos(1,index)= 1;
            index = index + 1;
        else
            bits_transmitidos(1,index) = 1;
            index = index + 1;
            bits_transmitidos(1,index)= 0;
            index = index + 1;
        end
    else % Para parte imaginaria de Yk negativa ou igual a zero
        if imag(X(1,k)) < -2
           bits_transmitidos(1,index) = 0;
            index = index + 1;
            bits_transmitidos(1,index)= 0;
            index = index + 1;
        else
            bits_transmitidos(1,index) = 0;
            index = index + 1;
            bits_transmitidos(1,index)= 1;
            index = index + 1;
        end
    end
end

xn = ifft(X);
xn = sqrt(N)*xn;

EbN0dB = 0:1:14;

Eb = 1;

sigmas= zeros(0,length(EbN0dB));             % Vetor de variâncias do ruído
for i = 1:length(EbN0dB)
    N0 = Eb*(10^(-EbN0dB(i)/10));
    sigmas(i) = N0/2;
end

BER_BPSK = zeros(1,length(EbN0dB));
% Loop de variâncias
for ik = 1:length(sigmas)
    %
    % Adição de ruído
    variance = sigmas(ik);
    BER_QAM = zeros(1,5000);
    for jk = 1:5000
        %wgn = sqrt(variance) * [1 j] *  randn(2, length(xn));
        noise = sqrt(variance)*randn(1,N)+1i*sqrt(variance)*randn(1,N);
        %
        % sinal recebido QAM = xn + ruído 
        rn = xn + noise;

        % FFT do rn
        Y = fft(rn);
        Y = (1/sqrt(N))*Y;
        
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
        index = 1;
        for k= 1:length(Y) % Para percorrer todo o vetor Yk 
            if real(Y(1,k)) > 0 % Para parte real de Yk positiva
                if real(Y(1,k)) > 2
                    bits_recebidos(1,index) = 1;
                    index = index + 1;
                    bits_recebidos(1,index)= 1;
                    index = index + 1;
                else
                    bits_recebidos(1,index) = 1;
                    index = index + 1;
                    bits_recebidos(1,index)= 0;
                    index = index + 1;
                end
            else % Para parte real de Yk negativa ou igual a zero
                if real(Y(1,k)) < -2
                    bits_recebidos(1,index) = 0;
                    index = index + 1;
                    bits_recebidos(1,index)= 0;
                    index = index + 1;
                else
                    bits_recebidos(1,index) = 0;
                    index = index + 1;
                    bits_recebidos(1,index)= 1;
                    index = index + 1;
                end
            end

            if imag(Y(1,k)) > 0 % Para parte imaginaria de Yk positiva
                if imag(Y(1,k)) > 2
                    bits_recebidos(1,index) = 1;
                    index = index + 1;
                    bits_recebidos(1,index)= 1;
                    index = index + 1;
                else
                    bits_recebidos(1,index) = 1;
                    index = index + 1;
                    bits_recebidos(1,index)= 0;
                    index = index + 1;
                end
            else % Para parte imaginaria de Yk negativa ou igual a zero
                if imag(Y(1,k)) < -2
                   bits_recebidos(1,index) = 0;
                    index = index + 1;
                    bits_recebidos(1,index)= 0;
                    index = index + 1;
                else
                    bits_recebidos(1,index) = 0;
                    index = index + 1;
                    bits_recebidos(1,index)= 1;
                    index = index + 1;
                end
            end
        end
        bits_errors = sum(bits_transmitidos ~= bits_recebidos);
        BER_QAM(k) = bits_errors / length(bits_transmitidos);
    end 
    BER_QAM_MC(ik) = mean(BER_QAM);
end

%BER Teórico
symErrTheory = zeros(0,length(EbN0dB));
for i = 1:length(EbN0dB)
    symErrTheory(i) = (4/log2(16))*(1-1/sqrt(16))*erfc(sqrt(3*(4/log2(16))*((10^(EbN0dB(i)/10))/(16-1))));
end

figure;
semilogy(EbN0dB,symErrTheory,'r-');
hold on;
semilogy(EbN0dB,BER_QAM_MC,'b-');
legend('16QAM-BER Teórico','16QAM- BER SImulado');
xlabel('Eb/N0(dB)');
ylabel('Bit Error Rate');