function X = FullLyap(A, B, C)
%
%	X = FullLyap(A, B, C)
%
% Solve continuous-time Lyapunov equations.
%
%   X = FullLyap(A,C) solves the special form of the Lyapunov matrix 
%   equation
%
%           A*X + X*A' = -C
%
%   X = FullLyap(A,B,C) solves the general form of the Lyapunov matrix
%   equation (also called Sylvester equation)
%
%           A*X + X*B = -C
%
