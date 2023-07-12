function [vtPosSector] = fPosUsrSector(dUsrPerSector, dCenter, dR )
% PURPOSE: Returns users positions inside hexagonal sector
%
% USAGE: [vtSectorPos] = fPosUsrSector(dUserPerSector, dCenter, dR)
%
% INPUTS:
%  - dUserPerSector: Number of users per sector
%  - dCenter: Position of the Hexagonal center relative to central BS
%  - dR: Sector radius in Km
%
% OUTPUTS:
%  - vtPosSector: Vector containing the users positions 
%
% EXAMPLE: [vtPosSector] = fPosUsrSector(100, cos(pi/3)+j*sin(pi/3), 1);
%
% SEE ALSO: fDrawUsr and fPosUsrBS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR(S): Yuri, Tarcisio, Waltemar, Vicente e Carlos
% LAST UPDATE: 2001-02-02 at 16:00h
% REFERENCES:
% COPYRIGHT 2001-2002 by Ericsson/UFC Cooperation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vtPosSector=zeros(1,0);
if(dUsrPerSector>0)
    
    p = (rand(1, 2*dUsrPerSector).'-0.5 + j*(rand(1,2*dUsrPerSector).'-0.5))*(2*dR);
    %p = (rand(1, 2*dUsrPerSector) + j*(rand(1,2*dUsrPerSector)))*(dR);
    
    vtPosSector = p;
    
    ang = angle(p)*180/pi;
    
    sector = floor(((ang < 0) * 360 + ang)/60);
    sector = [sector sector sector+1 sector+1];
    sector = sector * pi/3;
    
    sector(:,1) = dR.*cos(sector(:,1)) - real(p);
    sector(:,3) = dR.*cos(sector(:,3)) - real(p);
    
    sector(:,2) = dR.*sin(sector(:,2)) - imag(p);
    sector(:,4) = dR.*sin(sector(:,4)) - imag(p);
    
    cr = cross([sector(:,1:2) zeros(length(p),1)], [sector(:,3:4) zeros(length(p),1)]);
    cr = find((cr(:,3)>0));
    
    vtPosSector = vtPosSector(cr) + dCenter;
    
    if length(vtPosSector) < dUsrPerSector
        vtPosSector = fPosUsrSector(dUsrPerSector, dCenter, dR );
    else
        vtPosSector = vtPosSector(1:dUsrPerSector);   
    end
   
end