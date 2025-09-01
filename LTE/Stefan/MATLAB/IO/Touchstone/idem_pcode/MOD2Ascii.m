function status = MOD2Ascii(MOD,FileDir,FileName)
%
%	status = MOD2Ascii(MOD,FileDir,FileName)
%
% This function generates an Ascii dump of the state-space matrices
% associated to model MOD. The file is specified via its path (FileDir)
% and name (FileName). The output parameter (status) is a string used
% for error messages. In case everything goes well, an empty variable
% is returned.
%
% The generated output ASCII file has a header section reporting model
% name, model representation (Y or S), model units. Then, four sections
% report the A, B, C, and D matrices in sparse format (each row in the file
% reads, e.g.,
%
% i,j,A(i,j)
%
% with i,j denoting respectively the row and column indices of a
% nonvanishing entry in the matrix A (and similarly for B, C, D).
%
% Each non-numeric line in the output file starts with a '%' character.
%
% ------------------------------
% Author: Stefano Grivet Talocia
% Date: September 13, 2006
% Last revision: September 13, 2006
% ------------------------------
