Frq = [800 1800 2100];     % Frequência da Portadora
R = 500;                    % Raio do Hexágono
scenario = 0;                % Valores: 0 (Macrocélula), 1 (Microcélula)
for i = 1:length(Frq)
    fDrawREM(Frq(i),R, scenario);       % REM usando somente macrocélula
end
scenario = 1;
for i = 1:length(Frq)
    fDrawREM(Frq(i),R, scenario);       % REM usando macro e micro células
end