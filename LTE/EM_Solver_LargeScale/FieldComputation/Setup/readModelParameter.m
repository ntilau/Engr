function [f0, numLeftVecs] = readModelParameter(filename) 

fid = fopen( filename, 'r' );
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end

fscanf(fid, '%s', 1);       % read 'f0'
f0 = fscanf(fid, '%f', 1);
numMatParamsStr = fscanf(fid, '%s', 1);       % read 'numMaterialParams'
if ~strcmp(numMatParamsStr, 'numMaterialParams')
  error(strcat('error in reading file: ', filename));
end
fscanf(fid, '%i', 1);  % number of material parameters
fscanf(fid, '%s', 1);       % read 'ABC'
fscanf(fid, '%s', 1);       % read yes/no
fscanf(fid, '%s', 1);       % read 'NumLeftVecs'
numLeftVecs = fscanf(fid, '%i', 1);

fclose(fid);
