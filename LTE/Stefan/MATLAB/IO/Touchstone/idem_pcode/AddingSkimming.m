function [dc,rp,cp,rr,cr,err,Options] = AddingSkimming(DUM,rp,cp,Options,RootFigHandle);
%
%	[dc,rp,cp,rr,cr,err,Options] = AddingSkimming(DUM,rp,cp,Options)
%
% This function performs the main Adding and Skimming VF iterations.
% It is automatically called by FDVF-AS. Please refer to the documentation
% of FDVF-AS for a detailed explanation of the algorithm.
%
% ------------------------------
% Authors: Michelangelo Bandinu
%          Stefano Grivet-Talocia
% Date: February 16, 2005
% Last revision: February 16, 2005
% ------------------------------
