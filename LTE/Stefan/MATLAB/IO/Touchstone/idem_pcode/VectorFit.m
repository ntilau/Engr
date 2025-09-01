function [dc,RealPoles,ComplexPoles,RealResidues,ComplexResidues,Happ] = ...
	VectorFit(rp,cp,om,H,mustplot);
%
%	[dc,RealPoles,ComplexPoles,RealResidues,ComplexResidues,Happ] = ...
%		VectorFit(rp,cp,om,H,mustplot)
% 
% Applies the Vector Fitting procedure to estimate poles and
% residues of a rational approximation to the function H(s).
% The samples along the (positive) imaginary axis j*om are
% passed in input argument H. The order of the approximation
% equals the number of fake poles required by vector fitting.
% Such poles are passed in arrays rp (real poles) and cp
% (complex poles with positive imaginary part).
% Also a direct coupling coefficient (value at s=inf) is
% included in the rational approximation.
%
% Input parameters:
%
%   rp:       vector containing all initial real poles
%   cp:       vector containing all initial complex poles with
%             positive imaginary part
%   om:       vector of angular frequency values
%   H:        vector of complex function values at om points
%   mustplot: if nonzero, a figure with H(om) and its rational
%             approximation is generated
%
% Output parameters:
%
%	dc: direct coupling constant or value at s=inf of Happ(s)
%	RealPoles: vector of real poles
%	ComplexPoles: vector of complex poles (with positive imaginary part)
%   RealrResidues: vector of residues in real poles
%   ComplexResidues: vector of residues in complex poles (with positive imaginary part)
%   Happ: rational (complex) approximation of H at om points.
%
% -----------------------------
% Author: Stefano Grivet-Talocia
% Date: February 7, 2003
% -----------------------------
