function p_large = ExtractLargestResponses(DUM,Nresponses,p_sel);
%
%	p_large = ExtractLargestResponses(DUM,Nresponses,p_sel)
%
% This function returns a port selector matrix p_large that
% extracts from the DUM responses selected by matrix p_sel
% the N_responses having largest RMS norm. Time-domain
% responses are used if available. Otherwise, frequency-domain
% responses are used. The last argument p_sel is optional.
% If not present, all available responses are considered.
%
% If the number of available responses is less than Nresponses,
% no thresholding is performed and p_large returns all these
% responses.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 20, 2003
% ------------------------------
