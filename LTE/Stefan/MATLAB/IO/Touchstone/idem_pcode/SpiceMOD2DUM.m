function DUMSpice = SpiceMOD2DUM(pathname,MODcirname,DUM,mode,Tstep,RootFigHandle);
%
%	DUMSpice = SpiceMOD2DUM(pathname,MODcirname,DUM,mode,Tstep)
%
% This function computes the transient/AC responses of the
% Spice equivalent circuit in file <MODcirname>,
% via iterative SPICE runs. For each run a single port is excited.
% The results of the SPICE simulation are read from raw data files
% and stored in the standard format in output structure DUM.
% All files are placed and read from directory <pathname>.
% The input argument DUM stores the original dataset used to
% compute the macromodel. It is used for selection of the
% port excitations. Note that after this function has been used,
% a call to 'ShowDUMvsMOD(DUMSpice,MOD)' can be used to compare
% the SPICE- and MATLAB-generate responses of the macromodel.
% Time and/or frequency domain analyses are performed according
% to the settintgs in input structure DUM. If time-domain analysis
% is required, the optional last argument Tstep is the time step
% required during the transient SPICE simulation. If missing, the same
% time step of the original raw data is used. In any case, the
% results are resampled after simulation to match the time axes stored in DUM.
% The fourth mandatory argument <mode> determines the type of
% action to be performed. It must be a string equal to
%
%   'norun':   Only input simulation files are prepared
%   'run':     Previously prepared simulation files are run
%   'load':    Results are just read from previously generated SPICE runs
%   'fullrun': All the three operations above are performed
%
% The output argument DUMSpice is a structure storing the results
% of the simulations if mode is 'load'. Otherwise, an empty result
% indicates no errors. Error conditions are coded by non-empty
% and non-struct results.
%
% Sep 9, 2005 (CG): in all the 'unix' calls to run Winspice the double quotes
% have been added to take into account paths containing spaces. This to
% call Winspice, to load input file and to write output file.
% The output file writing does not work for a Winspice known bug.
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 29, 2003
% Last revision: September 9, 2005 
% ------------------------------
