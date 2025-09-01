function polyCellShifted = shiftExpPoint(polyCell, permutMat, shift)

polyCellShifted = cell(size(permutMat,1),1);
for iRow = 1:size(permutMat,1)
  [v mPowers] = getShiftedMultivariatePolynom(permutMat(iRow,:), shift);
  if ~isempty(polyCell{iRow})
    polyCellShifted = add2PolyCell(polyCellShifted, permutMat, v, mPowers, ...
      polyCell{iRow});
  end
end





function polyCell = add2PolyCell(polyCell, permutMat, v, mPowers, A)

for iCoeff = 1:length(v)
  rowNum = findRowInMat(mPowers(iCoeff,:), permutMat);
  if isempty(polyCell{rowNum})
    polyCell{rowNum} = v(iCoeff)*A;
  else
    polyCell{rowNum} = polyCell{rowNum} + v(iCoeff)*A;
  end
end



