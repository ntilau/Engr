function X = AllSparseLyap(A, B, FigLogHandle)
%
%	X = AllSparseLyap(A,B)
%
% Solves continuous-time Lyapunov equation
%
%           A*X + X*A' = -BB'
%
% assuming that matrix A is block-diagonal of 1x1 and 2x2 blocks
% with real and real/imag parts of its eigenvalues, respectively.
% It is also assumed that
% B has a block-diagonal structure with each block consisting of
% a single column. Both A and B must be sparse.
% It is expected that this function be used only with state matrices
% A and B obtained by some sparse macromodeling tool such as TDVF_Split,
% TDVF_ColumnWise, FDVF_Split or FDVF_AS.
% The computation if the Gramian X is semi-analytical.
%
% ------------------------------
% Authors: Andrea Ubolli
%          Stefano Grivet-Talocia
% Date: April 25, 2003
% Last revision: March 11, 2005
% ------------------------------
