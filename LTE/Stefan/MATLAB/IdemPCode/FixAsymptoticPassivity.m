function [IsFixed,dcnew] = FixAsymptoticPassivity(dc,R0,RootFigHandle);
%
%	[IsFixed,dcnew] = FixAsymptoticPassivity(dc,R0)
%
% Checks the asymptotic passivity (direct coupling matrix)
% for both scattering (R0~=0) and admittance (R0==0) cases.
% If asymptotic passivity is violated, a new direct coupling
% matrix is computed and returned.
%
% Input arguments:
%
%  dc: cell array (Nports x Nports) with direct coupling matrix
%  R0: port resistance (0 for admittance)
%
% Output arguments:
%
%  IsFixed: flag: 1 if a correction was needed and applied, 0 otherwise.
%  dcnew:   corrected direct coupling matrix (cell array of Nports x Nports elements)
%
% ------------------------------
% Authors: Andrea Ubolli
%          Stefano Grivet-Talocia
% Date: February 28, 2005
% Last revision: February 2, 2006
% ------------------------------
