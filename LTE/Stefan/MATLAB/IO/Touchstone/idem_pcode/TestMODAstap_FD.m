function TestMODAstap_FD(pathname,testname,Nports,R0,MODcirname,Fmin,Fmax,NFSamples,i_excited_port,GroundReferences);
%
%	TestMODAstap_FD(pathname,testname,Nports,R0,MODcirname,Fmin,Fmax,NFSamples,i_excited_port,GroundReferences)
%
% This function is intended for validation of macromodels using
% Frequency-Domain PowerSPICE (ASTAP) simulations. It is assumed that a
% state-space macromodel has already been synthesized into
% an ASTAP subcircuit whose basename is <MODcirname>, and placed
% in directory <pathname>. This function
% generates a PowerSPICE executable source having basename <testname>.
% All Nports ports of the macromodel are terminated into their reference
% resistance R0. Note that R0==0 indicates admittance representation.
% A single unitary AC source with linear spacing is applied to
% a port indexed by i_excited_port, with frequency samples determined
% by argumsnts Fmin, Fmax, and NFSamples. Note that if Fmin is zero,
% a new Fmin is used equal to Fmax/NFSamples/10.
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
% Last revison: (1)June 7, 2003
%               (2)May 17, 2006
% ------------------------------
