function [ComplexPoles,RealPoles,addedpoles] = Multi_Adding(DUM,Happ,cp,rp,Options,MaxResponses);
%
%	[ComplexPoles,RealPoles,addedpoles] = Multi_Adding (DUM,Happ,cp,rp,Options)
%
% This function computes the frequencies associated to the maximum deviaton
% between data and model, and inserts new complex pole pairs in the existing
% pole set. This process is usually denoted as "Adding".
%
% Input arguments:
%
%   DUM: structure storing the original data
%   Happ: model responses
%   cp, rp: complex and real poles of current approximation
%   Options: control options for the multiple adding process
%            (see GetFDVF_AS_DefaultOptions)
%
% Output arguments:
% 
%   ComplexPoles: cumulative set of complex poles, including old and added poles
%   RealPoles:    cumulative set of real poles, including old and added poles
%   addedpoles:   added complex poles
%
% NB: RealPoles is empty since current implementation of the adding process
%     involves only complex poles.
%
% ------------------------------
% Authors: Michelangelo Bandinu
%          Stefano Grivet-Talocia
% Date: February 11, 2005
% Last revision: February 11, 2005
% ------------------------------
