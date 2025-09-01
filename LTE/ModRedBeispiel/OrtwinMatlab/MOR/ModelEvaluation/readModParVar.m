function [freqParam, materialParams] = readModParVar(filename) 

fid = fopen( filename, 'r' );
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end

freqParam.fMin = fscanf(fid, '%f', 1);
freqParam.fMax = fscanf(fid, '%f', 1);
numF_Pnts = fscanf(fid, '%i', 1);   % number of frequency points
freqParam.numPnts = numF_Pnts;
fCutOffString = fscanf(fid, '%s', 1);
% freqParam.fCutOff = fscanf(fid, '%f', 1);
% read ArrayReal with cut off frequencies
fCutOffString = fscanf(fid, '%s', 1);   % read '{'
fCutOffString = fscanf(fid, '%s', 1);   % read 'AR'
numExcitations = fscanf(fid, '%f', 1);
fCutOff = zeros(numExcitations, 1);
for k = 1:numExcitations
  fCutOff(k) = fscanf(fid, '%f', 1);
end
fCutOffString = fscanf(fid, '%s', 1);   % read '}'
freqParam.fCutOff = fCutOff;

numMatParamsStr = fscanf(fid, '%s', 1);       % read 'numMaterialParams'
if ~strcmp(numMatParamsStr, 'numMaterialParams')
  error(strcat('error in reading file: ', filename));
end
numMatParams = fscanf(fid, '%i', 1);  % number of material parameters
materialParams = [];
for k = 1:numMatParams
  blockBeginStr = fscanf(fid, '%s', 1);       % read '{'
  if ~strcmp(blockBeginStr, '{')
    error(strcat('error in reading file: ', filename));
  end
  numG_Solids = fscanf(fid, '%i', 1);  % read number of gSolids
  for m = 1:numG_Solids
    gSolids{m} = fscanf(fid, '%s', 1);
  end
  materialParams(k).gSolids = gSolids;
  materialParams(k).name = fscanf(fid, '%s', 1);       % read parameter name
  materialParams(k).min = readComplex(fid);
  materialParams(k).max = readComplex(fid);
  materialParams(k).numPnts = fscanf(fid, '%i', 1);
  blockBeginStr = fscanf(fid, '%s', 1);       % read '}'
end

fclose(fid);
