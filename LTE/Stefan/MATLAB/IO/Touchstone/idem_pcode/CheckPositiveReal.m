function outstring = CheckPositiveReal(editstring, header)
%
%	outstring = CheckPositiveReal(editstring, header)
%
% Returns an error string if the string <editstring> is not a
% positive real number. Otherwise, an empty string is returned.
% Second argument header (string) is used in the error message.
% This function is intended to be used within IdEM GUI to check for
% correctly formatted edit fields input by the user.
