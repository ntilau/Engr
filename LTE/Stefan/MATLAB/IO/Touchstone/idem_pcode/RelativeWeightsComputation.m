function [Weights] = RelativeWeightsComputation(DUM,MaxResponses,pindex,alpha,threshold,ir,ic)
%
%	Weights = RelativeWeightsComputation(DUM,MaxResponses,pindex,alpha,threshold,ir,ic)
%
% Computation of relative frequency-dependent weights for element (ir,ic) of the transfer matrix.
% Weights are defined as
%
%	1/abs(DUM.S{ir,ic}.^alpha)
%
% with an additional check that the denominator does not grow too large for small response values.
%
% Input arguments:
%
%   DUM:          data structure
%   MaxResponses: matrix storing the maximum magnitude for each response
%   pindex:       selector matrix for the responses being modeled
%   alpha:        exponent for the computation of the relative weights
%   threshold:    threshold used to avoid excessively large weights 
%   ir:           row index correponding to current response
%   ic:           column index correponding to current response
%
% Output arguments:
%
%   Weights:      frequency-dependent Weighting vector for the response (ir,ic).
%
% -------------------------------
% Authors: Andrea Ubolli
%          Stefano Grivet-Talocia
% Date: April 6, 2006
% Last revision: April 27, 2006
% -------------------------------
