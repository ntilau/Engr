function DUMMOD = MOD2DUM(MOD,DUM,TimeExtensionFactor,RootFigHandle);
%
%	DUMMOD = MOD2DUM(MOD,DUM)
%	DUMMOD = MOD2DUM(MOD,DUM,TimeExtensionFactor)
%
% This function computes the time and frequency responses
% of the model stored in structure MOD and stores them 
% with appropriate format in structure DUM. MOD can be
% in either Poles/Residues of ABCD form. The former representation is
% used for computation of the responses. If not available,
% the function MODFill is used to generate it. Both sparse
% and non-sparse formats of MOD are supported.
% The output structure DUMMOD is generated in order to
% use the same fields structure as additional input structure
% DUM. In particular, the fields that are used to generate
% the responses are:
%
%   DUM.Nports
%   DUM.pindex
%   DUM.istime
%   DUM.t
%   DUM.Ts
%   DUM.a
%   DUM.isfreq
%   DUM.f
%
% The other fields are just copied to the output structure without
% modification. The third argument is used to produce the responses
% using a longer duration than the available time axis in DUM.
% Use 1.0 as a placeholder in order to use the same
% time axis of DUM in case also the fourth argument is present.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: July 15, 2004
% Last revision: July 12, 2006
% ------------------------------
