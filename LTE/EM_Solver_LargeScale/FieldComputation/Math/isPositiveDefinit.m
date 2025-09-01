function [tf, min_eigval] = isPositiveDefinit(A)

A = full(A);

[V, D] = eig(A);

d = diag(D);

min_eigval = min(d);

tf =  isreal(d) && (min_eigval > 0);