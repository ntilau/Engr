function MatrixMarketWriter(A, filename)


fid = fopen( filename, 'w' );
if fid == -1
  error(strcat('Could not open file: ', filename));
end
fprintf(fid, '%%%%MatrixMarket matrix coordinate ');

% find varType
if nnz(imag(A)) == 0
  varType = 'real';
else
  varType = 'complex';
end
fprintf(fid, '%s ', varType);

% find matType
[r c] = size(A);
[i j s] = find(A);
[iT jT sT] = find(A.');
if r == c
  % A is quadratic
  if sum(i == iT) == length(i) && sum(j == jT) == length(j) && sum(s == sT) == length(s);
    matType = 'symmetric';
  else
    matType = 'general';
  end
else
  matType = 'general';
end
fprintf(fid, '%s\n', matType);

if strcmp(matType, 'symmetric')
  % remove upper right part of matrix
  toDelete = logical((i - j) < 0);
  s(toDelete) = 0;
  A = sparse(i, j, s);
  [i j s] = find(A);
end

nz = nnz(A);
% write dimension and number of nonzeros
fprintf(fid, '%i %i %i\n', r, c, nz);

% write matrix entries
if strcmp(varType, 'real')
  fprintf(fid, '%i %i %17.16e\n', [i j s].');
elseif strcmp(varType, 'complex')
  fprintf(fid, '%i %i %17.16e %17.16e\n', [i j real(s) imag(s)].');
else
  error('Something is wrong with the varType!');
end

fclose(fid);
