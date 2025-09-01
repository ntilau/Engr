function OneParamModel = createOneParamModelCirc(sysMat, permutMat, ...
  interpolPnt, rhs)

% determine order of parameter dependence
order = sum(permutMat(length(sysMat),:));
numParams = size(permutMat, 2);
OneParamModel.sysMat = cell(order+1, 1);
OneParamModel.rhs = cell(order+1, 1);
for orderCnt = 1:order
  coeffThisOrder = [];
  coeffThisOrder = rec(numParams, orderCnt, coeffThisOrder, 0, 1);
  OneParamModel.sysMat{orderCnt+1} = sparse(size(sysMat{1},1), ...
    size(sysMat{1},1));
  OneParamModel.rhs{orderCnt+1} = zeros(length(rhs{1}),1);
  for coeffCnt = 1:size(coeffThisOrder, 1)
    posRowInPermutMat = findRowInMat(coeffThisOrder(coeffCnt,:), permutMat);
    if posRowInPermutMat<=length(sysMat) && ~isempty(sysMat{posRowInPermutMat})
      scaleFactor = 1;
      for colCnt = 1:size(coeffThisOrder, 2)
        scaleFactor = scaleFactor * ...
          interpolPnt(colCnt)^coeffThisOrder(coeffCnt, colCnt);
      end
      OneParamModel.sysMat{orderCnt+1} = OneParamModel.sysMat{orderCnt+1} + ...
        scaleFactor * sysMat{posRowInPermutMat};
    end
    if posRowInPermutMat<=length(rhs) && ~isempty(rhs{posRowInPermutMat})
      scaleFactor = 1;
      for colCnt = 1:size(coeffThisOrder, 2)
        scaleFactor = scaleFactor * ...
          interpolPnt(colCnt)^coeffThisOrder(coeffCnt, colCnt);
      end
      OneParamModel.rhs{orderCnt+1} = OneParamModel.rhs{orderCnt+1} + ...
        scaleFactor * rhs{posRowInPermutMat};
    end
  end
end

