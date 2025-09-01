function DUMOUT = ReplicateDUMInput(DUM,weights,RootFigHandle);
%
%	DUMOUT = ReplicateDUMInput(DUM,weights)
%
% This function produces a new data structure DUMOUT
% having input excitations replicated throughout the
% time axis. More precisely, if a(t) is an input signal
% in DUM, the corresponding signal in DUMOUT is
%
%  a_OUT(t) = \sum_{n=1}^N  weights(n) * a(t-T_n)
%
% The shifts T_n are determined by uniform subdivision of
% the available time axis in DUM for each port. The inputs are zero-padded
% on the left. The output responses are modified accordingly.
%
% This function should be used to generate responses to
% persistent excitations starting from, e.g., excitation
% signals with single Gaussian pulses (as for FDTD solvers).
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: January 31, 2003
% Last revision: April 11, 2003
% ------------------------------
