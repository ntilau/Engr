% creates a struct containing matrices and vectors of unreduced model
function [Factor, factTime] = matrixFactor(A, mtype)

% Fill-reduction analysis and symbolic factorization
tic

[iparm,pt,err,A_val,A_ia,A_ja,ncol] = pardisoReorderLTE(mtype, A);
pardisoFactorLTE(mtype,iparm,pt,A_val,A_ia,A_ja,ncol);
% [iparm pt] = pardisoReorderLTE(mtype, A); 
% Numerical factorization
% pardisoFactorLTE(pt, mtype, A, iparm); 
factTime = toc;
Factor.iparm = iparm;
Factor.pt = pt;
Factor.mtype = mtype;
Factor.val = A_val;
Factor.ia = A_ia;
Factor.ja = A_ja;
Factor.ncol = ncol;





