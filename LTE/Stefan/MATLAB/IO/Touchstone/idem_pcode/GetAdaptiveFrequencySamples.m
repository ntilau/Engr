function [om,Svals,passive_bands,nonpassive_bands,max_violations] = ...
        GetAdaptiveFrequencySamples(MOD,Lev,SparseHamOptions,AdaptiveSamplingOptions,FigLogHandle);
%
% [om,Svals,passive_bands,nonpassive_bands,max_violations] = ...
%        GetAdaptiveFrequencySamples(MOD,Lev,SparseHamOptions,AdaptiveSamplingOptions,FigLogHandle);
%
% This function performs adaptive sampling of the transfer matrix
% corresponding to model MOD (must be state-space, sparse) in order to
% track eigenvalues (admittance) or singular values (scattering) and
% associated eigenvectors. The results are post-processed so that a set of
% strictly passive frequency bands is returned, allowing to skip a search
% of imaginary eigenvalues of the associated Hamiltonian matrix. These
% passive bands are returned in the cells of array <passive_bands>.
% Conversely, the frequency bands that still need more refined passivity
% characterizations are also returned in the cells of array
% <nonpassive_bands>. The union of all these bands covers the portion of
% the frequency axis that includes all possible intersections with the
% pasivity threshold <Lev>. The maxima (minima) of singular
% values (eigenvalues) in each "suspect" nonpassive bandwidth are also
% computed based on the adaptive sampling and are returned together with
% their corresponding frequency in <max_violations>. Also the array of
% frequency points <om> and singular values (eigenvalues) <Svals> are
% returned. For control options see GetSparseHamDefaultOptions and
% CheckHamiltonianAllSparse/CheckHamiltonianAllSparseAdaptive.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 21, 2005
% Last revision: July 14, 2005
% ------------------------------
