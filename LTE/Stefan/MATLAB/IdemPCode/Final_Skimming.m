function [ComplexPoles,RealPoles,Nskim] = Final_Skimming(DUM,rp,cp,rr,cr,dc,ErrMax,Options,MaxResponses,RootFigHandle ); 
%
%	[ComplexPoles,RealPoles,Nskim] = Final_Skimming(DUM,rp,cp,rr,cr,dc,ErrMax,Options)
%
% This function is called at the end of the FDVF-AS scheme.
% Any spurious poles that remain due to the adding process are
% detected and removed based on two criteria.
% First the usual energy-based skimming is used by calling
% function En_skimming.
% Then, the pole/residue terms are again checked by comparing the
% approximation error with the error obtained by removing a single
% partial fraction. If no significant variation is observed, the
% corresponding pole/residue term is removed.
%
% Input parameters:
%
%   DUM:     structure with original data
%   cp:      array of complex poles
%   cr:      array of residues associated to complex poles
%   rp:      array of real poles
%   rr:      array of residues associated to real poles
%   dc:      direct coupling matrix of the approximation
%   ErrMax:  RMS deviation between complete model and data
%   Options: structure with FDVF-AS options
%
% Output parameters:
%
%   ComplexPoles:    remaining (non-spurious) complex poles
%   RealPoles:       remaining (non-spurious) real poles
%   Nskim:           number of detected spurious poles
%
% NB: the residue terms are not passed as output arguments since this
%     function is always followed by a call to MultiVectorFit to perform
%     a final poles relocation.
%
% ------------------------------
% Authors: Michelangelo Bandinu
%          Stefano Grivet-Talocia
% Date: February 15, 2005
% Last revision: February 15, 2005
% ------------------------------
