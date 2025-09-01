function LogFileSpec = LoadIdemLogFileSettings(RootFigHandle);
%
%	LogFileSpec = LoadIdemLogFileSettings(RootFigHandle);
%
% This function initializes the IdeM log file specification.
% If possible, these are read from configuration file Idem.ini
%
% Output argument is a structure with fields
%
% 'Name': complete log file name specification
% 'MaxSize': maximum allowed size (in kB) of log file
