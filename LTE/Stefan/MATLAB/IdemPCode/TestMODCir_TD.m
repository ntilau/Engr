function TestMODCir_TD(SPICETYPE,pathname,testname,Nports,R0,MODcirname,sourcename,Tstep,Tmax,i_excited_port,GroundReferences);
%
%	function TestMODCir_TD(SPICETYPE,pathname,testname,Nports,R0,MODcirname,sourcename,Tstep,Tmax,i_excited_port,GroundReferences)
%
% This function is intended for validation of macromodels using Time-Domain Spice
% simulations. It is assumed that a state-space macromodel has already been synthesized
% into a Spice subcircuit whose basename is MODcirname, and stored in directory pathname.
% This function generates a PSpice/WinSpice (according to the argument SPICETYPE) executable
% having basename testname. All Nports ports of the macromodel are terminated into their
% reference resistance R0. Note that R0=0 indicates admittance representation. A single
% PWL source is applied to a port indexed by i_excited_port, with time samples stored in a
% library '.lib' file named sourcename. The printing time step and the maximum time for the
% transient analysis are Tstep and Tmax. If SPICETYPE equals 'PSPICE', the results are
% written by a .PROBE statement in CSDF format to output file with the same basename and
% with extension '.csd' or '.txt', according to the PSpice version being used. If SPICETYPE
% equals 'WINSPICE', results are written by a save statement to a rawfile in csv format.
% This function is run automatically by SpiceMOD2DUM.
% The additional (optional) input parameter GroundReferences
% determines how the reference nodes for all ports are generated. 
% If set to 0 (default), each port in the synthesized circuit will have a
% "private" (floating) reference node. If it is set to 1, all
% ports will share a common reference node. The latter option is
% useful for grounded multiports.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 29, 2003
% Last revison: (1)March 9, 2004
%               (2)May 17, 2005
% ------------------------------
