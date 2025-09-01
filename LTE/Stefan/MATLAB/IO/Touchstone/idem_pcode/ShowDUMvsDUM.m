function varargout = ShowDUMvsDUM(varargin)
%
%	ShowDUMvsDUM(DUM1,DUM2)
%
% Graphical comparison of multiport port responses
% stored in structures DUM1 and DUM2.
% The plot type is defined interactively through a GUI.
%
% !!!!!!!!Warning!!!!!!!!
% The port responses must be compatible: the time excitations
% should be the same, the frequency axes should be the same, etc.
% No thorough checks of input data are performed!!!!!!
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: February 26, 2003
% Last revision: March 29, 2004
% ------------------------------
