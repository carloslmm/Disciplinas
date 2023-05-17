function fPlot01_01(dW)
    % Lê canal gerado
    load('Prx_Real_2021_1.mat');
    vtDist = dPath';
    vtPrxdBm = dPrx';

    % Transforma potência em mWatts
    vtPtrxmW = 10.^(vtPrxdBm/10);
    nSamples = length(vtPtrxmW);

    % Vetores para canal estimado
    vtDesLarga = [];
    vtDesPequeEst = [];
    %
    % Cálculo do desvanecimenro lento e rápido
    dMeiaJanela = round((dW-1)/2);  % Meia janela
    ij = 1;
    for ik = dMeiaJanela + 1 : nSamples - dMeiaJanela
        % Desvanecimento de larga escala: perda de percurso + sombreamento [dB]
        vtDesLarga(ij) = 10*log10(mean(vtPtrxmW(ik-dMeiaJanela:ik+dMeiaJanela)));
        % Desvanecimento de pequena escala [dB]
        vtDesPequeEst(ij) = vtPrxdBm(ik)-vtDesLarga(ij);
        ij = ij + 1;
    end

    % Ajuste no tamanho dos vetores devido a filtragem
    vtDistEst = vtDist( dMeiaJanela+1 : nSamples-dMeiaJanela );
    vtPrxdBm = vtPrxdBm( dMeiaJanela+1 : nSamples-dMeiaJanela );
    %
    % Cálculo reta de perda de percurso
    vtDistLogEst = log10(vtDistEst);
    % Cálculo do coeficientes da reta que melhor se caracteriza a perda de percurso
    dCoefReta = polyfit(vtDistLogEst,vtPrxdBm,1); 
    % Perda de percurso estimada para os pontos de medição
    vtPathLossEst = polyval(dCoefReta,vtDistLogEst);  
    %
    % Sombreamento
    vtShadCorrEst = vtDesLarga - vtPathLossEst;

    % Potência recebida com canal completo
    plot(vtDistLogEst,vtPrxdBm); hold all;

    % Potência recebida somente com path loss
    plot(vtDistLogEst,vtPrxdBm-vtDesPequeEst-vtShadCorrEst,'linewidth', 2)

    % Potência recebida com path loss e shadowing
    plot(vtDistLogEst,vtPrxdBm-vtDesPequeEst,'linewidth', 2)
    xlabel('log_{10}(d)');
    ylabel('Potência [dBm]');
    legend('Prx canal completo', 'Prx (somente perda de percurso)', 'Prx (perda de percurso + sombreamento)');
    title(['Sinal real (W = ' num2str(dW) ' )']);
end