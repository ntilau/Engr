function [l_im,v_im,NotFinished] = SparseHamEig_Few(CheckOnly,MOD,Lev,lbi,ubi,Options,SparseHamOptions,FigLogHandle);
%
%	[l_im,v_im,NotFinished] = SparseHamEig_Few(CheckOnly,MOD,Lev,lbi,ubi,Options,SparseHamOptions);
%
% This function returns the imaginary eigenvalues l_im of 
% Hamiltonian matrix associated to model MOD and defined by
% threshold level Lev. Only the eigenvalues with imaginary
% part in [lbi,ubi] are returned, sorted in ascending order.
% The eigenvectors are also returned, normalized with unitary
% euclidean norm. A Complex-Frequency-Hopping algorithm using
% a restarted Arnoldi at each hop is used for the eigenvalues search.
% All parameters controlling the algorithm are passed in
% structures Options and SparseHamOptions (see GetHamiltonianOptions
% and GetSparseHamDefaultOptions
% for details). The third output argument NotFinished is an
% error indicator flag that is true when there is no guarantee
% that all eigenvalues have been found.
%
% The first argument CheckOnly is a logical flag. If true,
% this function will only perform a faster check on the existence
% of imaginary eigs bracketed by [lbi,ubi]. If at least one is found,
% exit immediately returning 1 as output argument l_im.  If no eig is
% found, exit immediately returning an empty output argument l_im.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 17, 2004
% Last revision: July 14, 2005
% ------------------------------
