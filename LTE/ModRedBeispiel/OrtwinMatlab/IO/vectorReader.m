function vector = vectorReader( filename ) 

fid = fopen( filename, 'r' );
beginBlock = fscanf(fid, '%s', 1);
type = fscanf(fid, '%s', 1);
rowDim  = fscanf( fid, '%i', 1 );
vector = zeros(rowDim, 1);
if type == 'AR'
  for i = 1:rowDim
    vector(i) = fscanf(fid, ' %f', 1);
  end
elseif type == 'AC'
  for i = 1:rowDim
    vector(i) = readComplex(fid);
  end
elseif type == 'AI'
  for i=1:rowDim
    vector(i) = fscanf(fid, ' %f', 1);
  end
else
  error('not yet implemented', 'Wrong array type in reader');
end

fclose( fid );