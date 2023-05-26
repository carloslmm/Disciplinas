clear all; clc;close all
Nfft=64; msg = 100; %n ́umero total de subportadoras
Na = Nfft*msg; %Tamanho da mensagem (em bits)
a = randi([01], 1, Na);
SM = [-1 +1];
amt = reshape(a, msg, Nfft); %Simbolo transmitido pelas subportadoras
Vn = SM(a + 1); %

EbN0dB = 0:1:14;

Eb = 1;

sigmas= zeros(0,length(EbN0dB));             % Vetor de variâncias do ruído
for i = 1:length(EbN0dB)
    N0 = Eb/10^(EbN0dB(i)/10);
    sigmas(i) = N0/2;
end

Vntime = ifft(Vn);
vtvntime = reshape (Vntime, 1,Na);

BER_TEO = zeros(0,length(EbN0dB));
for ik = 1:length(sigmas)
    %
    % Adição de ruído
    variance = sigmas(ik);
    noise = sqrt(variance)*[1 j] * randn(2, length(vtvntime));

    rt = vtvntime + noise;
    Rtfreq = fft(rt);
    
    %BER teórico

    BER_TEO(ik) = 0.5*erfc(sqrt(10^(EbN0dB(ik)/10)));
    
end

semilogy(EbN0dB,BER_TEO,'r-');
hold on;
legend('BPSK-BER Teórico','BPSK- BER SImulado');
xlabel('Eb/N0(dB)');
ylabel('Symbol Error Rate (Ps)');
