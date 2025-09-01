function [NewWeights,ErrWeight] = CheckWeights(Weights, Nports, faxis);
%
%	[NewWeights,ErrWeight] = CheckWeights(Weights, Nports, faxis)
%
% Checks for correct specification of frequency-dependent and
% response-dependent weights for LS.
%
% Input arguments:
%
%   Weights: structure with specification of the weighting scheme
%     .Responses: Nports x Nports matrix storing response-wise weights.
%     .Type: selects the type of frequency weighting scheme 
%            0: relative error control. In this case, each individual
%               response (ir,ic) is weighted according to
%
%                   w{ir,ic} = 1/abs(DUM.S{ir,ic}.^alpha)
%
%               in order to control relative error (alpha=1),
%               absolute error (alpha=0) or any intermediate
%               error (0<alpha<1).
%            1: absolute error control. In this case, a single (constant)
%               frequency weighting mask is used for all responses.
%     .Data: used only if Weights.Type==1
%            2-column array. First column is a set of frequency points
%            Second column stores the weights associated to the
%            coresponding frequencies. Log-interpolation is used
%            to construct the entire set of frequency-dependent weights
%            so that in NewWeights the mask has the frequency points
%            exactly corresponding to faxis
%     .Alpha: used only if Weights.Type==0
%            the exponent used for the normalization in the relative
%            error control case
%     .RelThreshold: used only if Weights.Type==0
%            Threshold on relative Weights to avoid excessively large
%            weights coming from very small values of H.
%     NB: an empty argument (Weight=[]) should be used to disable any weighting
%
%   Nports:  number of ports (needed to check for consistency)
%   faxis:   the frequency samples used to construct the frequency-dependent
%            array of weights
%
% Output arguments:
%
%   NewWeights: same as Weights above. However, in case of absolute error contorl,
%               the field .Data stores
%               the frequency-dependent array of weights, compatible with
%               faxis, obtained by interpolation. An empty variable is returned
%               in case of errors.
%   ErrWeight:  detects inconsistencies in weights specification if true.
%
% ------------------------------
% Authors: Stefano Grivet Talocia
%          Andrea Ubolli
% Date: March 2, 2005
% Last revision: March 2, 2005
% ------------------------------
