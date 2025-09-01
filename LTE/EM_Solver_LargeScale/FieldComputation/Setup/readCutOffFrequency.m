% read file "model.pvar"
function fCutOff = readCutOffFrequency(filename)

fid = fopen( filename, 'r' );
if fid == -1
    error(strcat('Could not open file: ', filename));
end

fscanf(fid, '%s', 1);
% freqParam.fCutOff = fscanf(fid, '%f', 1);
% read ArrayReal with cut off frequencies
fscanf(fid, '%s', 1);   % read '{'
fscanf(fid, '%s', 1);   % read 'AR'
numExcitations = fscanf(fid, '%f', 1);
fCutOff = zeros(numExcitations, 1);
for k = 1:numExcitations
    fCutOff(k) = fscanf(fid, '%f', 1);
end

fclose(fid);
