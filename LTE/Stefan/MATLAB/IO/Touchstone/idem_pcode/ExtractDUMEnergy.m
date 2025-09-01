function Emat = ExtractDUMEnergy(DUM,p_sel);
% 
%	Emat = ExtractDUMEnergy(DUM,p_sel)
%
% This function computes the RMS norms associated to the
% responses stored in structure DUM and returns them
% in the matrix Emat. Time-domain responses are used
% if available. Otherwise, frequency-domain responses
% are used. The norms are all normalized to the maximum
% among all responses. Therefore, the maximum entry
% in matrix Emat is one. If some responses are not
% available, a value of zero is returned.
% The last optional argument p_sel selects only
% some responses to be considered for energy computation.
% If this argument is not available, all available
% responses are used.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 20, 2003
% Last revision: March 29, 2004
% ------------------------------
