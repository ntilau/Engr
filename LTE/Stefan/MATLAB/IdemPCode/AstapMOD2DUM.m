function DUMSpice = AstapMOD2DUM(pathname,MODcirname,DUM,mode,Tstep,RootFigHandle);
%
%	DUMSpice = AstapMOD2DUM(pathname,MODcirname,DUM,mode,Tstep)
%
% This function computes the transient/AC responses of the
% Astap equivalent circuit in file <MODcirname>,
% via iterative PowerSPICE runs. For each run a single port is excited.
% The results of the PowerSPICE simulation are read from RAW files
% and stored in the standard format in output structure DUM.
% All files are placed and read from directory pathname.
% The input argument DUM stores the original dataset used to
% compute the macromodel. It is used for selection of the
% port excitations. Note that after this function has been used,
% a call to 'ShowDUMvsMOD(DUMSpice,MOD)' can be used to compare
% the PowerSPICE- and MATLAB-generate responses of the macromodel.
% Time and/or frequency domain analyses are performed according
% to the settintgs in input structure DUM. If time-domain analysis
% is required, the optional last argument Tstep is the time step
% required during the transient SPICE simulation. If missing, the same
% time step of the original raw data is used. In any case, the
% results are resampled after simulation to match the time axes stored in DUM.
% The fourth mandatory argument <mode> determines the type of
% action to be performed. It must be a string equal to
%
%   'run':   PowerSPICE is run automatically and results are processed
%   'norun': Only input simulation files are prepared
%   'load':  Results are just read from previously generated PowerSPICE runs
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 29, 2003
% Last revision: June 15, 2005
% ------------------------------
