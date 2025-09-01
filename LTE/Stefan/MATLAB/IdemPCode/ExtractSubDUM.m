function SubDUM = ExtractSubDUM(DUM,ports);
%
%	SubDUM = ExtractSubDUM(DUM,ports);
%
% This function extracts from the port responses of structure DUM
% a subset indexed by array ports. This subset of responses is
% stored in structure SubDUM, which corresponds to another
% multiport having only the defined ports accessible for 
% external connections. Warning: no check is performed
% on the input arguments.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 27, 2003
% ------------------------------
