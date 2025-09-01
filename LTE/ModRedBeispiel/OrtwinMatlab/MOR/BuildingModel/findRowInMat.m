function rowNumber = findRowInMat(row, permutMat)
% Finds the row vector 'row' in the rows of permutMat and returns the
% position of the first occurence. If the row doesn't occure, -1 is
% returned. The length of row and the number of columns of permutMat have 
% to be identical.

rowNumber = -1;
[r c] = size(permutMat);
if length(row) ~= c
  error('The length of row and the number of columns of permutMat have to be identical.');
end
for k = 1:r
  if permutMat(k,:) == row
    rowNumber = k;
    return;
  end
end
