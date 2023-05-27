clear all; clc; close all
% Parâmetros
T = 500;                      % Tempo de símbolo OFDM
Ts = 2;                       % Tempo de símbolo em portadora única
K = T/Ts;                     % Número de subportadoras independentes
K = 64;
N = 2*K;                      % DFT de N pons
%
SM = [-1 +1];
SM_16 = [-3-3i -3-1i -3+1i -3+3i -1-3i -1-1i -1+1i -1+3i 1-3i 1-1i 1+1i 1+3i 3-3i 3-1i 3+1i 3+3i];
M = 16; % 16 QAM
msg = 100000;
n_bits = K*msg;                % Número de bits
EbN0dB = 0:5:30;
snrdb = EbN0dB;%+10*log10(log2(2)*(K/K));
for j = 1:length(EbN0dB)
    % Gerar bits aleatórios
    dataIn=randi([0 1],1,n_bits);   % Sequência de números entre 0 e 1 uniformemente distribuídos
    %dataIn=sign(dataIn-.5);  % Sequência de -1 e 1
    % Conversor serial paralelo
    %dataInMatrix = reshape(dataIn,n_bits/4,4);
    %
    % Gerar constelaçao 16-QAM
    %seq16qam = 2*dataInMatrix(:,1)+dataInMatrix(:,2)+1i*(2*dataInMatrix(:,3)+dataInMatrix(:,4)); 
    %seq16=seq16qam';
    % Garantir propriedadade da simetria
    %X = [seq16 conj(seq16(end:-1:1))];
    Vn = SM(dataIn + 1);
    mtSeqQam = reshape(Vn, msg, K);    
    
    mtOfdmTx = ifft (mtSeqQam);
    
    
    seqOfdmTx = reshape (mtOfdmTx,1,msg*K); 
    Eb = seqOfdmTx*seqOfdmTx'/length(seqOfdmTx); % Energia do bit
    N0 = Eb*10.^(-snrdb(j)/10);
    wgn = sqrt(N0/2) * [1 1i] * randn(2, length(seqOfdmTx));
        
    %Eb=1;
    %N0 = Eb*10^(EbN0dB(i)/10);
    %sigmas = N0/2;
    %signal_QAM = ifft(X);

    
    % Adição de ruído
    %variance = sigmas;
    %noise = sqrt(variance)*randn(1,N)+1i*sqrt(variance)*randn(1,N);
    %
    % sinal recebido = xn + ruído 
    rn = seqOfdmTx + wgn;
    
    mtOfdmRxNoise = reshape(rn,msg,K);
    % FFT do rn
    %Y = fft(rn);
    %
    % Plots
    mtOfdmRx = fft(mtOfdmRxNoise);
    seqOfdmRx =  reshape (mtOfdmRx,1,msg*K);
    %scatterplot(seqOfdmRx)
    ah = (seqOfdmRx > 0); % Decisao
    nErrs = sum(xor(dataIn, ah));
    %hold on
    %{  
    scatter(real(seq16),imag(seq16), 'r', '+')
    hold off
    title(['Sinal com ruído de variância ', num2str(N0/2)]);
    % Demodulação  
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
    %}
    disp(['Para variância de ', num2str(N0/2), ' houve ', num2str(nErrs), ' símbolos errados.']);
    ber(j) = nErrs;
end

semilogy(snrdb,ber)

