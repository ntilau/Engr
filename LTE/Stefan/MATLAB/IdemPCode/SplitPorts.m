function Omega = SplitPorts(DUM,typ,Nlargest,RootFigHandle);
%
%	Omega = SplitPorts(DUM,typ,Nlargest)
%
% This function returns a structure with port selector matrices
% for partial macromodeling of DUM. The output argument is
% a cell array. Each cell corresponds to a subset of port
% responses. The corresponding port selector matrix is
% stored as a (sparse) field Omega{k}.pindex.
% The second argument <typ> determines which kind of port
% splitting is performed. This argument can be:
%
%  'all':    all elements are separated
%  'row':    all rows are separated
%  'column': all columns are separated
%  matrix:   if a square matrix of size DUM.Nports, it is
%            interpreted as an explicit descriptor of the
%            subsets, denoted as consecutive positive
%            integer entries.
%
% The third argument is used to further select the
% subset of Nlargest responses with largest RMS norm
% from the subset extracted. The corresponding port
% selector matrix is stored in field Omega{k}.p4poles.
% This argument is not used if <typ>='all'.
% 
% ------------------------------
% Author: Stefano Grivet-Talocia
%         Andrea Ubolli
% Date: April 16, 2003
% Last revision: March 2, 2005
% ------------------------------
