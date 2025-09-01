function MAT=raw2dat(rawfilename, datfilename,RootFigHandle);
%
%	MAT=raw2dat(rawfilename, datfilename)
%
% Converts PowerSPICE raw data files (in ASCII format) into 
% a matrix MAT collecting sampled waveforms in a
% column format (time, var#1, var#2, ... ).
% If the optional argument datfilename is present, an
% ascii file with the same structure of MAT is generated.
