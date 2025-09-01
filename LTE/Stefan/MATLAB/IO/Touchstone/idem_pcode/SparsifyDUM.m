function varargout = SparsifyDUM(varargin)
%
% 	threshold = SparsifyDUM(DUM);
% 	DUMOUT = SparsifyDUM(DUM,threshold);
%
% Sparsification of DUM by thresholding the (time or frequency domain)
% norm of its responses and retaining only those larger than threshold.
% The sparsified structure is returned in DUMOUT with the small
% responses physically removed.
% If the optional argument threshold is missing, 
% an interactive dialog showing the sparsity pattern
% obtained by varying the threshold is opened. When the
% dialog is closed, the last value of the threshold used within
% the dialog is returned as output.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 9, 2003
% Last revision: September 11, 2003
% ------------------------------
