function Mat = MatrixMarketReader(filename)


fid = fopen(filename, 'r');
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end

currentLine = fgetl(fid);
isSpace = find(currentLine == ' ');
varType = currentLine((isSpace(3) + 1) : (isSpace(4) - 1));
if length(isSpace) == 4
  matType = currentLine((isSpace(4) + 1) : end);
else
 matType = currentLine((isSpace(4) + 1) : (isSpace(5) - 1));
end

isComment = true;
while isComment
  % read comment lines
  currentLine = fgetl(fid);
  if currentLine(1) ~= '%'
    % currentLine contains dimension and number of nonzeros of matrix A
    isComment = false;
  end
end

isSpace = find(currentLine == ' ');
rowDim = str2double(currentLine(1 : (isSpace(1) - 1)));
colDim = str2double(currentLine((isSpace(1) + 1) : (isSpace(2) - 1)));

if strcmp(varType, 'real')
  dummy = fscanf(fid, '%i %i %g', [3 inf]); % read data
  dummy = [dummy [rowDim; colDim; 0]];
  if( ~strcmp(matType, 'general') ) % matrix is symmetric
    I = find(dummy(1,:) == dummy(2,:));
    dummy(3,I) = dummy(3,I) / 2;
    Mat = spconvert(dummy.');
    Mat = Mat.'+Mat;
  else
    Mat = spconvert(dummy.');
  end
elseif strcmp(varType, 'complex')
  dummy = fscanf(fid, '%i %i %g %g', [4 inf]);  % read data
  dummy = [dummy [rowDim; colDim; 0; 0]];
  if( ~strcmp(matType, 'general') ) % matrix is symmetric
    I = find(dummy(1,:) == dummy(2,:));
    dummy(3:4,I) = dummy(3:4,I) / 2;
    Mat = spconvert(dummy.');
    Mat = Mat.'+Mat;
  else
    Mat = spconvert(dummy.');
  end
else
  fclose(fid);
  error('Something is wrong with the varType');
end
fclose(fid);
