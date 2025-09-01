function oneParamModel = createOneParamModel(sysMat, permutMat, interpolPnt)

% determine order of parameter dependence
order = sum(permutMat(length(sysMat),:));
numParams = size(permutMat, 2);
oneParamModel = cell(order + 1, 1);
for orderCnt = 1:order
  coeffThisOrder = [];
  coeffThisOrder = rec(numParams, orderCnt, coeffThisOrder, 0, 1);
  oneParamModel{orderCnt + 1} = sparse(size(sysMat{1}, 1), size(sysMat{1}, 1));
  for coeffCnt = 1:size(coeffThisOrder, 1)
    posRowInPermutMat = findRowInMat(coeffThisOrder(coeffCnt,:), permutMat);
    if (posRowInPermutMat <= length(sysMat)) && ~isempty(sysMat{posRowInPermutMat})
      scaleFactor = 1;
      for colCnt = 1:size(coeffThisOrder, 2)
        scaleFactor = scaleFactor * interpolPnt(colCnt)^coeffThisOrder(coeffCnt, colCnt);
      end
      oneParamModel{orderCnt + 1} = oneParamModel{orderCnt + 1} + scaleFactor * sysMat{posRowInPermutMat};
    end
  end
end

  