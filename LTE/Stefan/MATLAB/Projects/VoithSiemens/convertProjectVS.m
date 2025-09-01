function dirPath = convertProjectVS(modelPath, shortFlag)

model.maxOrder = 2;
model.numParams = 3;

% construct matrix with the ordering of the coefficients
coeffSequence = [];
order = 0;
while order <= model.maxOrder
  coeffSequence = rec(model.numParams, order, coeffSequence, 0, 1);
  order = order + 1;
end

% zeroth order parameter dependence
model.sysMat{1} = MatrixMarketReader(strcat(modelPath, 'SysStiffnessMat.mm'));
rhsMat = MatrixMarketReader(strcat(modelPath, 'SysComplexLoadConst.mm'));
model.rhs{1} = rhsMat(:, 1) + j * rhsMat(:, 2);
model.outputFunctional{1} = MatrixMarketReader(strcat(modelPath, 'SysGetOutputSelect.mm'));

% first order parameter dependence
% linear dmpr dependence
row = [0 1 0];
posFound = findRowInMat(row, coeffSequence);
model.sysMat{posFound} = j * MatrixMarketReader(strcat(modelPath, 'SysDampDMPR.mm'));

% second order parameter dependence
% square frequency dependence: convert omega dependence into frequency dependence
row = [2 0 0];
posFound = findRowInMat(row, coeffSequence);
model.sysMat{posFound} = (-1) * (2 * pi) ^ 2 * MatrixMarketReader(strcat(modelPath, 'SysMassMat.mm'));
rhsMat2 = MatrixMarketReader(strcat(modelPath, 'SysComplexLoadFreqDepend.mm'));
model.rhs{posFound} = (2 * pi) ^ 2 * rhsMat2(:, 1);
% linear frequency dependence and linear impd dependence
row = [1 0 1];
posFound = findRowInMat(row, coeffSequence);
model.sysMat{posFound} = j * (2 * pi) * MatrixMarketReader(strcat(modelPath, 'SysDampIMPD.mm'));

model.coeffSequence = coeffSequence;

% load model model;


%% write unreduced model
if shortFlag
  dirPath = [modelPath 'GeneralParameterDependenceSmall\'];
  model = reduceModelDimension(model);
else
  dirPath = [modelPath 'GeneralParameterDependence\'];
end
writeModel(model, dirPath);



function model = reduceModelDimension(model)
% reduce dimension by only considering the first dim entries
dim = 300;
for sysMatCnt = 1 : length(model.sysMat)
  if ~isempty(model.sysMat{sysMatCnt})
    model.sysMat{sysMatCnt} = model.sysMat{sysMatCnt}(1 : dim, 1 : dim);
  end
end
for rhsCnt = 1 : length(model.rhs)
  if ~isempty(model.rhs{rhsCnt})
    model.rhs{rhsCnt} = model.rhs{rhsCnt}(1 : dim, :);
  end
end

% choose appropriate output functional
model.outputFunctional{1} = zeros(3, dim);
model.outputFunctional{1}(1, dim - 30) = 1;
model.outputFunctional{1}(2, dim - 15) = 2;
model.outputFunctional{1}(1, dim) = 3;
model.outputFunctional{1} = sparse(model.outputFunctional{1});






