function params = readParams(fileName)


fid = fopen(fileName, 'r');
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end

firstString = fscanf(fid, '%s', 1);
if ~strcmp(firstString, 'NumberOfParameters')
  error('File should start with NumberOfParameters!');
end
numParams = fscanf(fid, '%i', 1);

params = cell(numParams, 1);
for paramCnt = 1 : numParams
  % read '{'
  fscanf(fid, '%s', 1);
  params{paramCnt}.name = fscanf(fid, '%s', 1);
  params{paramCnt}.min = readComplex(fid);
  params{paramCnt}.max = readComplex(fid);
  params{paramCnt}.numPnts = fscanf(fid, '%i', 1);
  % read '}'
  fscanf(fid, '%s', 1);
end

fclose(fid);
