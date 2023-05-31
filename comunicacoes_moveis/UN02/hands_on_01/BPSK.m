clear all; clc;close all
EbN0dB = 0:1:14;

BER_TEO = zeros(0,length(EbN0dB));
for ik = 1:length(EbN0dB)
    for jk = 1:500
        N=100000;
        d=rand(1,N)>0.5; %data generation
        X=2*d-1; %BPSK modulation
        
        % Convertendo bit para símbolo no sinal BPSK
        bpskSymbols = (-1)*pskmod(double(d), 2);
        
        %Sinal OFDM
        ofdmsym_sp = ifft(reshape(X,length(X)/50, 50));
        xn = reshape(ofdmsym_sp,1,length(X));
        
        % Adição de ruído
        Eb = xn*xn'/length(xn);
        N0 = Eb*10.^(-EbN0dB(ik)/10);
        wgn = sqrt(N0/2) * [1 j] *  randn(2, length(xn));

        rn = xn + wgn;
        
        %Adição de ruído no sinal sem OFDM 
        Eb = bpskSymbols*bpskSymbols'/length(bpskSymbols);
        N0 = Eb*10.^(-EbN0dB(ik)/10);
        wgn2 = sqrt(N0/2) * [1 j] *  randn(2, length(xn));
        
        rn_sem_ofdm = bpskSymbols + wgn2; 
        
        Rt_freq = fft(reshape(rn,length(rn)/(50),50));
        Y = reshape(Rt_freq,1,length(xn));
        
        %Demodulação sem OFDM
        bits_recebidos_sem_ofdm = sign(real(rn_sem_ofdm));
        
        %Demodulação OFDM BPSK 
        bits_recebidos = sign(real(Y));

        %BER Simulado
        BER_SIM_OFDM(jk) = sum(bits_recebidos ~= X)/length(X);
        BER_SIM_S_OFDM(jk) = sum(bits_recebidos_sem_ofdm ~= X)/length(X); 
        
    end
    %BER teórico
    BER_TEO(ik) = 0.5*erfc(sqrt(10^(EbN0dB(ik)/10)));
    %BER simulado
    BER_SIM_MC_OFDM(ik) = mean(BER_SIM_OFDM);
    BER_SIM_MC_S_OFDM(ik) = mean(BER_SIM_S_OFDM);
end

semilogy(EbN0dB, BER_TEO, 'r-', 'LineWidth', 2); 
hold on;
semilogy(EbN0dB, BER_SIM_MC_OFDM, 'b-', 'LineWidth', 1.5);
semilogy(EbN0dB, BER_SIM_MC_S_OFDM, 'k^', 'MarkerSize', 8);

xlabel('Eb/N0 (dB)');
ylabel('Taxa de Erro de Bit (BER)');
title('Comparação da BER teórica e simulada');
legend('Teórico', 'OFDM-BPSK', 'BPSK', 'Location', 'best');
grid on;
