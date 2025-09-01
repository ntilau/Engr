function [r_im,RV_IM,NotFinished] = SparseHamEig_All(MOD,Lev,Options,SparseHamOptions,FigLogHandle);
%
%	[r_im,RV_IM,NotFinished] = SparseHamEig_All(MOD,Lev,Options,SparseHamOptions);
%
% This function returns all imaginary eigenvalues (with positive real part)
% of the Hamiltonian matrix associated to state matrices ABCD stored in MOD.
% The eigenvalues are sorted in ascending order (of their imaginary part).
% Note that both Scattering and Admittance representations are allowed,
% according to the value of R0. The argument Lev
% is the threshold that appears in the definition of the Hamiltonian matrix.
% If this level is empty, the standard level is used (0 for admittance
% and 1 for scattering).
%
% All control parameters are stored as fields of structures
% Options and SparseHamOptions. See GetHamiltonianOptions and
% GetSparseHamDefaultOptions for details.
%
% The third output argument is a flag that is true when the search for
% imaginary eigenvalues did not terminate properly.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 17, 2004
% Last revision: July 14, 2005
% ------------------------------
