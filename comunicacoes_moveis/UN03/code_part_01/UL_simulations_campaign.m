% PURPOSE: Skeleton for modeling simulation campaign to evaluate SINR on
% Uplink. Prot�tipo em software para modelagem da SINR do enlace reverso em
% um sistema WCDMA com uma camada de interfer�ncia co-canal e reuso 1 
%
% USAGE: UL_simulations_campaign
%
% INPUTS:
%  - 
%
% OUTPUTS:
%  - Several files with simulation data
%
% EXAMPLE: UL_simulations_campaign
%
% SEE ALSO: fUL_sim
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR(S): Vicente 
% LAST UPDATE: 2015-05-31 at 16:00h
% REFERENCES:
% COPYRIGHT 2015 by UFRN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dica: comente a linha a seguir para debugar (sen�o os breakpoints s�o deletados
% a cada execu��o do programa) 
clear all;close all;clc;
tic
%
% Cell radius to simulate [m]
vtdR = [ 50 100 500 2000 10000 ];
% Number of cell radius to simulate
ndR = length( vtdR );
% System load (users per cell to simulate)
vtUsersPerCell = [ 10 50 200 1000 ];
% Number of System load points to simulate
nUsr = length( vtUsersPerCell );
% Monte Carlo Repetitions (it can be a vector)
vtRep = 1000;
% Number of  Monte Carlo Repetitions points to simulate
nTotalRep = length( vtRep );
% Monte Carlo Repetitions Loop
for iRep = vtRep 
    resultFolder = ['sim_Rep_' num2str(iRep)];    
    % Cell radius Loop
    for idR = 1 : ndR
        clc;
        % Display simulation campaign status information
        disp([num2str( 100 * (idR * nUsr )/ ( ndR * nUsr ) ) ' % of all simulations have already done...']);
        % Current cell radius
        dR = vtdR( idR );
        % User per cell (load) loop
        for iusr = 1 : nUsr
            % Current load
            dUserPerSector = vtUsersPerCell( iusr );
            % Display simulation information
            disp(['Running simulation with cell Radius of ' num2str(dR) ' and load of ' num2str(dUserPerSector) '...']);
            % Run simulation
            fUL_sim_Skelenton( dUserPerSector, dR, iRep, resultFolder );
            %
        end
    end
end
% display simulation campaing duration
CampTime = toc;
disp(['Simulation campaing duration = ' num2str(CampTime) ' s']);