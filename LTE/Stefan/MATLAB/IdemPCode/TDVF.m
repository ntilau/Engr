function [MOD,tapp,Yapp,err] = TDVF(DUM,Order,Bandwidth,Options,RootFigHandle);
%
%	[MOD,tapp,Yapp,err] = TDVF(DUM,Order,Bandwidth,Options)
%
% Performs the Time-Domain Vector Fitting macromodeling of
% linear multiport structure DUM, returning the model in
% structure MOD. The output is returned in Poles-Residues form.
%
%  Order:      Number of poles to be estimated. This corresponds
%              to the number of initial poles of the TD-VF algorithm
%  Bandwidth:  Frequency bandwidth to be investigated. The input
%              and output sequences are resampled with a sampling
%              rate corresponding to this Nyquist frequency. Also,
%              the set of initial poles is initialized to span this
%              bandwidth
%
% Additional control parameters for TDVF algorithm can be passed in
% structure <Options>. The possible fields are listed below with defaults.
% If some fields are not provided, their default values are used.
% These defaults are returned by auxiliary function GetTDVFDefaultOptions.
%
%  Options.tol = 1e-4                (Threshold for stopping iterations)
%  Options.MaxIt = 4                 (Maximum number of iterations)
%  Options.OversamplingFactor = 1    (Oversampling factor w.r.t Nyquist frequency)
%  Options.AntiOverfittingFactor = 0.33 (Maximum ratio between unknowns and constraints)
%  Options.p4poles = eye(DUM.Nports) (Responses selector for poles estimation)
%  Options.p4res = ones(DUM.Nports)  (Responses selector for residues computation)
%  Options.RejectPolesFactor = inf   (Relative bandwidth for rejection of high-frequency poles)
%  Options.NoDC = 0                  (Flag for excluding direct coupling from rational approximation)
%
% Output parameters
%
%  MOD:   structure with the macromodel in poles-residues format
%  tapp:  cell array with resampled time axes used to estimate poles and residues
%  Yapp:  cell array with fitted output responses
%  err:   maximum error in time responses obtained after iterations
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: February 26, 2003
% Last revision: February 23, 2005
% ------------------------------
