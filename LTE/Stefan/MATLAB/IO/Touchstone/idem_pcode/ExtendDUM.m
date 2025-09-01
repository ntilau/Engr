function DUMlong = ExtendDUM(DUM,Bandwidth,TimeExtensionFactor,MaxTime,truncation,Nfit);
%
%	DUMlong = ExtendDUM(DUM,Bandwidth,TimeExtensionFactor,MaxTime,truncation,Nfit)
%
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% This function should only be used when everything else fails!
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
% It tries to extend the time excitations and responses in DUM
% in time using extrapolation with a function of the type
%
%  f(t) = [a + b*(t-t_end)] * exp(-(t-t_end)/tau);
%
% specifically designed to match up to the first derivative
% with the original waveform. The exponential decay depends on the
% provided bandwidth (it should equal the bandwidth of the
% excitation waveform in DUM) according to
%
%  tau = 1/2/pi/Bandwidth;
%
% The optional argument TimeExtensionFactor (>1) is used to generate
% the extended time axis for the new responses.
% The time axes are truncated to MaxTime if longer and if the last
% parameter truncation equals "hard". Otherwise ("soft"), no truncation
% is applied and the responses are unchanged. The last argument
% Nfit determines the number of samples that will be used for
% the estimation of the first derivative at the end of the original sequences.
%
% This function is only provided for improvement of the numerical
% performance of the time-domain processing tools, and not to
% fudge the data with new non-physical information. It is just
% an attempt to work with highly truncated time waveforms.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: May 21, 2003
% ------------------------------
