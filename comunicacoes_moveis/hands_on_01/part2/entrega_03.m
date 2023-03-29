% Entrada de parâmetros
dR = 200;                                                  % Raio do Hexágono
dFc = 800;                                                 % Frequência da portadora
dShad = 50;                                                % Distância de descorrelação do shadowing
dSigmaShad = 8;                                            % Desvio padrão do sombreamento lognormal
dAlphaCorr = [0.5, 0.3, 0.7];                                          % Coeficiente de correlação do sombreamento entre ERBs (sombreamento correlacionado)
% Cálculos de outras variáveis que dependem dos parâmetros de entrada
%dPasso = ceil(dR/10);                                     % Resolução do grid: distância entre pontos de medição
dPasso = 10;
dRMin = dPasso;                                            % Raio de segurança
dIntersiteDistance = 2*sqrt(3/4)*dR;                       % Distância entre ERBs (somente para informação)
%
% Cálculos de outras variáveis que dependem dos parâmetros de entrada
dDimXOri = 5*dR;                                           % Dimensão X do grid
dDimYOri = 6*sqrt(3/4)*dR;                                 % Dimensão Y do grid

% Matriz de referência com posição de cada ponto do grid (posição relativa ao canto inferior esquerdo)
dDimY = ceil(dDimYOri+mod(dDimYOri,dPasso));                      % Ajuste de dimensão para medir toda a dimensão do grid
dDimX = ceil(dDimXOri+mod(dDimXOri,dPasso));                      % Ajuste de dimensão para medir toda a dimensão do grid
[mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
mtPontosMedicao = mtPosx + j*mtPosy;
vtStdMtSha = [];
for i = 1:length(dAlphaCorr)
    % Calcula o sombreamento correlacionado de um dAlphaCorr especifíco
    for j = 1:100 
        mtShadowingCorr = fCorrShadowing(mtPontosMedicao,dShad,dAlphaCorr(i),dSigmaShad,dDimXOri,dDimYOri);
        vtStdMtSha(j) = std(mtShadowingCorr,0,'all');
    end
    
    disp(['_________________________']);
    disp(['Desvio padrão de sombreamento: ' num2str(dSigmaShad)]);
    disp(['Coeficiente de correlação do sombreamento entre ERBs: ' num2str(dAlphaCorr(i))]);
    disp(['Desvio padrão das amostras de sombreamento correlacionado: ' num2str(mean(vtStdMtSha))]);
end
    
    

