function [xv,lmb,iresult,shift,radius,resnorm] = SparseHamEig_SingleShift(MOD,Lev,lbi,ubi,Options,SparseHamOptions,shifttype,FigLogHandle);
%
%	[xv,lmb,iresult,shift,radius,resnorm] = SparseHamEig_SingleShift(MOD,Lev,lbi,ubi,Options,SparseHamOptions,shifttype);
%
% This function determines a shift on the positive imaginary axis
% and a radius of a corresponding convergence circle. All eigenvalues
% within this circle and corresponding eigenvectors are computed.
%
% The behavior of the algorithm is strongly determined by the contol
% parameters stored in structure SparseHamOptions. See
% GetSparseHamDefaultOptions for a detailed description.
%
% The placement of the shift is determined by the bandwidth of interest
% speficied by lower bound lbi and upper bound ubi, and by the string
% shifttype, which can be
%
%  'lower' : shift is placed close to the lower bound
%  'upper' : shift is placed close to the upper bound
%  'center': shift is placed close to the center 
%
% The location of the shift is optimized in order to minimize the condition
% number of the matrices to be inverted during subsequent operations.
%
% The basic algorithm is a restarted Arnoldi scheme with implicit deflation.
% The actual implementation is mutuated with several modifications from
% routine SPTARN of PDE toolbox. In particular, the automatic determination
% of the convergence circle is included and optimized for use of this
% function within the multi-shift algorithm in SparseHamEig_Few.
% The number of eigenvalues inside the circle returned as iresult
% is a nonnegative integer. If 0, it is insured that no eigenvalues are
% within the circle. The algorithm searches for stabilized eigenvalues
% outside the circle in order to make sure that no eigs in addition to
% those returned in lmb are located inside the circle.
%
% The last argument is the residual norm of the computed eigenpair.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 17, 2004
% Last revision: July 14, 2005
% ------------------------------
