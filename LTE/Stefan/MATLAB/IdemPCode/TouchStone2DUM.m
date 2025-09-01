function DUM = TouchStone2DUM(pathname,filename,RootFigHandle);
%
%	DUM = TouchStone2DUM(pathname,filename)
%
% This function loads frequency-domain data from file in
% TouchStone format. Pathname and filename are supplied
% as separate arguments.
% The number of ports is determined automatically from the
% filename extension '.s<n>p' (n=Nports). All avaliable
% formats are supported, except Z or H data. Noise data
% for two-ports is neglected.
% 
% ------------------------------
% Authors: Stefano Grivet-Talocia
%          Carla Giachino
% Date: March 16, 2004
% Last revision: Jan 27, 2006
% ------------------------------
