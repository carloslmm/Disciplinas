% PURPOSE: Script for plotting simulations results for UL SINR. Prot�tipo
% em software para modelagem da SINR do enlace reverso em um sistema WCDMA com uma camada de interfer�ncia co-canal e reuso 1  
%
% USAGE: UL_plotting
%
% INPUTS:
%  - 
%
% OUTPUTS:
%  - Several files with simulation plots
%
% EXAMPLE: UL_plotting
%
% SEE ALSO: fUL_sim_Skelenton
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR(S): Vicente 
% LAST UPDATE: 2015-05-31 at 16:00h
% REFERENCES:
% COPYRIGHT 2015 by UFRN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;close all;clc;
% Cell radius to simulate
vtdR = [ 50 100 500 2000 10000]; % metros
% Number of cell radius to simulate
ndR = length( vtdR );
% System load (users per cell to simulate)
vtUsersPerCell = [ 10 50 200 1000 ];
% Number of System load points to simulate
nUsr = length( vtUsersPerCell );
% Monte Carlo Repetitions (it can not be a vector)
nRep = 1000;
% Mount results folder
resultFolder = ['sim_Rep_' num2str(nRep)];
% Define plot colors and markers
chvtColor = ['r-s';'b-o';'m-*';'c->';'g-h'];
%
% CDF for different cell radius (each line is a different value of load,
% i.e., users per cell). A set of figures, one for each Cell Radius.
%
% Cell radius Loop
for idR = 1 : ndR
    % Current cell radius 
    dR = vtdR( idR );
    % Create empty vectors to store plot handles and legend
    vtHandles = [];
    chLegend = [];
    % Get handle of figure 1 
    f1 = figure;    
    % Load loop
    for iusr = 1 : nUsr
        % Current load
        dUserPerSector = vtUsersPerCell( iusr );
        % Display process status information
        disp(['Processing simulation results with cell Radius of ' num2str(dR) ' and load of ' num2str(dUserPerSector) '...']);
        % Call for figure 1
        figure(f1);
        % Load results from file saved by simulation script
        filename = [resultFolder filesep 'UL_sim_users_' num2str(dUserPerSector) '_cellRadius_' num2str(dR) '_rep_' num2str(nRep) '.mat' ];
        load(filename);
        % Call CDF plot and store its handle
        handle = cdfplot(vtSINR);
        % Plot linhas together
        hold on;
        % Store lines handles for future configuration
        vtHandles = [vtHandles handle];
        % Store legend information for each line
        chLegend = [ chLegend ; {['User load of ' num2str( dUserPerSector )]} ];
    end
    figure( f1 );
    fCDFmarkers_ok( vtHandles, 20 );
    legend( chLegend );
    set(gca,'linewidth',3, 'fontsize',20,'FontWeight', 'bold');
    set(gcf,'Name','Simulation Results - UFRN - 2011','NumberTitle','off','color', [1 1 1]);
    outputFile = [ 'SINR_CDF_UserLoad_UL_sim_cellRadius_' num2str(dR) '_rep_' num2str(nRep) ];
    title(['CDF (Radius = ' num2str(dR) ', Repetitions = ' num2str(nRep) ')'] )
    ylabel(' CDF of SINR');
    xlabel('SINR [dB]');
    disp([ 'Saving file:  ' outputFile ] );
    cd( resultFolder );
    saveas(gcf, outputFile , 'fig')
    cd('../')
    close all;
    disp([num2str( 100 * (idR * nUsr )/ ( ndR * nUsr ) ) ' % of all simulations have already done...']);
end
%
% CDF for different system load (each line is a different value of cell
% radius). A set of figures, one for each sytrem load.
%
for iusr = 1 : nUsr
    dUserPerSector = vtUsersPerCell( iusr );
    vtHandles = [];
    chLegend = [];
    f2 = figure;
    for idR = 1 : ndR
        dR = vtdR( idR );
        disp(['Processing simulation results with load of ' num2str(dUserPerSector) ' and cell Radius of ' num2str(dR) '...']);
        filename = [resultFolder filesep 'UL_sim_users_' num2str(dUserPerSector) '_cellRadius_' num2str(dR) '_rep_' num2str(nRep) '.mat' ];
        load(filename);
        handle = cdfplot(vtSINR);
        hold on;
        vtHandles = [vtHandles handle];
        chLegend = [ chLegend ; {['Cell Radius of ' num2str( dR )]} ];
    end
    figure( f2 );
    fCDFmarkers_ok( vtHandles, 20 );
    legend( chLegend );
    set(gca,'linewidth',3, 'fontsize',20,'FontWeight', 'bold');
    set(gcf,'Name','Simulation Results - UFRN - 2011','NumberTitle','off','color', [1 1 1]);
    outputFile = [ 'SINR_CDF_CellRadius_UL_sim_load_' num2str(dUserPerSector) '_rep_' num2str(nRep) ];
    title(['CDF (Load = ' num2str(dUserPerSector) ', Repetiotions = ' num2str(nRep) ')'] )
    ylabel(' CDF of SINR');
    xlabel('SINR [dB]');
    disp([ 'Saving file:  ' outputFile ] );
    cd( resultFolder );
    saveas(gcf, outputFile , 'fig')
    cd('../')
    close all;
    disp([num2str( 100 * (ndR * iusr )/ ( ndR * nUsr ) ) ' % of all simulations have already done...']);
end
%
% A set of figures showing the average, 10th and 90th percentiles for different cell radius (each line is a different value of load,
% i.e., users per cell). A set of figures, one for each Cell Radius.
%
close all;
% Plot of average of metrics
f3 = figure;
% Plot of 10th percentile of metrics
f4 = figure;
% Plot of 90th percentile of metrics
f5 = figure;
chLegend = [];
for idR = 1 : ndR
    dR = vtdR( idR );
    vtAverageSINR  = [];
    vt10thSINR  = [];
    vt90thSINR  = [];
    for iusr = 1 : nUsr
        dUserPerSector = vtUsersPerCell( iusr );
        disp(['Processing simulation results with cell Radius of ' num2str(dR) ' and load of ' num2str(dUserPerSector) '...']);
        filename = [resultFolder filesep 'UL_sim_users_' num2str(dUserPerSector) '_cellRadius_' num2str(dR) '_rep_' num2str(nRep) '.mat' ];
        load(filename);
        vtAverageSINR  = [ vtAverageSINR mean( vtSINR ) ];
        vt10thSINR  = [ vt10thSINR prctile(vtSINR,10) ];
        vt90thSINR  = [ vt90thSINR prctile(vtSINR,90) ];
    end
    chLegend = [ chLegend ; {['Cell Radius of ' num2str( dR )]} ];
    %
    % Average SINR plot
    figure( f3 );
    plot( vtUsersPerCell, vtAverageSINR, chvtColor(idR,:) );
    hold on;
    legend( chLegend );
    set(gca,'linewidth',3, 'fontsize',20,'FontWeight', 'bold');
    set(gcf,'Name','Simulation Results - UFRN - 2011','NumberTitle','off','color', [1 1 1]);
    title(['Average SINR (Repetitions = ' num2str(nRep) ')'] )
    ylabel('Average SINR [dB]');
    xlabel('Load (users per cell)');
    %
    % 10th SINR plot
    figure( f4 );
    plot( vtUsersPerCell, vt10thSINR, chvtColor(idR,:) );
    hold on;
    legend( chLegend );
    set(gca,'linewidth',3, 'fontsize',20,'FontWeight', 'bold');
    set(gcf,'Name','Simulation Results - UFRN - 2011','NumberTitle','off','color', [1 1 1]);
    title(['10th percetile SINR (Repetitions = ' num2str(nRep) ')'] )
    ylabel('10th percetile SINR [dB]');
    xlabel('Load (users per cell)');
    %
    % 90th SINR plot
    figure( f5 );
    plot( vtUsersPerCell, vt90thSINR, chvtColor(idR,:) );
    hold on;
    legend( chLegend );
    set(gca,'linewidth',3, 'fontsize',20,'FontWeight', 'bold');
    set(gcf,'Name','Simulation Results - UFRN - 2011','NumberTitle','off','color', [1 1 1]);
    title(['90th percetile SINR (Repetitions = ' num2str(nRep) ')'] )
    ylabel('90th percetile SINR [dB]');
    xlabel('Load (users per cell)');
    %
    disp([num2str( 100 * (idR * nUsr )/ ( ndR * nUsr ) ) ' % of all simulations have already done...']);
end
% Saving plots
figure(f3);
outputFile = [ 'SINR_UsersLoadAverageSINR_UL_sim_rep_' num2str(nRep) ];
disp([ 'Saving file:  ' outputFile ] );
cd( resultFolder );
saveas(gcf, outputFile , 'fig')
cd('../')
%
figure(f4);
outputFile = [ 'SINR_UsersLoad10thSINR_UL_sim_rep_' num2str(nRep) ];
disp([ 'Saving file:  ' outputFile ] );
cd( resultFolder );
saveas(gcf, outputFile , 'fig')
cd('../')
%
figure(f5);
outputFile = [ 'SINR_UsersLoad90thSINR_UL_sim_rep_' num2str(nRep) ];
disp([ 'Saving file:  ' outputFile ] );
cd( resultFolder );
saveas(gcf, outputFile , 'fig')
cd('../')
%
%
% A set of figures showing the average, 10th and 90th percentiles for different system load (each line is a different value of cell
% radius). A set of figures, one for each sytrem load.
%
close all;
f6 = figure;
f7 = figure;
f8 = figure;
chLegend = [];
for iusr = 1 : nUsr
    dUserPerSector = vtUsersPerCell( iusr );
    vtAverageSINR  = [];
    vt10thSINR  = [];
    vt90thSINR  = [];
    for idR = 1 : ndR
        dR = vtdR( idR );   
        disp(['Processing simulation results with cell Radius of ' num2str(dR) ' and load of ' num2str(dUserPerSector) '...']);
        filename = [resultFolder filesep 'UL_sim_users_' num2str(dUserPerSector) '_cellRadius_' num2str(dR) '_rep_' num2str(nRep) '.mat' ];
        load(filename);
        vtAverageSINR  = [ vtAverageSINR mean( vtSINR ) ];
        vt10thSINR  = [ vt10thSINR prctile(vtSINR,10) ];
        vt90thSINR  = [ vt90thSINR prctile(vtSINR,90) ];
        
    end
    chLegend = [ chLegend ; {['User Load of ' num2str( dUserPerSector )]} ];
    % Average SINR plot
    figure( f6 );
    plot( vtdR, vtAverageSINR, chvtColor(iusr,:) );
    hold on;
    legend( chLegend );
    set(gca,'linewidth',3, 'fontsize',20,'FontWeight', 'bold');
    set(gcf,'Name','Simulation Results - UFRN - 2011','NumberTitle','off','color', [1 1 1]);
    title(['Average SINR (Repetitions = ' num2str(nRep) ')'] )
    ylabel('Average SINR [dB]');
    xlabel('Cell Radius (meters)');
    % 10th SINR plot
    figure( f7 );
    plot( vtdR, vt10thSINR, chvtColor(iusr,:) );
    hold on;
    legend( chLegend );
    set(gca,'linewidth',3, 'fontsize',20,'FontWeight', 'bold');
    set(gcf,'Name','Simulation Results - UFRN - 2011','NumberTitle','off','color', [1 1 1]);
    title(['10th percetile SINR (Repetitions = ' num2str(nRep) ')'] )
    ylabel('10th percetile SINR [dB]');
    xlabel('Cell Radius (meters)');    
    % 90th SINR plot
    figure( f8 );
    plot( vtdR, vt90thSINR, chvtColor(iusr,:) );
    hold on;
    legend( chLegend );
    set(gca,'linewidth',3, 'fontsize',20,'FontWeight', 'bold');
    set(gcf,'Name','Simulation Results - UFRN - 2011','NumberTitle','off','color', [1 1 1]);
    title(['90th percetile SINR (Repetitions = ' num2str(nRep) ')'] )
    ylabel('90th percetile SINR [dB]');
    xlabel('Cell Radius (meters)');
    
    disp([num2str( 100 * (idR * nUsr )/ ( ndR * nUsr ) ) ' % of all simulations have already done...']);
end
% Saving plots
figure(f6);
outputFile = [ 'SINR_CellRadiusAverageSINR_UL_sim_rep_' num2str(nRep) ];
disp([ 'Saving file:  ' outputFile ] );
cd( resultFolder );
saveas(gcf, outputFile , 'fig')
cd('../')
%
figure(f7);
outputFile = [ 'SINR_CellRadius10thSINR_UL_sim_rep_' num2str(nRep) ];
disp([ 'Saving file:  ' outputFile ] );
cd( resultFolder );
saveas(gcf, outputFile , 'fig')
cd('../')
%
figure(f8);
outputFile = [ 'SINR_CellRadius90thSINR_UL_sim_rep_' num2str(nRep) ];
disp([ 'Saving file:  ' outputFile ] );
cd( resultFolder );
saveas(gcf, outputFile , 'fig')
cd('../');
close all;
disp('All plots are saved and closed.')