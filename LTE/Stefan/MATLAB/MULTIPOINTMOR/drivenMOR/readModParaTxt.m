function [f0, paramNames, paramValInExp, numLeftVecs, abcFlag] = ...
  readModParaTxt(filename) 

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
numMatParams = fscanf(fid, '%i', 1);  % number of material parameters
paramNames = [];
paramValInExp = [];
for k = 1:numMatParams
  paramNames{k} = fscanf(fid, '%s', 1);       % read parameter name
  paramValInExp(k) = readComplex(fid);
end
fscanf(fid, '%s', 1);       % read 'ABC'
abcFlag = strcmp(fscanf(fid, '%s', 1), 'yes');
fscanf(fid, '%s', 1);       % read 'NumLeftVecs'
numLeftVecs = fscanf(fid, '%i', 1);

fclose(fid);
