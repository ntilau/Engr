function MOD = TDVF_ColumnWise(DUM,Order,Bandwidth,Options,RootFigHandle);
%
%	MOD = TDVF_ColumnWise(DUM,Order,Bandwidth,Options)
%
% Performs the Time-Domain Vector Fitting macromodeling of
% linear multiport structure DUM, returning the model in
% structure MOD. The overall set of port responses is
% splitted into different subsets (to handle multiports
% with large number of ports) corresponding to each column of the
% transfer matrix (with suitable modifications in case of reciprocity).
% The other input arguments are
%
%  Order:      Number of poles to be estimated. This corresponds
%              to the number of initial poles of the TD-VF algorithm.
%              This can be either a scalar (the same number of poles is
%              used for all columns) or a vector (storing the number of
%              poles to be used for each column). Alternatively,
%              Order can be a four-element cell array storing the
%              minimum, increment, and maximum order among all columns of the
%              transfer matrix, and an accuracy threshold.
%              The actual order will be automatically
%              determined through iterations until an accuracy threshold
%              is met (or the maximum order is reached).
%  Bandwidth:  Frequency bandwidth to be investigated. The input
%              and output sequences are resampled with a sampling
%              rate corresponding to this Nyquist frequency. Also,
%              the set of initial poles is initialized to span this
%              bandwidth
%
% Additional control parameters can be passed in
% structure <Options>. The possible fields are listed below with defaults.
% If some fields are not provided, their default values are used.
% These defaults are returned by auxiliary function GetTDVFSplitDefaultOptions.
%
%  Options.tol = 1e-4                (Threshold for stopping iterations for each port subset)
%  Options.MaxIt = 4                 (Maximum number of iterations for each port subset)
%  Options.OversamplingFactor = 1    (Oversampling factor w.r.t Nyquist frequency)
%  Options.AntiOverfittingFactor = 0.33 (Maximum ratio between unknowns and constraints)
%  Options.RejectPolesFactor = inf   (Relative bandwidth for rejection of high-frequency poles for each port subset)
%  Options.Nlargest = inf            (Used to select only Nlargest responses for each poles identification step)
%  Options.NoDC = 0                  (Flag for excluding direct coupling from rational approximation)
%
% The output macromodel MOD is returned in both Poles/Residues and
% State Space format. Note that all matrices in MOD are sparse.
%
% A graphical illustration of the progress through iterations is shown
% in a dedicated figure. The transfer matrix entries are mapped to
% different colors according to their use, with the following notation
%
%  black:  no data available
%  blue:   response is available and is to be processed
%  yellow: responses being used for poles identification
%  red:    additional responses that will be used at current step to compute residues
%
% Reciprocity is handled by using all appropriate responses (merging any
% off-diagonal pair).
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 16, 2003
% Last revision: February 23, 2005
% ------------------------------
