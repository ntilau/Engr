function [MOD,Happ,err] = FDVF(DUM,Order,Bandwidth,Options,RootFigHandle);
%
%	[MOD,Happ,err] = FDVF(DUM,Order,Bandwidth,Options)
%
% Performs the Frequency-Domain Vector Fitting macromodeling of
% linear multiport structure DUM, returning the model in
% structure MOD. The output is returned in Poles-Residues form.
%
%  Order:      Number of poles to be estimated. This corresponds
%              to the number of initial poles of the FD-VF algorithm
%  Bandwidth:  Frequency bandwidth to be investigated. The 
%              set of initial poles is initialized to span this
%              bandwidth. All the available frequency points in
%              DUM are used for fitting.
%
% Additional control parameters for FDVF algorithm can be passed in
% structure <Options>. The possible fields are listed below with defaults.
% If some fields are not provided, their default values are used.
% These defaults are returned by auxiliary function GetFDVFDefaultOptions.
%
%  Options.tol = 1e-4                (Threshold for stopping iterations)
%  Options.MaxIt = 4                 (Maximum number of iterations)
%  Options.p4poles = eye(DUM.Nports) (Responses selector for poles estimation)
%  Options.p4res = ones(DUM.Nports)  (Responses selector for residues computation)
%  Options.RejectPolesFactor = inf   (Relative bandwidth for rejection of high-frequency poles)
%
% Output parameters
%
%  MOD:   structure with the macromodel in poles-residues format
%  Happ:  cell array with fitted output responses
%  err:   maximum error in frequency responses obtained after iterations
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: February 26, 2003
% Last revision: March 31, 2005
% ------------------------------
