function [xvar,yvars,varnames]=ImportCSDF(filename,RootFigHandle)
%
%	[xvar,yvars,varnames]=ImportCSDF(filename)
%
% This function imports data from a CSDF file 
% into MATLAB. CSDF files are generated, for
% example, by SPICE when the command 
% .PROBE is used with the option /CSDF.
%
% filename: input file name
%
% xvar:     column vector with simulation indipendent variable (e.g. time or frequency)
% yvars:    matrix; each column stores an output variable
% varnames: cell array of strings; names of output variables
%
% **ATTENTION**: This function was created inferring the format of CSDF files
%                from SPICE outputs and not from CSDF file specifications!
%                Only the type of data (real or complex) is roughly retrieved
%                from the header.
%                There are NO warranties this function works correctly!
%
% ------------------------------
% Authors: Piero Triverio
%          Stefano Grivet-Talocia
% Date: May 21, 2003
% Last revision: May 31, 2003
% ------------------------------
