function [dc,RealPoles,ComplexPoles,RealResidues,ComplexResidues,Yapp] = ...
	VectorFitTime(rp,cp,taxis,X,Y,mustplot);
%
%	[dc,RealPoles,ComplexPoles,RealResidues,ComplexResidues,Yapp] = ...
%		VectorFitTime(rp,cp,taxis,X,Y,mustplot)
% 
% Applies the Vector Fitting procedure to estimate poles and
% residues of a rational approximation to the function H(s) relating
% output vector Y to input vector X (i.e., Y(s)=H(s)*X(s)).
% The time-domain samples of inputs and outputs are
% passed in input arguments X and Y, whereas the time axis storing
% the time samples is taxis. Note that uniform sampling is assumed.
% The order of the approximation
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
%   taxis:    vector of time samples
%   X:        Vector of time-domain samples of input waveform
%	Y:        Vector of time-domain samples of output waveform
%   mustplot: if nonzero, a figure with Y(t) and its approximation is generated
%
% Output parameters:
%
%	dc: direct coupling constant (value at s=inf of Happ(s))
%	RealPoles: vector of real poles
%	ComplexPoles: vector of complex poles (with positive imaginary part)
%   RealResidues: vector of residues of real poles
%   ComplexResidues: vector of residues of complex poles (with positive imaginary part)
%   Yapp: time-domain output produced by rational approximation of H.
%
% -----------------------------
% Author: Stefano Grivet-Talocia
% Date: February 7, 2003
% -----------------------------
