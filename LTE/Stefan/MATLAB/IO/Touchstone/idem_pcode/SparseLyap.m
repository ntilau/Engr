function X = SparseLyap(A, B, C)
%
%	X = SparseLyap(A,C)
%
% Solves continuous-time Lyapunov equation assuming that matrix
% A is block-diagonal of 1x1 and 2x2 blocks with real and real/imag
% parts of its eigenvalues, respectively. Both A and C must be sparse.
% It is expected that this function be used only with a state matrix A
% obtained by some sparse macromodeling tool such as TDVF_Split and
% FDVF_Split.
%
% This function is adapted from LYAP in the Control Toolbox. The
% equation that is considered is
%
%           A*X + X*A' = -C
%
% NB: this function is obsolete and unsupported. Please use AllSparseLyap.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 25, 2003
% Last revision: June 24, 2004
% ------------------------------
