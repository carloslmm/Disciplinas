function PL = OkumuraHata(fc, ht, hr, d, flag )
% PURPOSE: C�lculo de perda de percurso com modelo OKUMURA HATA em dB
%
% USAGE: PL = OkumuraHata(fc, ht, hr, d, flag )
%
% INPUTS:
%
%  - fc: frequencia em MHz
%  - ht: altura da antena transmissora  (Tx) em metros
%  - hr: altura da antena receptora (Rx) em metros
%  - d: dist�ncia entre Tx e Rx em kilometros
%  - flag: Ambiente:
%    1. Urbano cidade grande
%    2. Urbano cidade pequena/media
%
% OUTPUTS:
%  - PL: perda em dB
%
% EXAMPLE: OkumuraHata(1950, 30, 1.5, 1, 1 )
%
% SEE ALSO: fUL_sim_Skelenton
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTHOR(S): Vicente 
% LAST UPDATE: 2015-05-31 at 16:00h
% REFERENCES:
% COPYRIGHT 2015 by UFRN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Cálculo da váriavel a do modelo Okumura-Hata
    if flag == 2
        ahm = (1.1 * log10(fc) - 0.7)*hr - (1.56 * log10(fc) - 0.8);
    else
        ahm = (1.1 * log10(fc) - 0.7) * hr - (1.56 * log10(fc) - 0.8);
    end
    
    % Cálculo da perda do percurso Okumura-Hata
    PL = 69.55 + 26.16 * log10(fc) - 13.82 * log10(ht) - ahm + (44.9 - 6.55 * log10(ht)) * log10(d);
