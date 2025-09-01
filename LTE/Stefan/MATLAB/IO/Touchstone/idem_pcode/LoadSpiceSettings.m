function [SPICETYPE,SPICECOMMAND,PSPICEOPTIONS,CSDFEXTENSION] = LoadSpiceSettings(RootFigHandle);
%
%	[SPICETYPE,SPICECOMMAND,PSPICEOPTIONS,CSDFEXTENSION] = LoadSpiceSettings
%
% This function initializes the command-line and the command-line
% arguments that will be used to invoke SPICE from Matlab.
% If possible, these are read from configuration file Idem.ini
