function bBlocks = findBuildingBlocksPoly(permutMat, rowNumber, sysMat)

bBlocks = [];
[r c] = size(permutMat);

for k = 2:length(sysMat)
  if ~isempty(sysMat{k})
    polyCoeff = permutMat(k,:);  % polynomial coefficient of matrix k
    for i = 1:rowNumber
      if sum((polyCoeff + permutMat(i,:)) == permutMat(rowNumber,:)) == c
        % building block found
        bBlocks = [bBlocks, [k; i]];
      end
    end
  end
end

  