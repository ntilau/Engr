function Name = ScanForValidMOD(varstruct);
%
%	Name = ScanForValidMOD(varstruct)
%
% This function accepts as input a structure obtained by loading a
% MAT-file. The structure stores as its fields all variables found in
% the MAT-file. This function scans for valid MOD these variables and
% returns as output its name (the name of the corresponding field in the
% input structure). If more than one MOD is found, only the first is found.
% If no valid MOD is found, an empty string is returned.
%
% Note: extraction of the desired variable from the structure can be
% performed by the variable-field expression below
%
%    varstruct.(Name)
%
% A valid MOD is defined only through a check on existence of its mandatory
% fields, i.e.
%
% MOD.isABCD
% MOD.isResPoles
% MOD.issparse
% MOD.R0
% MOD.D
%
% and at least one of the two following lists, according to the isABCD and
% isResPoles fields,
%
% MOD.A
% MOD.B
% MOD.C
%
% MOD.RealPoles
% MOD.ComplexPoles
% MOD.RealResidues
% MOD.ComplexResidues
