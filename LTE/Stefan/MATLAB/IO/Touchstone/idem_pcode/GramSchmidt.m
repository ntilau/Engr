function  [y,h]=GramSchmidt(r,v)
%
% [y,h] = GramSchmidt(r,v)
%
% Gram Schmidt phase of Arnoldi algorithm.
%
% Orthogonalizes a new vector r with respect to the j columns
% of matrix v. The components of the old vector along the
% columns of v that are actually subtracted are returned in
% the first j elements of array h. The last entry is the norm
% of the residual vector after subtraction of its components
% along v. The first return argument is the residual vector
% re-normalized with unitary norm.
%
% NB: h is the new column of the Hessemberg matrix generated
% by the Arnoldi process.
