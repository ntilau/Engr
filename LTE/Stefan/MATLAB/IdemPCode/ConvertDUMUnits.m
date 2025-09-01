function DUMnorm = ConvertDUMUnits(DUM,voltage_factor,impedance_factor,time_factor,frequency_factor);
%
%	DUMnorm = ConvertDUMUnits(DUM,voltage_factor,impedance_factor,time_factor,frequency_factor)
% 
% This function converts the units of DUM specification.
% The four conversion factors apply to voltage, impedance,
% time and frequency. They are the ratio between new units
% and old units.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: August 13, 2003
% ------------------------------
