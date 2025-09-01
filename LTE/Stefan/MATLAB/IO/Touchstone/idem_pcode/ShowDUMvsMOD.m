function varargout = ShowDUMvsMOD(varargin)
%
%	ShowDUMvsMOD(DUM,MOD,TimeExtensionFactor)
% 
% Graphical comparison of multiport macromodel stored in
% structure MOD with raw data stored in structure DUM.
% The plot type is defined interactively through a GUI.
% The parameter TimeExtensionFactor allows to compute the
% MOD responses over a larger duration than the time axis
% available in DUM.
% 
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: February 26, 2003
% Last revision: July 12, 2006
%------------------------------
