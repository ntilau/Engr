function oneParamModel = createOneParamModelVS(model, permutMat, interpolPnt)

% determine order of parameter dependence
order = sum(permutMat(length(model.sysMat),:));
sysMatOneParam = cell(order + 1, 1);
rhsOneParam = cell(order + 1, 1);
numParams = size(permutMat, 2);
for orderCnt = 0 : order
  coeffThisOrder = [];
  coeffThisOrder = rec(numParams, orderCnt, coeffThisOrder, zeros(1, numParams), 1);
  for coeffCnt = 1 : size(coeffThisOrder, 1)
    posRowInPermutMat = findRowInMat(coeffThisOrder(coeffCnt, :), permutMat);
    scaleFactor = 1;
    for colCnt = 1 : size(coeffThisOrder, 2)
      scaleFactor = scaleFactor * interpolPnt(colCnt) ^ coeffThisOrder(coeffCnt, colCnt);
    end
    if (posRowInPermutMat <= length(model.sysMat)) && ~isempty(model.sysMat{posRowInPermutMat})
      if ~nnz(sysMatOneParam{orderCnt + 1})
        sysMatOneParam{orderCnt + 1} = scaleFactor * model.sysMat{posRowInPermutMat};
      else
        sysMatOneParam{orderCnt + 1} = sysMatOneParam{orderCnt + 1} + scaleFactor * model.sysMat{posRowInPermutMat};
      end
    end
    if (posRowInPermutMat <= length(model.rhs)) && ~isempty(model.rhs{posRowInPermutMat})
      if ~nnz(rhsOneParam{orderCnt + 1})
        rhsOneParam{orderCnt + 1} = scaleFactor * model.rhs{posRowInPermutMat};
      else
        rhsOneParam{orderCnt + 1} = rhsOneParam{orderCnt + 1} + scaleFactor * model.rhs{posRowInPermutMat};
      end
    end
  end
end
oneParamModel.sysMat = sysMatOneParam;
oneParamModel.rhs = rhsOneParam;

