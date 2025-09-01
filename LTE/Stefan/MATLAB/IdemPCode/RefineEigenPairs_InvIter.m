function [CFH_new,maxresidual] = RefineEigenPairs_InvIter(MOD,Lev,CFH,SparseHamOptions,FigLogHandle);
%
%	[CFH_new,maxresidual] = RefineEigenPairs_InvIter(MOD,Lev,CFH,SparseHamOptions);
%
% Performs standard Inverse Iterations to refine initial estimates of eigenpairs
% in structure CFH. Shift-And-Invert is used by setting the shift at each
% approximate eigenvalue with the starting vector initialized with the
% approximate eigenvector. As a result, CFH_new stores the refined estimates
% together with the estimated accuracy of each eigenpair (actually,
% the residual norm of Av-lv) in field 'Accuracy'.
% The maximum value among all these Accuracy fields is returned
% in second output argument maxresidual.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 21, 2004
% Last revision: May 28, 2004
% ------------------------------
