function y=M_sI_inv_sparse(x,MODstuffed);
%
%	y = M_sI_inv_sparse(x,MODstuffed);
%
% This function computes y=(M-sigma*I)\x efficiently,
% where M is the Hamiltonian matrix associated to model
% stored in MODstuffed. Computations are performed using
% the Shermann-Morrison-Woodbury's formula. Note that
% MODstuffed must include matrices Ainv, L, U resulting
% from preprocessing performed in SparseHamEig_SingleShift.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Created: Jan 8 2004
% Last revision: May 18, 2004
% ------------------------------
