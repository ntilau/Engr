function modelInExpPnt = createFreqModelInExpPointVS(model, permutMat, expPnt)

% determine order of parameter dependence
order = sum(permutMat(length(model.sysMat),:));
if order ~= 2
  error('A maximum parameter dependence of order 2 is assumed!');
end

pureSquareFreqDependence = false;
if length(expPnt) == 1
  pureSquareFreqDependence = true;
elseif ~nnz(expPnt(2 : end))
  pureSquareFreqDependence = true;
end

if pureSquareFreqDependence
  sysMatInExpPnt = cell(2, 1);
  rhsInExpPnt = cell(2, 1);
  % zero order parameter dependence
  sysMatInExpPnt{1} = model.sysMat{1} + expPnt(1) ^ 2 * model.sysMat{3};
  rhsInExpPnt{1} = model.rhs{1} + expPnt(1) ^ 2 * model.rhs{3};
  outputFunctionalInExpPnt = model.outputFunctional;
  % first order parameter dependence
  sysMatInExpPnt{2} = expPnt(1) ^ 2 * model.sysMat{3};
  rhsInExpPnt{2} = expPnt(1) ^ 2 * model.rhs{3};
else
  sysMatInExpPnt = cell(order + 1, 1);
  rhsInExpPnt = cell(order + 1, 1);
  outputFunctionalInExpPnt = cell(order + 1, 1);  
end

modelInExpPnt.sysMat = sysMatInExpPnt;
modelInExpPnt.rhs = rhsInExpPnt;
modelInExpPnt.outputFunctional = outputFunctionalInExpPnt;


