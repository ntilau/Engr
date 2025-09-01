function [dc,RealPoles,ComplexPoles,RealResidues,ComplexResidues,Yapp] = ...
	MultiVectorFitTime(rp,cp,DUM,p4poles,p4res,Nskip,NoDC,mustplot,RootFigHandle);
%
%	[dc,RealPoles,ComplexPoles,RealResidues,ComplexResidues,Yapp] = ...
%		MultiVectorFitTime(rp,cp,DUM,p4poles,p4res,Nskip,NoDC,mustplot)
% 
% Applies the Time-Domain Vector Fitting procedure to estimate poles and
% residues of a rational approximation to a matrix transfer function H(s).
% The transfer function relates time responses to time excitations stored
% passed in structure argument DUM. The order of the approximation
% equals the number of fake poles required by vector fitting.
% Such poles are passed in arrays rp (real poles) and cp
% (complex poles with positive imaginary part).
% Also a direct coupling coefficient (value at s=inf) is
% included in the rational approximation.
%
% Input parameters:
%
%   rp:       vector containing all initial real poles
%   cp:       vector containing all initial complex poles with positive imaginary part
%   DUM:      structure with full t-domain specification of the multiport.
%             See details in readme.txt
%   p4poles:  subset of ports to be used for the identification of the system poles
%   p4res:    subset of ports to be used for the generation of the macromodel
%   Nskip:    time axis decimation factor for generation of L.S. matrices
%   NoDC:     if nonzero, direct coupling is not included in the rational approximation
%   mustplot: if nonzero, a figure with true and approximated time responses is generated
%
% Output parameters:
%
%	dc: cell array with direct coupling constants (values at s=inf of Happ(s))
%	RealPoles: vector of real poles
%	ComplexPoles: vector of complex poles (with positive imaginary part)
%   RealResidues: cell array with in each cell vector of residues in real poles
%   ComplexResidues: cell array with in each cell vector of residues in complex poles (with positive imaginary part)
%   Yapp: cell array with time-domain outputs produced by the rational approximation.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: February 25, 2003
% Last revision: February 23, 2005
% ------------------------------
