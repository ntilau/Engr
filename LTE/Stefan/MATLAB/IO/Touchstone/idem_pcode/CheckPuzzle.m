function [isOK,NewPuzzle] = CheckPuzzle(Puzzle,pindex);
%
%	[isOK,NewPuzzle] = CheckPuzzle(Puzzle,pindex)
%
% Checks that input matrix Puzzle is a valid descriptor
% of port responses subsets. If size is wrong, an error
% condition is returned. Otherwise, make sure that
% the disjoint subsets of port responses are denoted by
% consecutive positive integers. Vanishing entries
% correspond to missing responses in pindex.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
%         Andrea Ubolli
% Date: March 2, 2005
% Last revision: March 2, 2005
% ------------------------------
