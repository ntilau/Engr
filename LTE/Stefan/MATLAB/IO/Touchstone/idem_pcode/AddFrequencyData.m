function varargout = AddFrequencyData(varargin)
%
%	DUM_OUT = AddFrequencyData(DUM,bandwidth,padfactor)
%	DUM_OUT = AddFrequencyData(DUM,bandwidth)
%	DUM_OUT = AddFrequencyData(DUM)
%
% This function computes frequency-domain transfer matrix for the 
% multiport specification in time-domain (transient port responses) 
% in structure DUM, and generates a new structure DUM_OUT with both 
% time and frequency domain data. Standard FFT is used for the 
% computations. There are several options for this computation 
% and for the determination of the frequency bandwidth, determined 
% by the second argument bandwidth, as detailed below. Note that 
% the frequency axis will always start from DC.
%
% Argument bandwidth can be
%
%   Fmax (real number): In this case the argument is used as the
%                       highest frequency to be used for the generation 
%                       of the scattering parameters. The FFT's are computed
%                       using the raw time-domain data, but only the frequency
%                       points up to Fmax are retained. 
%   'single' (string):  In this case the bandwidth is determined interactively.
%                       It is assumed that all excitation signals a{j} are
%                       equal for all ports (as typical, e.g., for FDTD
%                       simulations), so only the excitation at the first
%                       available port is processed for the determination
%                       of the bandwidth. A frequency-domain plot is presented
%                       to the user, who is requested to input the sample
%                       number to be used as the upper limit of the frequency
%                       axis. Then, all computations are performed automatically. 
%   'all' (string):     As above, but the bandwidth selection is performed using
%                       all available excitation signals. This is the default. 
%
% The last input argument padfactor controls use of zero-padding for
% the computation of FFT. If missing or negative, no zero-padding is
% applied. If zero, the next power-of-two larger than the length of
% data is used. If positive integer, the latter length is further
% multiplied by 2^padfactor.
%
% Notes
%
% It is assumed that FFT can be applied without further checks.
% In particular, the excitation and response signals should have
% decayed sufficiently to zero in order to avoid truncation effects.
%
% If DUM is reciprocal, all off-diagonal entries  (corresponding
% to available time-domain data) of the DUM_OUT.S are filled,
% so that the complete transfer matrix is always available.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: April 4, 2003
% Last revision: March 21, 2005
% ------------------------------
