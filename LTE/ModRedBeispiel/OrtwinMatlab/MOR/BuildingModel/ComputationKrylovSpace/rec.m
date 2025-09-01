function matrix = rec(numParam, sumPow, matrix, row, pos)

[r c] = size(matrix);

if sumPow == 0
  matrix(r+1,1:length(row)) = row;
elseif pos > numParam
  matrix = matrix;
else
  for k = sumPow:-1:0
    row(pos) = k;
    matrix = rec(numParam, sumPow-k, matrix, row, pos+1);
  end
end

