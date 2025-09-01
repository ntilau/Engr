function dirPath = convertProjectFrequencyOnlyVS(modelPath, dmpr, impd, multiParameterFlag, shortFlag)


% only frequency dependence
model.sysMat = cell(3, 1);
model.sysMat{1} = MatrixMarketReader(strcat(modelPath, 'SysStiffnessMat.mm')) + ...
  j * dmpr * MatrixMarketReader(strcat(modelPath, 'SysDampDMPR.mm'));
% convert omega dependence into frequency dependence
model.sysMat{3} = (-1) * (2 * pi) ^ 2 * MatrixMarketReader(strcat(modelPath, 'SysMassMat.mm'));

model.rhs = cell(3, 1);
rhsMat = MatrixMarketReader(strcat(modelPath, 'SysComplexLoadConst.mm'));
model.rhs{1} = rhsMat(:, 1) + j * rhsMat(:, 2);
rhsMat2 = MatrixMarketReader(strcat(modelPath, 'SysComplexLoadFreqDepend.mm'));
% convert omega dependence into frequency dependence
model.rhs{3} = (2 * pi) ^ 2 * rhsMat2(:, 1);

% lVecMat = MatrixMarketReader(strcat(modelPath, 'SysGetOutputFull.mm'));
model.outputFunctional = MatrixMarketReader(strcat(modelPath, 'SysGetOutputSelect.mm'));


%% write unreduced model
if shortFlag
  dirPath = [modelPath 'pureFrequencyDependenceSmall\'];
  writeModelShort(model, dirPath)
else
  dirPath = [modelPath 'pureFrequencyDependence\'];
  writeModel(model, dirPath)
end


function writeModelShort(model, dirPath)
% reduce dimension by only considering the first 300 entries
dim = 300;
model.sysMat{1} = model.sysMat{1}(1 : dim, 1 : dim);
model.sysMat{3} = model.sysMat{3}(1 : dim, 1 : dim);
model.rhs{1} = model.rhs{1}(1 : dim);
model.rhs{3} = model.rhs{3}(1 : dim);
% choose appropriate output functional
model.outputFunctional = zeros(3, dim);
model.outputFunctional(1, dim - 30) = 1;
model.outputFunctional(2, dim - 15) = 2;
model.outputFunctional(1, dim) = 3;
model.outputFunctional = sparse(model.outputFunctional);

% matrix market format
MatrixMarketWriter(model.sysMat{1}, [dirPath 'sysMat_0.mm']);
MatrixMarketWriter(model.sysMat{3}, [dirPath 'sysMat_2.mm']);
MatrixMarketWriter(model.rhs{1}, [dirPath 'rhs_0.mm']);
MatrixMarketWriter(model.rhs{3}, [dirPath 'rhs_2.mm']);
MatrixMarketWriter(model.outputFunctional, [dirPath 'outputFunctional.mm']);
% binary format - whole cell array
save([dirPath 'model'], 'model');


function writeModel(model, dirPath)
% matrix market format
MatrixMarketWriter(model.sysMat{1}, [dirPath 'sysMat_0.mm']);
MatrixMarketWriter(model.sysMat{3}, [dirPath 'sysMat_2.mm']);
MatrixMarketWriter(model.rhs{1}, [dirPath 'rhs_0.mm']);
MatrixMarketWriter(model.rhs{3}, [dirPath 'rhs_2.mm']);
MatrixMarketWriter(model.outputFunctional, [dirPath 'outputFunctional.mm']);
% binary format - whole cell array
save([dirPath 'model'], 'model');

