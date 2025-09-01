function conversion_factor = FindConversionFactor(oldunit,newunit);
%
%	conversion_factor = FindConversionFactor(oldunit,newunit)
%
% This function finds the ratio between new unit and old unit.
% Input arguments are specified as strings. The first character ot
% each string determines the unit being used. The other characters
% are not used, thus allowing for processing different physical units.
% Allowed values are 'f','p','n','u','m','k','M','G','T'. If no match
% is found with these values standard units are assumed.
