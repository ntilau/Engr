close all
clear all

dim = 10;
% diagonal elements
r = 1:dim;
c = 1:dim;
val = randn(1,dim);
% off diagonal elements
r = [r, 1:(dim-1)];
c = [c, 2:dim];
val = [val, randn(1,dim-1)];
r = [r, 2:dim];
c = [c, 1:(dim-1)];
val = [val, randn(1,dim-1)];

r
c
val
A = sparse(r,c,val)
b = randn(dim,1)

[L,U,P,Q] = lu(A)
x = Q*(U\(L\(P*b)))
A*x

