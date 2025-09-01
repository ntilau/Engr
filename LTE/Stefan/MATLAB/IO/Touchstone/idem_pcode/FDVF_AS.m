function MOD = FDVF_AS(DUM,Bandwidth,Options,RootFigHandle);
%
%	MOD = FDVF_AS(DUM,Bandwidth,Options)
%
% Applies the Frequency-Domain Vector Fitting with Adding and Skimming
% (FDVF-AS) macromodeling algorithm to linear multiport structure
% DUM, returning the model in structure MOD.
% The FDVF-AS algorithm combines a flexible splitting of the
% entire transfer matrix with an iterative order selection strategy.
% The latter is controlled by several parameters allowing for
% small noise sensitivity and quasi-optimal order selection of
% the macromodel. Input arguments are:
%
%  DUM:        structure with the frequency-domain dataset to be fitted
%  Bandwidth:  Frequency bandwidth to be investigated. The 
%              set of initial poles is initialized to span this
%              bandwidth. All the available frequency points in
%              DUM are used for fitting.
%
% Additional control parameters can be passed in
% structure <Options>. The possible fields are listed below (with defaults).
% If some fields are not provided, their default values are used.
% These defaults are returned by auxiliary function GetFDVF_AS_DefaultOptions.
%
%  Parameters for error and convergence control
%	
%	Options.GuaranteedAccuracy = 0.1; % Accuracy level to be reached in any case
%	Options.alpha = 0.01; % Threshold for the detection of error stagnation
%	Options.tol = 1e-3; % Accuracy for stopping iterations
%	Options.NBackStepsErr = 3; % Number of previous iterations to check for error stagnation
%	Options.gamma = 0.001; % Threshold for energy-based skimming
%	Options.FinalSkimmingThreshold = 0.001; % Threshold on error variation for elimination of redundant poles
%
%  Parameters for model order selection
%	
%	Options.Nstart = 4; % Starting order
%	Options.Nadd = 2; % Order increment for the Adding process. Must be even.
%	Options.Nmax = 30; % Maximum allowed order
%
%  Parameters for VF iteration control
%	
%	Options.InitialIter = 1; % Number of VF iterations @ starting order
%	Options.PostAddingIter = 1; % Number of VF iterations during intermediate VF runs
%	Options.FinalIter = 1; % Number of VF iterations @ final order
%
%  Parameters for port splitting and response selection
%	
%	Options.SplitType = 'column'; % Type of ports splitting
%	Options.p4poles = 'eye'; % Responses to be used for poles estimation
%	Options.p4res = 'all'; % Responses to be used for residues calculation
%	Options.Nlargest = inf; % Number of largest responses to be used for poles identification at each FDVF step
%
%  Parameters for frequency-based poles rejection
%
%	Options.RejectPolesFactor = inf; % Relative bandwidth for rejection of high-frequency poles
%
% The output macromodel MOD has a format that depends on the port splitting
% strategy that was employed to generate it. Note that this function includes
% all features of basic FDVF and FDVF_Split algorithms. Therefore, refer also to
% the functions FDVF and FDVF_Split for additional details.
%
% ------------------------------
% Author: Michelangelo Bandinu
%         Stefano Grivet-Talocia
% Date: February 15, 2005
% Last revision: March 31, 2005
% ------------------------------
