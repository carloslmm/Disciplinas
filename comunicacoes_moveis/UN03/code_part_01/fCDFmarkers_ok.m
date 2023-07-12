function fCDFmarkers_ok(varargin)
% put different markers and colors for a given set of graphic handles
% INPUTS:
% - graphics handles separeted by comma
% - the last parameters specify the number of markers to be added (for
% curves with a lot of samples)
%
% OUTPUTS:
% - graphics with pre-defined color and markers. One can hardcoded define colors in
% chvtColor and markers in chvtMarker. This function support up to 6
% different curves
% usage: fcdfmarkers( handle_1, handle_2, handle_3, handle_4, handle_5, handle_6, 10 );
%
% Vicente Sousa, 2004

% Get input vector
%vthand = cell2mat(varargin(1));
vthand = varargin( 1 );
vthand = vthand{1};

chvtMarker = ['s';'o';'*';'>';'h';'^'];
chvtColor = ['r';'b';'k';'m';'c';'g'];
% 
% chvtMarker = ['>';'s';'o';'*'];
% chvtColor = ['m';'r';'b';'k'];

mtchColor1 = [ ];
mtchColor2 = [ ];
mtchMarker1 = [ ];
mtchLine1 = [ ];
mtchLine2 = [ ];
dJump = length( vthand );
for il = 1:dJump
    mtchColor1 = [mtchColor1; {[chvtColor(il,:) '-' chvtMarker(il,:)]} ];
    mtchMarker1 = [mtchMarker1; {[chvtColor(il,:) chvtMarker(il,:)]} ];
    mtchLine1 = [mtchLine1; {[chvtColor(il,:) '-']} ];
end
chColMarLine = [mtchColor1];
chColorMarker = [mtchMarker1];
chColorLine = [mtchLine1];

% Read input variables
% for ik=1:( length(varargin)-1 )
%     if (iscell(varargin))
%         chCommand = ['hand' num2str(ik) ' = cell2mat(varargin(' num2str(ik) '));'];
%     else
%         chCommand = ['hand' num2str(ik) ' = varargin(' num2str(ik) ');'];
%     end
%     eval(chCommand);
% end


% Read input variables
for ik= 1 : length( vthand )
    chCommand = ['hand' num2str(ik) ' = vthand(' num2str(ik) ');']; 
    eval(chCommand);
end

if (iscell(varargin))
    dNSamples = cell2mat(varargin(end));
else
    dNSamples = varargin(end);
end

for ix=1:length( vthand )
    chCommandX = [ 'x' num2str(ix) ' = get(hand' num2str(ix) ', ' '''xdata''' ');'];
    eval(chCommandX);
end

for iy=1:length( vthand )
    chCommandY = [ 'y' num2str(iy) ' = get(hand' num2str(iy) ', ' '''ydata''' ');' ];
    eval(chCommandY);
end

for is=1:length( vthand )
    chCommandS = [ 'samp' num2str(is) ' = floor( linspace(1,length(y' num2str(is) '), dNSamples) );'];
    eval(chCommandS);
end

close all;
figure;
hold on;
box on;
grid on;

for ip=1:length( vthand )
    chCommandP = ['p' num2str(ip) '= plot(x' num2str(ip) ',y' num2str(ip) ',[' '''' cell2mat(chColMarLine(ip,:)) '''' ']);'];
    eval(chCommandP);
    chCommandP1 = ['set(p' num2str(ip) ',' '''visible''' ', ' '''off''' ',' '''linewidth''' ', 3,' '''MarkerSize''' ',12 );'];
    eval(chCommandP1);
end

for im=1:length( vthand )
    chCommandM = ['marker' num2str(im) ' = plot(x' num2str(im) '(samp' num2str(im) '),y' num2str(im) '(samp' num2str(im) '), [' '''' cell2mat(chColorMarker(im,:)) '''' ']);'];
    eval(chCommandM);
    chCommandM1 = [ 'set(marker' num2str(im) ', ' '''Tag''' ', ' '''marker1''' ', ' '''linewidth''' ', 3 , ' '''MarkerSize''' ', 12 );'];
    eval(chCommandM1);
end

for ipf=1:length( vthand )
    chCommandPf =  [ 'p' num2str(ipf) ' = plot(x' num2str(ipf) ', y' num2str(ipf) ' , [' '''' cell2mat(chColorLine(ipf,:)) '''' ']);'];
    eval(chCommandPf);
    chCommandPf1 = ['set(p' num2str(ipf) ', ' '''linewidth''' ', 3 );'];
    eval(chCommandPf1);
end

