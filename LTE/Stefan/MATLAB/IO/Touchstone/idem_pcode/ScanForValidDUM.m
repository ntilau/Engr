function Name = ScanForValidDUM(varstruct);
%
%	Name = ScanForValidDUM(varstruct)
%
% This function accepts as input a structure obtained by loading a
% MAT-file. The structure stores as its fields all variables found in
% the MAT-file. This function scans for valid DUM these variables and
% returns as output its name (the name of the corresponding field in the
% input structure). If more than one DUM is found, only the first is found.
% If no valid DUM is found, an empty string is returned.
%
% Note: extraction of the desired variable from the structure can be
% performed by the variable-field expression below
%
%    varstruct.(Name)
%
% A valid DUM is defined only through a check on existence of its mandatory
% fields, i.e.
%
% DUM.Nports
% DUM.pindex
% DUM.istime
% DUM.isfreq
% DUM.R0
% DUM.isreciprocal
%
% and at least one of the two following lists, according to the istime and
% isfreq fields,
%
% DUM.t
% DUM.a
% DUM.b
% DUM.Ts
%
% DUM.f
% DUM.S
% DUM.Fmax
