function Mat = MatrixMarketReaderSparse( filename )

fid = fopen( filename, 'r' );
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end
fscanf( fid, '%s', 3 );
varType = fscanf( fid, '%s', 1 );
matType = fscanf( fid, '%s', 1 );

rowDim  = fscanf( fid, '%i', 1 );
colDim  = fscanf( fid, '%i', 1 );
valCnt  = fscanf( fid, '%i', 1 );
Mat = sparse(rowDim, colDim);

if strcmp(varType, 'real')
  dummy = fscanf(fid, '%i %i %g', [3 inf]); % read data
  if( ~strcmp(matType, 'general') ) % matrix is symmetric
    I = find(dummy(1,:) == dummy(2,:));
    dummy(3:4,I) = dummy(3:4,I) / 2;
    Mat = spconvert(dummy.');
    Mat = Mat.'+Mat;
  else
    Mat = spconvert(dummy.');
  end
elseif strcmp(varType, 'complex')
  dummy = fscanf(fid, '%i %i %g %g', [4 inf]);  % read data
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
