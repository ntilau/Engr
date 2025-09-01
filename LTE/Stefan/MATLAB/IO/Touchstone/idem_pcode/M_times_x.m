function y = M_times_x(x,MOD,Lev);
%
%	y = M_times_x(x,MOD,Lev);
%
% Computes the result of application of Hamiltonian matrix
% associated to state space system in MOD and defined by
% level Lev to vector x. This is only used as an auxiliary
% function for 'eigs' during the determination of the eigenvalue
% with maximum magnitude.
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 17, 2004
% Last revision: May 18, 2004
% ------------------------------
