function [stdShad,meanShad,dNEst, vtEnvNorm] = fParameters01_02(dW)
    % Carrega o sinal real
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
    % Cálculo reta de perda de percurso
    vtDistLog = log10(vtDist);
    vtDistLogEst = log10(vtDistEst);
    % Cálculo do coeficientes da reta que melhor se caracteriza a perda de percurso
    dCoefReta = polyfit(vtDistLogEst,vtPrxdBm,1); 
    % Expoente de perda de percurso estimado
    dNEst = -dCoefReta(1)/10;
    %
    % Sombreamento
    vtShadCorrEst = vtDesLarga - vtPathLossEst;
    % Calcula a variância do sombreamento estimado
    stdShad = std(vtShadCorrEst);
    meanShad = mean(vtShadCorrEst);
    
    % Cálculo da envoltória normalizada (para efeitos de cálculo do fading)
    indexes = dMeiaJanela+1 : nSamples-dMeiaJanela;
    %vtPrxW = ((10.^(vtPrxdBm(indexes)./10))/1000);
    vtPtrxmWNew = [];
    for i = 1:length(indexes)
        vtPtrxmWNew(i) = 10.^(vtPrxdBm(i)/10);
    end
    desPequeEst_Lin = (10.^(vtDesPequeEst(1:length(indexes))./10));
    vtEnvNorm = sqrt(vtPtrxmWNew)./sqrt(desPequeEst_Lin);
 
end