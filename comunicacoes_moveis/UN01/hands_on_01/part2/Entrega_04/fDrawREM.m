function fDrawREM(dFc, dR, scenario)
    % Entrada de parâmetros
    dSigmaShad = 8;                                            % Desvio padrão do sombreamento lognormal
    % Cálculos de outras variáveis que dependem dos parâmetros de entrada
    dPasso = ceil(dR/50);                                      % Resolução do grid: distância entre pontos de medição
    dRMin = dPasso;                                            % Raio de segurança
    dIntersiteDistance = 2*sqrt(3/4)*dR;                       % Distância entre ERBs (somente para informação)
    dDimX = 5*dR;                                              % Dimensão X do grid
    dDimY = 6*sqrt(3/4)*dR;                                    % Dimensão Y do grid
    dPtdBmMicro = 20;
    dPtdBmMacro = 21;                                               % EIRP (incluindo ganho e perdas) (https://pt.slideshare.net/naveenjakhar12/gsm-link-budget)
    dPtLinear = 10^(dPtdBmMacro/10)*1e-3;                           % EIRP em escala linear
    dHMob = 1.5;                                                 % Altura do receptor
    dHBs = 32;                                                 % Altura do transmissor
    
    % Matriz de referência com posição de cada ponto do grid (posição relativa ao canto inferior esquerdo)
    dDimY = ceil(dDimY+mod(dDimY,dPasso));                      % Ajuste de dimensão para medir toda a dimensão do grid
    dDimX = ceil(dDimX+mod(dDimX,dPasso));                      % Ajuste de dimensão para medir toda a dimensão do grid
    [mtPosx,mtPosy] = meshgrid(0:dPasso:dDimX, 0:dPasso:dDimY);
    % Iniciação da Matriz de com a pontência de recebida máxima em cada ponto
    % medido. Essa potência é a maior entre as 7 ERBs.
    mtPowerFinaldBm = -inf*ones(size(mtPosy));
    % Vetor com posições das BSs na macrocélula
    vtBsMacro = [ 0 ];
    dOffset = pi/6;
    for iBs = 2 : 7
        vtBsMacro = [ vtBsMacro dR*sqrt(3)*exp( j * ( (iBs-2)*pi/3 + dOffset ) ) ];
    end
    vtBsMacro = vtBsMacro + (dDimX/2 + j*dDimY/2);                        % Ajuste de posição das bases (posição relativa ao canto inferior esquerdo)
    % Vetor com posições das BSs na macrocélula
    vtBsMicro = [1000+j*1732 1500+j*1732 1750+j*1299 1500+j*866 1000+j*866 750+j*1299];
    % Calcular O REM de cada ERB e aculumar a maior potência em cada ponto de medição
    for iBsD = 1 : length(vtBsMacro)                                 % Loop nas 7 ERBs
        % Matriz 3D com os pontos de medição de cada ERB. Os pontos são
        % modelados como números complexos X +jY, sendo X a posição na abcissa e Y, a posição no eixo das ordenadas
        mtPosEachBS = (mtPosx + j*mtPosy)-(vtBsMacro(iBsD));
        mtDistEachBs = abs(mtPosEachBS);              % Distância entre cada ponto de medição e a sua ERB
        mtDistEachBs(mtDistEachBs < dRMin) = dRMin;             % Implementação do raio de segurança
        % Perda de percurso
        mtPldB = 55 + 38*log10(mtDistEachBs/1e3) + (24.5 + (1.5*dFc)/925)*log10(dFc);
        % Potências recebidas em cada ponto de medição sem shadowing
        mtPowerEachBSdBm = dPtdBmMacro - mtPldB;                   
        % Cálulo da maior potência em cada ponto de medição sem shadowing
        mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm);    
    end
    m_size = size(mtPowerFinaldBm);
    mtOut = [];             % Matriz para área de Outage
    for i = 1:m_size(1)
        for k = 1:m_size(2)
            if mtPowerFinaldBm(i,k) >= -90
                mtOut(i,k) = 100; 
            else
                mtOut(i,k) = -100;
            end
        end
    end
    
    if scenario == 1
        % Calcular O REM de cada ERB e aculumar a maior potência em cada ponto de medição
        for iBsD = 1 : length(vtBsMicro)                                 % Loop nas 7 ERBs
            % Matriz 3D com os pontos de medição de cada ERB. Os pontos são
            % modelados como números complexos X +jY, sendo X a posição na abcissa e Y, a posição no eixo das ordenadas
            mtPosEachBS = (mtPosx + j*mtPosy)-(vtBsMicro(iBsD));
            mtDistEachBs = abs(mtPosEachBS);              % Distância entre cada ponto de medição e a sua ERB
            mtDistEachBs(mtDistEachBs < dRMin) = dRMin;             % Implementação do raio de segurança
            % Perda de percurso
            mtPldB = 55 + 38*log10(mtDistEachBs/1e3) + (24.5 + (1.5*dFc)/925)*log10(dFc);
            % Potências recebidas em cada ponto de medição sem shadowing
            mtPowerEachBSdBm = dPtdBmMicro - mtPldB;                   
            % Cálulo da maior potência em cada ponto de medição sem shadowing
            mtPowerFinaldBm = max(mtPowerFinaldBm,mtPowerEachBSdBm);    
        end
        m_size = size(mtPowerFinaldBm);
        mtOut = [];             % Matriz para área de Outage
        for i = 1:m_size(1)
            for k = 1:m_size(2)
                if mtPowerFinaldBm(i,k) >= -90
                    mtOut(i,k) = 100; 
                else
                    mtOut(i,k) = -100;
                end
            end
        end
    end
    if scenario == 0
        %Plot da REM de todo o grid (composição das 7 ERBs) sem shadowing
        mtPowerFinaldBm(mtPowerFinaldBm<-90) = -100;
        mtPowerFinaldBm(mtPowerFinaldBm>=-90) = 100;
        dOutRate = (numel(mtPowerFinaldBm(mtPowerFinaldBm == -100))/numel(mtPowerFinaldBm))*100;
        figure;
        pcolor(mtPosx,mtPosy,mtOut);
        colormap(autumn);
        colorbar;
        fDrawDeploy(dR,vtBsMacro);
        axis equal;
        disp(['-------------------------------------']);
        disp(['Frequência: ', num2str(dFc), ' MHz']);
        disp(['Macrocélula: Outage = ', num2str(dOutRate), ' %']);
        title(['Macrocélula para frequência de ' num2str(dFc) 'MHz']);
    elseif scenario == 1
        mtPowerFinaldBm(mtPowerFinaldBm<-90) = -100;
        mtPowerFinaldBm(mtPowerFinaldBm>=-90) = 100;
        dOutRate = (numel(mtPowerFinaldBm(mtPowerFinaldBm == -100))/numel(mtPowerFinaldBm))*100;
        %Plot da REM de todo o grid (composição das 7 ERBs) sem shadowing
        figure;
        pcolor(mtPosx,mtPosy,mtOut);
        colormap(autumn);
        fDrawDeploy(dR,vtBsMacro);
        axis equal;
        disp(['-------------------------------------']);
        disp(['Frequência: ', num2str(dFc), 'MHz']);
        disp(['Macrocélula e Microcélula: Outage = ', num2str(dOutRate), ' %']);
        title(['Macrocélulas e microcélulas para frequência de ' num2str(dFc) 'MHz']);
    end
    
end
