function [MODnorm, rho_A, rho_B, rho_C] = NormalizeMOD(MOD);
%
%	[MODnorm, rho_A, rho_B, rho_C] = NormalizeMOD(MOD);
% 
% Normalizes the state matrices A, B, C of model MOD and
% returns the normalized model MODnorm together with the
% normalization constants rho_A, rho_B, rho_C. Each matrix
% can be recovered via multiplication by these constants.
% Note that the transfer matrix is unchanged apart from a
% frequency normalization by rho_A.
%
% The constants are determined so that:
% - the spectrum of A is approximately bounded by one
% - the inf-norm of B and the 1-norm of C are equal
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: June 5, 2004
% Last revision: June 8, 2004
% ------------------------------
