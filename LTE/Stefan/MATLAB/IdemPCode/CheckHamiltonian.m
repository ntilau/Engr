function [IsPassive,MODpassive] = CheckHamiltonian(MOD,fvect,Options,RootFigHandle);
%
%	[IsPassive,MODpassive] = CheckHamiltonian(MOD,fvect,Options)
%
% This function processes the macromodel stored in MOD,
% and applies the passivity check and compensation algorithms
% using the spectral properties of the associated Hamiltonian matrix.
% The macromodel must be in state-space form.
% The additional optional argument fvect stores the frequency axis
% to be used for the graphical display.
% If this argument is missing, no frequency sweep is performed.
% If a passivity violation occurs, and output argument MODpassive is present,
% a compensation is attempted by modifying system matrix C. The iterations stop
% when the compensation is achieved or the maximum number of iterations
% is reached. Graphical illustration of the algorithms is performed according
% to the visualization options (see below). Fine control of the
% algorithm parameters can be exploited through various parameters
% passed in the (optional) structure Options. The possible fields
% are indicated below with the defults values (used if the
% corresponding fields are missing). Default values are returned
% by auxiliary function GetHamiltonianDefaultOptions.
%
%	%--------------------------------
%	% Parameters for algorithm control
%	%--------------------------------
%	Options.EigRelErr = 10000*eps; % Relative threshold for detection of imaginary eigenvalues
%	Options.EigAbsErr = 10000*eps; % Absolute threshold for detection of imaginary eigenvalues
%	Options.BandFact = 0.3; % Portion of the bandwidth (<0.5) that the target location for eigenvalues is allowed to span
%	Options.DCFact = 2; % Amplification factor of target location for eigenvalues limit if the left edge is DC
%	Options.BoundRelTol = 0.1; % Relative threshold for passivity violation bounds
%	Options.BoundAbsTol = 1e-3; % Absolute threshold for passivity violation bounds
%	Options.FastBound = 0; % Flag for fast evaluation of only one bound for passivity violation (obsolete)
%	Options.FixDC = 1; % Flag for enforcing minimal perturbation of the DC level
%	Options.MaxIterations = 100; % Maximum number of iterations for the passivity compensation
%	Options.MustPause = 0; % Flag for stopping the algorithm at each iteration
%	%------------------------------------
%	% Parameters for visualization control
%	%------------------------------------
%	Options.NoFigures = 0; % Suppression of all plots
%	Options.MustPlotHamEigs = 0; % Plot of all eigenvalues of Hamiltonian matrix
%	Options.MustMovie = 0; % Movie plot showing convergence of passivity violation bounds
%	Options.MustPlotBounds = 1; % Enable plotting of bounds estimates
%	Options.MustPlotErrorBounds = 1; % Enable plotting of errore on bounds estimates
%	Options.MustPlotBreakpoints = 1; % Enable plotting of breakpoints
%	Options.MustPlotSlopes = 1; % Enable plotting of slopes
%	Options.MustPlotNewEigs = 0; % Enable plotting of estimates of perturbed eigenvalues
%	Options.MustPlotSweep = 1; % Enable computation and graphical display of frequency sweep test
%	Options.MustHighlightViolations = 0; % Enable highlighting of points exceeding passivity threshold
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 4, 2003
% Last revision: July 14, 2005
% ------------------------------
