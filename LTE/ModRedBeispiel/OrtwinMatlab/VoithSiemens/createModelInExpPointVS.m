function modelInExpPnt = createModelInExpPointVS(model, permutMat, expPnt)

% determine order of parameter dependence
order = sum(permutMat(length(model.sysMat),:));
sysMatInExpPnt = cell(order + 1, 1);
rhsInExpPnt = cell(order + 1, 1);
numParams = size(permutMat, 2);
for orderCnt = 0 : order
  coeffThisOrder = [];
  coeffThisOrder = rec(numParams, orderCnt, coeffThisOrder, 0, 1);
  for coeffCnt = 1 : size(coeffThisOrder, 1)
    posRowInPermutMat = findRowInMat(coeffThisOrder(coeffCnt, :), permutMat);
    if (posRowInPermutMat <= length(model.sysMat)) && ~isempty(model.sysMat{posRowInPermutMat})
      scaleFactor = 1;
      for colCnt = 1 : size(coeffThisOrder, 2)
        scaleFactor = scaleFactor * expPnt(colCnt) ^ coeffThisOrder(coeffCnt, colCnt);
      end
      if ~nnz(sysMatInExpPnt{orderCnt + 1})
        sysMatInExpPnt{orderCnt + 1} = scaleFactor * model.sysMat{posRowInPermutMat};
      else
        sysMatInExpPnt{orderCnt + 1} = sysMatInExpPnt{orderCnt + 1} + scaleFactor * model.sysMat{posRowInPermutMat};
      end
      if ~nnz(rhsInExpPnt{orderCnt + 1})
        rhsInExpPnt{orderCnt + 1} = scaleFactor * model.rhs{posRowInPermutMat};
      else
        rhsInExpPnt{orderCnt + 1} = rhsInExpPnt{orderCnt + 1} + scaleFactor * model.rhs{posRowInPermutMat};
      end
    end
  end
end
modelInExpPnt.sysMat = sysMatInExpPnt;
modelInExpPnt.rhs = rhsInExpPnt;

