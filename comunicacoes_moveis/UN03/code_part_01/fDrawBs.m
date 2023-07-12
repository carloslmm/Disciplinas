function vtBs = fDrawBs( dR )
% PURPOSE: Returns ERBs positions for a 7-cell one interference tier
% deployment
%
% USAGE: vtBs = fDrawBs( dR )
%
% INPUTS:
%  - dR: Sector radius 
%
% OUTPUTS:
%  - vtBs: Vector containing the ERBs positions 
%
% EXAMPLE: vtBs = fDrawBs( 100 );
%
% SEE ALSO: 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR(S): Vicente 
% LAST UPDATE: 2015-05-31 at 16:00h
% REFERENCES:
% COPYRIGHT 2015 by UFRN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vtBs = [ 0 ];
offset = pi/6;
for iBs = 2 : 7
    vtBs = [ vtBs dR*sqrt(3)*exp( j * ( (iBs-2)*pi/3 + offset ) ) ];
end
