function [fMin deltaF fMax muMin deltaMu muMax fCutOff] = readModPvar(filename) 

fid = fopen( filename, 'r' );
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end

fMin = fscanf(fid, '%f', 1);
deltaF = fscanf(fid, '%f', 1);
fMax = fscanf(fid, '%f', 1);
gSoldName = fscanf(fid, '%s', 1);
paraName = fscanf(fid, '%s', 1);
muMin = fscanf(fid, '%f', 1);
deltaMu = fscanf(fid, '%f', 1);
muMax = fscanf(fid, '%f', 1);
fCutOffString = fscanf(fid, '%s', 1);
fCutOff = fscanf(fid, '%f', 1);

fclose(fid);
