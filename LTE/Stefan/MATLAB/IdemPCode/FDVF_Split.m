function MOD = FDVF_Split(DUM,Order,Bandwidth,Options,RootFigHandle);
%
%	MOD = FDVF_Split(DUM,Order,Bandwidth,Options)
%
% Performs the Frequency-Domain Vector Fitting macromodeling of
% linear multiport structure DUM, returning the model in
% structure MOD. The overall set of port responses is
% splitted into different subsets (to handle multiports
% with large number of ports). This port responses splitting
% is controlled by the fields in control structure Options (see
% below). The other input arguments are
%
%  Order:      Number of poles to be estimated. This corresponds
%              to the number of initial poles of the FD-VF algorithm
%  Bandwidth:  Frequency bandwidth to be investigated. The 
%              set of initial poles is initialized to span this
%              bandwidth. All the available frequency points in
%              DUM are used for fitting.
%
% Additional control parameters can be passed in
% structure <Options>. The possible fields are listed below with defaults.
% If some fields are not provided, their default values are used.
% These defaults are returned by auxiliary function GetFDVFSplitDefaultOptions.
%
%  Options.tol = 1e-4                (Threshold for stopping iterations for each port subset)
%  Options.MaxIt = 4                 (Maximum number of iterations for each port subset)
%  Options.RejectPolesFactor = inf   (Relative bandwidth for rejection of high-frequency poles for each port subset)
%  Options.SplitType = 'column'      (Type of port splitting. Can also be 'all' and 'row')
%  Options.Nlargest = inf            (Used to select only Nlargest responses for each poles identification step)
%
% The output macromodel MOD is returned in both Poles/Residues and
% State Space format. Note that all matrices in MOD are sparse.
%
% A graphical illustration of the progress through iterations is shown
% in a dedicated figure. The transfer matrix entries are mapped to
% different colors according to their use, with the following notation
%
%  black:  no data available
%  gray:   response is available and is to be processed
%  yellow: responses being used for poles identification
%  red:    additional responses that will be used at current step to compute residues
%
% Reciprocity is handled by using all appropriate responses (merging any
% off-diagonal pair).
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 22, 2003
% Last revision: March 31, 2005
% ------------------------------
