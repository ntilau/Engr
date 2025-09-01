function PlotDUM(DUM,varargin);
%
%	PlotDUM(DUM,arglist)
%
% This function produces plots of the data included
% in structure DUM. The type of plot depends on the
% additional arguments in arglist, according to the
% following rules.
%
% First argument in arglist can be ether 'time' or
% 'frequency', thus enabling the corresponding type
% of plots to be generated. If DUM has no data for
% the required plots, no action is taken. The default
% is 'time'.
%
% Second argument can be either 'all' (the default)
% or 'slide'. If 'all', a complete set of plots
% of all available data is generated. These are
% scattering parameters for frequency-domain (all
% magnitudes in one figure, all phases in another
% figure) or time-domain scattering waves (all
% port responses due to a single excitation in one
% figure, one figure for each excited port).
% If 'slide', a slideshow of all individual responses
% is produced. The user must hit <enter> to go to
% the next plot.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: January 22, 2003
% Last revision: March 17, 2004
% ------------------------------
