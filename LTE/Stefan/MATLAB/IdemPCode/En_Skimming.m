function [ComplexPoles,ComplexResidues,RealPoles,RealResidues,Nskim] = ...
	En_Skimming (DUM, cp, cr, rp, rr, Options, RootFigHandle);
%
%	[ComplexPoles,ComplexResidues,RealPoles,RealResidues,Nskim] = ...
%		En_Skimming (DUM, cp, cr, rp, rr, Options)
%
% This function detects spurious poles via computation of the energy of
% the associated resonance curves. Those pole/residue pairs with small
% energy compared to the average energy are detected as spurious.
% The selectivity of the skimming process is tuned by the threshold
% Options.gamma.
%
% Input parameters:
%
%   DUM:     structure with original data
%   cp:      array of complex poles
%   cr:      array of residues associated to complex poles
%   rp:      array of real poles
%   rr:      array of residues associated to real poles
%   Options: structure with FDVF-AS options
%
% Output parameters:
%
%   ComplexPoles:    remaining (non-spurious) complex poles
%   ComplexResidues: associated residues
%   RealPoles:       remaining (non-spurious) real poles
%   RealResidues:    associated residues
%   Nskim:           number of detected spurious poles
%
% NB: current implementation does not perform any skimming on real poles.
%     Therefore, the same input arguments rp, rr are copied into the output
%     parameters RealPoles, RealResidues.
%
% ------------------------------
% Authors: Michelangelo Bandinu
%          Stefano Grivet-Talocia
% Date: February 11, 2005
% Last revision: February 11, 2005
% ------------------------------
