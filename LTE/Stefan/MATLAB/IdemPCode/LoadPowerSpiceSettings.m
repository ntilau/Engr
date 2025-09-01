function [POWERSPICE,POWERSPICEOPTIONS] = LoadPowerSpiceSettings(RootFigHandle);
%
%	[POWERSPICE,POWERSPICEOPTIONS] = LoadPowerSpiceSettings
%
% This scripts initializes the command-line and the command-line
% arguments that will be used to invoke PowerSPICE from Matlab.
% If possible, these are read from configuration file Idem.ini
