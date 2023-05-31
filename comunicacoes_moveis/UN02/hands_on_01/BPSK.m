clear all; clc;close all

N=100000;
d=rand(1,N)>0.5; %data generation
X=2*d-1; %BPSK modulation

%Sinal OFDM
ofdmsym_sp = ifft(reshape(X,length(X)/50, 50));
xn = reshape(ofdmsym_sp,1,length(X));

EbN0dB = 0:1:14;

Eb = 1;

sigmas= zeros(0,length(EbN0dB));             % Vetor de variâncias do ruído
for i = 1:length(EbN0dB)
    N0 = Eb*10^(-EbN0dB(i)/10);
    sigmas(i) = N0/2;
end

BER_TEO = zeros(0,length(EbN0dB));
for ik = 1:length(sigmas)
    for jk = 1:500
        %
        % Adição de ruído
        variance = sigmas(ik);
        noise = sqrt(variance)*randn(1,N)+1i*sqrt(variance)*randn(1,N);

        rn = xn + noise;

        Rt_freq = fft(reshape(rn,length(rn)/(50),50));
        Y = reshape(Rt_freq,1,length(xn));

        %Demodulação BPSK 

        bits_recebidos = sign(real(Y));

        %BER Simulado
        BER_SIM(jk) = sum(bits_recebidos ~= X)/length(X);
    end
    %BER teórico
    BER_TEO(ik) = 0.5*erfc(sqrt(10^(EbN0dB(ik)/10)));
    %BER simulado
    BER_SIM_MC(ik) = mean(BER_SIM);
end

semilogy(EbN0dB,BER_TEO,'r-');
hold on;
semilogy(EbN0dB,BER_SIM_MC,'b*');
legend('BPSK-BER Teórico','BPSK- BER Simulado');
xlabel('Eb/N0(dB)');
ylabel('Bit Error Rate (BER)');
