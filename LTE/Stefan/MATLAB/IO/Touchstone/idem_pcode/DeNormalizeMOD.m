function [MOD] = DeNormalizeMOD(MODnorm,rho_A,rho_B,rho_C);
%
% MOD = DeNormalizeMOD(MODnorm,rho_A,rho_B,rho_C);
% 
% This function is the inverse of NormalizeMOD.
% De-normalizes the state matrices A, B, C of model MODnorm
% using the normalization constants rho_A, rho_B, rho_C.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: June 5, 2004
% Last revision: June 8, 2004
% ------------------------------
