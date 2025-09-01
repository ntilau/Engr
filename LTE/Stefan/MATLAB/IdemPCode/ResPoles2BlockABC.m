function MODfull = ResPoles2BlockABC(MOD,pindex);
%
%	function MODfull = ResPoles2BlockABC(MOD,pindex)
%
% This function processes the macromodel representation
% stored in structure MOD in poles-residues form and
% and produces a new structure MODfull in state-space form.
% The state matrices are obtained with order n*p, where
% n is the number of poles and p is the number of ports.
% Matrices A and B are block diagonal, each block corresponding to
% a system with only one port excited at the time.
% Connection is provided by matrix C, which is only filled
% with entries corresponding to the ports selected by optional
% argument pindex. This is intended for handling weak couplings,
% for which some of the residues entries are neglected.
% Note that the resulting system matrices are in sparse format,
% do not use this function for full matrices!
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 8, 2003
% Last revision: April 16, 2003
% ------------------------------
