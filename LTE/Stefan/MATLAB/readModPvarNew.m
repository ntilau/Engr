function [fMin, fMax, numF_Pnts, muMin, muMax, numMuPnts, fCutOff] = readModPvarNew(filename) 

fid = fopen( filename, 'r' );
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end

fMin = fscanf(fid, '%f', 1);
fMax = fscanf(fid, '%f', 1);
numF_Pnts = fscanf(fid, '%f', 1);   % number of frequency points
gSoldName = fscanf(fid, '%s', 1);
paraName = fscanf(fid, '%s', 1);
muMin = readComplex(fid);
muMax = readComplex(fid);
numMuPnts = fscanf(fid, '%f', 1);   % number of mu points
fCutOffString = fscanf(fid, '%s', 1);
fCutOff = fscanf(fid, '%f', 1);

fclose(fid);
