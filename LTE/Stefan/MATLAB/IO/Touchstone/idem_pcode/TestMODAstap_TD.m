function TestMODAstap_TD(pathname,testname,Nports,R0,MODcirname,sourcename,Tstep,Tmax,i_excited_port,GroundReferences);
%
%	TestMODAstap_TD(pathname,testname,Nports,R0,MODcirname,sourcename,Tstep,Tmax,i_excited_port,GroundReferences)
%
% This function is intended for validation of macromodels using
% transient Time-Domain PowerSPICE (ASTAP) simulations. It is assumed that a
% state-space macromodel has already been synthesized into
% an ASTAP subcircuit whose basename is <MODcirname>, and placed
% in directory <pathname>. This function
% generates a PowerSPICE executable source having basename <testname>.
% All Nports ports of the macromodel are terminated into their reference
% resistance R0. Note that R0==0 indicates admittance representation.
% A single PWL source is applied to
% a port indexed by i_excited_port, with time samples stored in
% a model file whose basename is <sourcename>.
% The printing time step and the maximum time for the transient
% analysis are Tstep and Tmax.
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
% Last revison: (1)June 10, 2003
%               (2)May 17, 2006
% ------------------------------
