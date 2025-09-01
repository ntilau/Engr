function FlagSparse = MustUseSparse(Responses,Samples,Order,MemMax);
%
%	FlagSparse = MustUseSparse(Responses,Samples,Order,MemMax)
%
% This function returns a logical flag indicating whether a full
% matrix can be used instead of a sparse matrix. This flag is
% computed from the number of Responses, Samples, and Order,
% according to a semi-empirical formula based on extensive
% analysis of the performance of Matlab's built-in direct linear
% system solvers. A hard limit is set so that the total size of
% full matrices does not exceed MemMax whatever be the combination
% of the other arguments.
%
% Input arguments:
%
% Responses: number of responses selected for poles estimation
% Samples:   number of samples in each response
% Order:     number of poles to be relocated
% MemMax:    size limit (MB) on full matrices
%
% Output arguments:
%
% FlagSparse: 1 (must use sparse matrix)
%             0 (can use full matrix)
%
% ------------------------------
% Authors: Andrea Ubolli, Stefano Grivet-Talocia
% Date: April 5, 2004
% Last revision: April 5, 2004
% ------------------------------
