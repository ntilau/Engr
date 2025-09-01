function [Poles,Res] = SS2ResPoles(A,B,C,D);
%
%	[Poles,Res] = SS2ResPoles(A,B,C,D)
% 
% Returns the poles/residues expansion of the matrix
% transfer function for spate space system speficied
% by matrices A,B,C. Note that matrix D is not used,
% and can also be skipped as input argument.
% Complex partial fraction expansion
% is returned. Poles is a column vector. Res is a
% cell array of 2-D matrices such that Res{k} is the matrix of
% residues for pole at location (k) of array Poles.
%
% Note: all complex poles and residues are included,
%       not only those with positive imaginary part!
%
% Important: this function should be used only if the
% matrices are full. Sparse matrices are not supported
% (and will never supported by this algorithm).
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: January 27, 2003
% Last revision: April 16, 2003
% ------------------------------
