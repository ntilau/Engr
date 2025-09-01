% This script tests some properties of the generalized algebraic eigenvalue
% problem arising from analyzing the propagation characteristiv of an
% inhomogeneous waveguide.
close all;
clear;


%% Generalized eigenvalue problem with same structure as FE approximation

dim = 10;
blockSize1 = 6;
dimNullSpace = 2;
blockSize2 = dim - blockSize1;
T = randn(blockSize1);
T = T' * T;
Tblock2 = rand(blockSize2);
Tblock2 = Tblock2' * Tblock2;
T((blockSize1 + 1) : dim, (blockSize1 + 1) : dim) = -1 * Tblock2;
S = randn(dim, dim - dimNullSpace);
S = S * S';
S2 = randn(dim, dim - dimNullSpace);
S2 = S2 * S2';
S = S - S2;
eigGen = eig(S, T);
display(eigGen);
Tblock1 = T(1 : blockSize1, 1 : blockSize1);
R1 = chol(Tblock1);
R2 = chol(Tblock2);
R(1 : blockSize1, 1 : blockSize1) = R1;
R((blockSize1 + 1) : dim, (blockSize1 + 1) : dim) = R2;
iMod = eye(dim);
for k = 1 : blockSize2
  iMod((blockSize1 + k), (blockSize1 + k)) = -1;
end
% display(iMod);
% display(T);
% display(R' * iMod * R);
Smod = inv(R') * S * inv(R);
[Vg Dg] = eig(Smod, iMod);
display(Vg);
[Vm Dm] = eig(Smod);
display(Vm);


%% General complex symmetric matrices

A = randn(dim) + j * randn(dim);
A = A + A.';
display(A);
display(eig(A));
