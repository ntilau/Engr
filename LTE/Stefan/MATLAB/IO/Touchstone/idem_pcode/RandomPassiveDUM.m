function [DUM,MOD] = RandomPassiveDUM(type,Nports,Order,Bandwidth,LossFactor,Mismatch,Options,RootFigHandle);
%
%	[DUM,MOD] = RandomPassiveDUM(type,Nports,Order,Bandwidth,LossFactor,Mismatch,Options)
%
% Generates a set of input/output responses for a random passive
% multiport, according to parameter type. If type is:
%
% 'frequency': a complete set of transfer functions is
%              generated with appropriate frequency samples
%
% 'time': a complete set of port responses is generated
%         with appropriate time sampling
%
% 'both': both time and frequency data are generated
%
% 'none': no responses are generated (this is used only to generate the
%         state-space matrices, since DUM will be almost empty)
%
% The number of ports is <Nports>, and the dynamic order is <Order>.
% Control on the poles of the resulting state space system is
% provided by the following arguments (the default is 1 for all).
%
% Bandwidth: the frequency [Hz] band where the poles will be located.
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
%           If 0, an admittance representation of DUM is obtained instead
%           of a scattering representation.
%
% The optional output argument MOD stores both state-space and poles-residues
% representations of a system coresponding to the port responses/scattering
% parameters in DUM. These representations may be used for validation of
% macromodeling tools. Note that a non-reciprocal structure is generated.
%
% Additional control parameters for data generations can be passed in
% structure <Options>. The possible fields are listed below with defaults.
% If some fields are not provided, their default values are used.
% These defaults are loaded using function GetDUMDefaultOptions.
%
%  Options.Nf_min = 100          (Minimum number of frequency samples)
%  Options.Nf_max = 2000         (Maximum number of frequency samples)
%  Options.BandwidthCutoff = 0.1 (Norm. level for bandwidth of input pulse)
%  Options.Ts_per_Delta = 50     (Number of samples per std.dev. of input pulse)
%  Options.Tmax_over_Delta = 100 (Duration of transient in terms of std.dev. of input pulse)
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: January 31, 2003
% Last revision: July 12, 2006
% ------------------------------
