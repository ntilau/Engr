function [A,B,C,D] = RandomSS_S(Nports,Order,Bandwidth,LossFactor,Mismatch);
%
%	[A,B,C,D] = RandomSS_S(Nports,Order,Bandwidth,LossFactor,Mismatch)
%
% Generation of random state matrices for a passive multiport.
% The number of Nports is <Nports>, while the dynamic order is <Order>.
% The state-space system is obtained through reduction of a
% random (positive-definite) admittance matrix (the adynamic
% part of the circuit) with [Nports+Order] ports. Reduction is
% performed by terminating <Order> ports on unitary capacitances.
% The resulting state system assumes that the inputs are scattering
% (current) waves entering the ports, and the outputs are scattering
% (current) waves exiting the ports. The reference resistance
% for the definition of the scattering waves is defined in order to
% get the desired poles distribution (see below).
% 
% Note that the passivity condition to be satisfied is on the
% boundedness (not greater than one throughout the frequency axis)
% on the singular values of the (scattering) matrix transfer
% function of the system.
%
% Control on the poles of the resulting state space system is
% provided by the following arguments (the default is 1 for all).
%
% Bandwidth: the frequency [Hz] band where most of the poles will be
%            located. It is expected that few poles will be outside
%            this area, but not too far away.
%
% LossFactor: factor controlling the amount of (normalized) losses for the
%             adynamic part. If 0 there are no losses. If 1 there are
%             significant losses and the poles will have a real part
%             comparable in magnitude with the imaginary part.
%             Any number between 0 and 1 can be used.
%
% Mismatch: factor controlling the mismatch between port reference
%           resistances and impedance level of the adynamic part
%           This factor is used to control the relocation of the
%           poles due to the presence of termination resistances.
%           Any positive number can be used.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: January 30, 2003
% ------------------------------
