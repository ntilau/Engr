function [dc,RealPoles,ComplexPoles,RealResidues,ComplexResidues,Happ,MaxResponses] = ...
	MultiVectorFitPD(rp,cp,DUM,p4poles,p4res,Weights,dc_enforced,H0_enforced,mustplot,FigLogHandle); 
%
%	[dc,RealPoles,ComplexPoles,RealResidues,ComplexResidues,Happ] = ...
%		MultiVectorFitPD(rp,cp,DUM,p4poles,p4res,Weights,dc_enforced,H0_enforced,mustplot)
% 
% Applies the Vector Fitting procedure to estimate poles and
% residues of a rational approximation to a matrix transfer function H(s).
% The frequency-domain samples of H(s) are passed in input argument DUM.
% The order of the approximation equals the number of fake poles required
% by vector fitting. Such poles are passed in arrays rp (real poles) and cp
% (complex poles with positive imaginary part).
% Also a direct coupling coefficient (value at s=inf) is
% included in the rational approximation.
%
% With respect to MultiVectorFit, the additional arguments Weights,
% dc_enforced, H0_enforced are used to control frequency- and/or response-dependent
% weighting and explicit enforcement of high and low frequency
% asymptotic values of the model.
%
% Input parameters:
%
%   rp:          vector containing all initial real poles
%   cp:          vector containing all initial complex poles with positive imaginary part
%   DUM:         structure with full frequency-domain specification of the multiport.
%   p4poles:     subset of ports to be used for the identification of the system poles
%   p4res:       subset of ports to be used for the generation of the macromodel
%   Weights:     structure with frequency-dependent and response-rependent weights specification
%   dc_enforced: if a cell array of DUM.Nports size, the entries are used as constraints
%                for the direct coupling matrix (infinite-frequency constraint).
%   H0_enforced: if a cell array of DUM.Nports size, the entries are used as constraints
%                for the zero-frequency matrix (zero-frequency constraint).
%   mustplot:    if nonzero, a figure with H(om) and its rational approximation is generated
%
% Output parameters:
%
%	dc: cell array with direct coupling constants (values at s=inf of Happ(s))
%	RealPoles: vector of real poles
%	ComplexPoles: vector of complex poles (with positive imaginary part)
%   RealResidues: cell array with in each cell vector of residues in real poles
%   ComplexResidues: cell array with in each cell vector of residues in complex poles (with positive imaginary part)
%   Happ: cell array with rational (complex) approximation of H at input frequency points.
%   MaxResponses: matrix storing the maximum magnitude among all frequencies for all responses (used for weights)
%
% ------------------------------
% Authors: Stefano Grivet Talocia
%          Andrea Ubolli
% Date: February 11, 2003
% Last revision: April 27, 2006
% ------------------------------
