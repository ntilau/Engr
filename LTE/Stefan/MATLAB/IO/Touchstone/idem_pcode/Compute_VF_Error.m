function [errp,err] = Compute_VF_Error(DUM,Options,Happ,MaxResponses);
%
% [errp,err] = Compute_VF_Error(DUM,Options,Happ,MaxResponses);
%
% Compute errors between model responses and raw data.
% Two error indicators are computed:
%
% - errp: RMS error used for poles computation
%         This gives and indication of poles convergence. This error
%         indicator takes frequency and response-dependent weighting
%         into account
% - err:  maximum inf-norm deviation between all responses used for
%         residues evaluation. This gives a measure of how good is
%         the entire model. There is no reason why this indicator
%         should converge.
%
% Input arguments include
%
% DUM:          data structure
% Options:      modeling options structure used to recoved which responses
%               are used for poles and/or residues computation, and the
%               weighting scheme.
% Happ:         frequency response of the model
% MaxResponses: maximum magnitude of each response among all frequencies
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 27, 2006
% ------------------------------
