function outstring = CheckRealRangeAB(editstring, header, A, B, eqA, eqB)
%
%	outstring = CheckRealRangeAB(editstring, header, A, B, eqA, eqB)
%
% Returns an error string if the string <editstring> is not a
% real number in [A,B]. Otherwise, an empty string is returned.
% Flags eqA and eqB control whether edges of the interval are
% allowed (true) or not (false). Default is true for both.
% Second argument header (string) is used in the error message.
% This function is intended to be used within IdEM GUI to check for
% correctly formatted edit fields input by the user.
