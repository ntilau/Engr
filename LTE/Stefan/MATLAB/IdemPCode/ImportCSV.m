function [xvar,yvars,varnames]=ImportCSV(filename,RootFigHandle)
%
%	[xvar,yvars,varnames]=ImportCSV(filename)
%
% This function imports data from a CSV file 
% into MATLAB. CSV files are generated, for
% example, by WinSpice when the .csv extension
% is specified for the rawfile.
%
% filename: input file name
%
% xvar:     column vector with simulation indipendent variable (e.g. time or frequency)
% yvars:    matrix; each column stores an output variable
% varnames: cell array of strings; names of output variables
%
% **ATTENTION**: This function was created inferring the format of CSV files
%                from WinSpice outputs!
%                There are NO warranties this function works correctly!
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: March 9, 2004
% Last revision: March 9, 2004
% ------------------------------
