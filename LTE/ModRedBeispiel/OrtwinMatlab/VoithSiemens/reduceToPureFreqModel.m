function pureFreqModel = reduceToPureFreqModel(model)

maxOrder = sum(model.coeffSequence(end, :));
numParams = length(model.coeffSequence(1, :));
row = zeros(1, numParams);
for orderCnt = 0 : maxOrder
  row(1, 1) = orderCnt;
  posPureFreqDependence = findRowInMat(row, model.coeffSequence);
  if posPureFreqDependence <= length(model.sysMat)
    pureFreqModel.sysMat{orderCnt + 1} = model.sysMat{posPureFreqDependence};
  end
  if posPureFreqDependence <= length(model.rhs)
    pureFreqModel.rhs{orderCnt + 1} = model.rhs{posPureFreqDependence};
  end
  if posPureFreqDependence <= length(model.outputFunctional)
    pureFreqModel.outputFunctional{orderCnt + 1} = model.outputFunctional{posPureFreqDependence};
  end  
end
pureFreqModel.coeffSequence = (0 : maxOrder)';
