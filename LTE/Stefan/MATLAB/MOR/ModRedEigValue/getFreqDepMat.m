% This script gets the matrices and their frequency dependence of the
% 2d eigenmode solver.

close all;
clear all;

% run solver with f = 0 Hz
dirStr = 'C:\work\examples\wg3_h1\';
projStr = 'wg3_h1';
system(['cd ' dirStr ' & em_eigenmodesolver2d ' projStr ' 0 1 2 +dx writeMatrices \w'])
% read matrices
S0 = MatrixMarketReader([dirStr 'mat_0']);
T0 = MatrixMarketReader([dirStr 'mat_1']);

% find frequency with k = 0
c0 = 299792.458e3;
f1 = c0/(2.0*pi);
 
system(['cd ' dirStr ' & em_eigenmodesolver2d ' projStr ' ' num2str(f1) ' 1 2 +dx writeMatrices \w'])
S1 = MatrixMarketReader([dirStr 'mat_0']);
T1 = MatrixMarketReader([dirStr 'mat_1']);

% get DoF numbers of the jV unknowns
jV_unknowns = vectorReader([dirStr 'jV_unknowns']);

[rowSize colSize] = size(S1);

S_k0 = S0;

S_k1 = S1;
jV_DoF_Numbers = find(jV_unknowns);
S_k1(jV_DoF_Numbers, jV_DoF_Numbers) = 0;
A_Psi_DoF_Numbers = find(jV_unknowns == 0);
S_k1(A_Psi_DoF_Numbers, A_Psi_DoF_Numbers) = 0;

% recreate matrix with new sparsity pattern
[i,j,s] = find(S_k1);
[m,n] = size(S_k1);
S_k1 = sparse(i,j,s,m,n);

S_k2 = S1-S0;
S_k2(A_Psi_DoF_Numbers, jV_DoF_Numbers) = 0;
S_k2(jV_DoF_Numbers, A_Psi_DoF_Numbers) = 0;
% recreate matrix with new sparsity pattern
[i,j,s] = find(S_k2);
[m,n] = size(S_k2);
S_k2 = sparse(i,j,s,m,n);

T_k0 = T0;
T_k1 = sparse(rowSize, colSize); % no linear frequency dependence
T_k2 = sparse(rowSize, colSize); % no square frequency dependence

%test for arbitrary k
% find frequency corresponding to k
k = 2;
c0 = 299792.458e3;
f2 = k*c0/(2.0*pi);
 
system(['cd ' dirStr ' & em_eigenmodesolver2d ' projStr ' ' num2str(f2) ' 1 2 +dx writeMatrices \w'])
S2 = MatrixMarketReader([dirStr 'mat_0']);
T2 = MatrixMarketReader([dirStr 'mat_1']);

S2_test = S_k0 + k*S_k1 + k^2*S_k2;
S2(1:5,1:5)
S2_test(1:5,1:5)
maxDiff = max(max(S2-S2_test))
maxRelDiff = max(max(S2-S2_test))/max(max(S2))





