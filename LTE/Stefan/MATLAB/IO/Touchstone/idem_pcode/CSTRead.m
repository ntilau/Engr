function [x,y] = CSTRead(file_in,CSTversion,RootFigHandle);
%
%	[x,y] = CSTRead(file_in,CSTversion)
%
% Reads data vectors from time or frequency (.sig) CST files.
% The flag CSTversion can at present be either 3, 4, or 5.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: January 21, 2003
% Last revision: March 17, 2005
% ------------------------------
