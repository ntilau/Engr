function y=M_sI_inv_sparse_complex(x,MODstuffed);
%
%	y = M_sI_inv_sparse_complex(x,MODstuffed)
%
% This function computes y=(M-sigma*I)\x efficiently,
% where M is the Hamiltonian matrix associated to model
% stored in MODstuffed. Computations are performed using
% the Shermann-Morrison-Woodbury's formula. Note that
% MODstuffed must include matrices Ainv, L, U resulting
% from preprocessing performed in RefineEigenPairs.
%
% -------------------------------
% Author: Stefano Grivet-Talocia
% Created: May 21, 2004
% Last revision: May 21, 2004
% -------------------------------
