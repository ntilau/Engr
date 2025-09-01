function Ainv = FastAinv(A,shift);
%
%	Ainv = FastAinv(A,shift)
%
% Computes the inverse of (A-shift*I) where A is a state space matrix in
% sparse Gilbert form. No check on input format is performed!
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 21, 2004
% Last revision: May 21, 2004
% ------------------------------
