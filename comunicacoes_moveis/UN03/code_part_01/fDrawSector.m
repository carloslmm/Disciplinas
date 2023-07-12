function fDrawSector(dR,dCenter)
% PURPOSE: plot an hexagonal sector
%
% USAGE: fDrawSector(dR,dCenter)
%
% INPUTS:
%  - dCenter: Position of the Hexagonal center relative to central BS
%  - dR: Sector radius in Km
%
% OUTPUTS:
%  - plot of an hexagonal sector
%
% EXAMPLE: fDrawSector( 10, 0 )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR(S): Yuri, Tarcisio, Waltemar, Vicente e Carlos
% LAST UPDATE: 2001-02-02 at 16:00h
% REFERENCES:
% COPYRIGHT 2001-2002 by Ericsson/UFC Cooperation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vtHex=zeros(1,0);
for ie=1:6
    vtHex=[vtHex dR*(cos((ie-1)*pi/3)+j*sin((ie-1)*pi/3))];
end
vtHex=vtHex+dCenter;

vtHexp=[vtHex vtHex(1)];

plot(vtHexp,'b');



