function GroundReferences = FindReferenceType(pathname,MODcirname,spicetype);
%
%   GroundReferences = FindReferenceType(pathname,MODcirname,spicetype);
%
% This function scans a subcircuit file in directory <pathname> and
% with name <MODcirname> (plus .cir extension if <spicetype> is 'SPICE')
% and looks for the model interface port specification. If the reference
% terminal for all ports is identical the returned output is
% GroundReferences=1, otherwise a 0 is returned. The supported languages
% are standard SPICE and ASTAP.
% An empty output argument is returned in case of errors during opening or
% scanning the circuit file.
% This function is called automatically from SpiceMOD2DUM and AstapMOD2DUM.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: July 18, 2006
% ------------------------------
