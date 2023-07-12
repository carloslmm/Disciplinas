function fUL_sim_Skelenton( dUserPerSector, dR, nRep, resultFolder )
% PURPOSE: Skeleton for modeling SINR on Uplink (simulation itself).
% Prot�tipo em software para modelagem da SINR do enlace reverso em
% um sistema WCDMA com uma camada de interfer�ncia co-canal e reuso 1 
%
% USAGE: fUL_sim( dUserPerSector, dR, nRep, resultFolder )
%
% INPUTS:
%  - dUserPerSector: Number of users per sector
%  - dR: Sector radius
%  - nRep: number of monte carlo repetitions
%  - resultFolder: folder to store simulation results
%
% OUTPUTS:
%  - Several files with simulation data
%
% EXAMPLE: fUL_sim( 10, 100, 10, 'sim_test' )
%
% SEE ALSO: fUL_sim
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR(S): Vicente 
% LAST UPDATE: 2015-05-31 at 16:00h
% REFERENCES:
% COPYRIGHT 2015 by UFRN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
% General Channel model parameters
ht = 30;
hr = 1.5;
fc = 1950;
Ga = 16; 
SF = 128;
% envFlag: Ambiente:
%    1. Urbano cidade grande
%    2. Urbano cidade pequena/media
envFlag = 1;
% Noise in dB
pn_dB = -106.98; % dB
% Noise in Linear
pn = (1e-3)*10^( pn_dB / 10 ); % mW
% Shadowing standard deviation
sigma = 8; %dB
% Transmitted power of interferers
ptx_all_dBm = 21;
ptx_all = 10^(ptx_all_dBm/10)*1e-3;
% Transmitted power of central cell
ptx_dBm = 21;
ptx = 10^(ptx_dBm/10)*1e-3;
% ERBs positioning
vtBs = fDrawBs( dR );
% Create the SINR vector to acummulate SINR values 
vtSINR = [ ];
% Evaluate users only on central sector
dCenter = vtBs( 1 );
% Create the users position vector
vtSectorPos = zeros( dUserPerSector, 1 );
%
for isim = 1: nRep
    %% Environment creation
    % Matriz com a posi��o (complexa) de cada usu�rio de cada uma das 7
    % ERBS (a posi��o � relativa a sua ERB servidora)
    % Nas linhas: usu�rios
    % Nas colunas: ERB
    for is = 1 : length( vtBs )
        dCenter = vtBs( is );
        mtSectorPos( :, is ) = fPosUsrSector( dUserPerSector, dCenter, dR );
    end
    % Dist�ncia dos usu�rios da c�lula central para a c�lula central
    dUserErbDistance = User2BSDistance( mtSectorPos, vtBs, 1 );
    % Pathloss 
    Lp_dB = OkumuraHata( fc, ht, hr, dUserErbDistance/1e3, envFlag );
    Lp = 10.^( Lp_dB ./ 10 );
    % Shadowing
    Xs = shadowing( sigma, dUserPerSector );
    % Evaluation of the vector of receive powers of desired users to the
    % server BS (central cell) (TODO: students implementation)
    vtPr = calculateReceivePower(Ga, Xs, ptx, Lp);
    %% Interfer�ncia
    mtInter = [];
    vtInterTotalPower = [];
    for ibInter = 2 : 7
        % Central BS to Interferer users distance (TODO: students implementation)
        vtInter2BSDistance = User2BSDistance( mtSectorPos, vtBs, ibInter );
        % Pathloss (TODO: students implementation)
        Lp_dB_Inter = OkumuraHata( fc, ht, hr, vtInter2BSDistance/1e3, envFlag );
        Lp_Inter = 10.^( Lp_dB_Inter ./ 10 );
        % Shadowing (TODO: students implementation)
        Xs_Inter = shadowing( sigma, dUserPerSector );
        % Interference power for user iusrInter
        vtInterPower = calculateReceivePower(Ga, Xs_Inter, ptx_all, Lp_Inter);
        % Interference power ( already combined per inteferer ERB )
        vtInterTotalPower = [ vtInterTotalPower; sum( vtInterPower ) ];
    end
    vtInter = sum( vtInterTotalPower );
    %% Eb/No evaluation (herein called SINR)
    SINR = SF * vtPr ./ ( vtInter + pn );
    SINR_dB = 10*log10( SINR ).';
    vtSINR = [ vtSINR   SINR_dB ];
end
filename = ['UL_sim_users_' num2str(dUserPerSector) '_cellRadius_' num2str(dR) '_rep_' num2str(nRep) '.mat' ];
[SUCCESS,MESSAGE,MESSAGEID] = mkdir(resultFolder);
cd(resultFolder);
simTime = toc;
save( filename, 'vtSINR', 'simTime' );
cd('../')

