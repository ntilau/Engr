function paramDependence = readParamDependence(filename)

fid = fopen( filename, 'r' );
if fid == -1
  error(strcat('Could not open file: ', filename));
end

dim = fscanf(fid, '%i %i');
% dim(1) is number of rows, dim(2) is number of columns
paramDependence = zeros(dim(1), dim(2));

% read '{' out of file
for rowCnt = 1:dim(1)
  blockBegin = fscanf(fid, '%s', 1);
  if ~strcmp(blockBegin, '{')
    error('There should be a {!');
  end
  AI = fscanf(fid, '%s', 1);
  if ~strcmp(AI, 'AI')
    error('There should be an AI');
  end
  cDummy = fscanf(fid, '%i', 1);
  if cDummy ~= dim(2)
    error('Wrong length of integer array!');
  end
  for colCnt = 1:dim(2)
    paramDependence(rowCnt, colCnt) = fscanf(fid, '%i', 1);
  end
  blockEnd = fscanf(fid, '%s', 1);
  if ~strcmp(blockEnd, '}')
    error('There should be a }!');
  end  
end  

fclose(fid);

