function [r_im,RV_IM,NotFinished,om,Svals,max_violations] = SparseHamEig_All_AdaptiveSampling(MOD,Lev,Options,SparseHamOptions,AdaptiveSamplingOptions,FigLogHandle);
%
%	[r_im,RV_IM,NotFinished,om,Svals,max_violations] = SparseHamEig_All_AdaptiveSampling(MOD,Lev,Options,SparseHamOptions,AdaptiveSamplingOptions);
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
% Options, SparseHamOptions, and AdaptiveSamplingOptions.
% See GetHamiltonianOptions, GetSparseHamDefaultOptions, and
% GetAdaptiveSamplingDefaultOptions for details.
%
% The third output argument is a flag that is true when the search for
% imaginary eigenvalues did not terminate properly.
%
% Adaptive sampling with both eigenvector and eigenvalue tracking is performed
% to determine the frequency bands that must be checked using the Hamiltonian matrix.
% This procedure allows to highlight the passive bands and therefore to reduce
% the computational cost needed for the determination of the imaginary
% Hamiltonian eigenvalues.
%
% The eigenvalues/singular values arising from the adaptive sampling are
% returned in matrix Svals and the corresponding (angular) frequencies in
% array om. The minima/maxima and the corresponding angular frequencies are
% also returned in the two columns of matrix max_violations.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 17, 2004
% Last revision: July 14, 2005
% ------------------------------
