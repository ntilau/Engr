function [RealPoles,ComplexPoles] = FlippingPoles (DUM,rp,cp,FigLogHandle);
%
%	[RealPoles,ComplexPoles] = FlippingPoles (DUM,rp,cp)
%
% This function detects any poles that are too close to the origin
% and hard-relocates them in order to minimize possible ill-conditioning
% of the LS matrices.
%
% ------------------------------
% Authors: Michelangelo Bandinu
%          Stefano Grivet-Talocia
% Date: February 15, 2005
% Last revision: February 15, 2005
% ------------------------------
