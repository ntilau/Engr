function MAT=fraw2dat(rawfilename, datfilename,RootFigHandle);
%
%	MAT=fraw2dat(rawfilename, datfilename)
%
% Converts PowerSPICE raw data files (in ASCII format) into 
% a matrix MAT collecting sampled waveforms in a
% column format (time, var#1, var#2, ... ).
% Input must be a frequency-domain data file.
% If the optional argument datfilename is present, an
% ascii file with the same structure of MAT is generated.
