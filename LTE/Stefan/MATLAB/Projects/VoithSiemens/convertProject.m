close all;
clear;

format short e;
addpath(genpath('C:\work\Matlab'));
set(0, 'DefaultFigureWindowStyle', 'docked');
modelPath = 'C:\work\examples\MOR_Example_VoithSiemens\';

shortFlag = false;

% only frequency dependence
model.sysMat = cell(3, 1);
model.sysMat{1} = MatrixMarketReader(strcat(modelPath, 'SysStiffnessMat.mm'));
% convert omega dependence into frequency dependence
model.sysMat{3} = (-1) * (2 * pi) ^ 2 * MatrixMarketReader(strcat(modelPath, 'SysMassMat.mm'));

model.rhs = cell(3, 1);
rhsMat = MatrixMarketReader(strcat(modelPath, 'SysComplexLoadConst.mm'));
model.rhs{1} = rhsMat(:, 1) + j * rhsMat(:, 2);
rhsMat2 = MatrixMarketReader(strcat(modelPath, 'SysComplexLoadFreqDepend.mm'));
% convert omega dependence into frequency dependence
model.rhs{3} = (2 * pi) ^ 2 * rhsMat2(:, 1);

numParams = 1;

% lVecMat = MatrixMarketReader(strcat(modelPath, 'SysGetOutputFull.mm'));
model.outputFunctional = MatrixMarketReader(strcat(modelPath, 'SysGetOutputSelect.mm'));


%% write unreduced model
if shortFlag
  dirPath = [modelPath 'pureFrequencyDependenceSmall\'];
else
  dirPath = [modelPath 'pureFrequencyDependence\'];
  % matrix market format
  MatrixMarketWriter(model.sysMat{1}, [dirPath 'sysMat_0.mm']); 
  MatrixMarketWriter(model.sysMat{3}, [dirPath 'sysMat_2.mm']);
  MatrixMarketWriter(model.rhs{1}, [dirPath 'rhs_0.mm']);
  MatrixMarketWriter(model.rhs{3}, [dirPath 'rhs_2.mm']);
  MatrixMarketWriter(model.outputFunctional, [dirPath 'outputFunctional.mm']);
  % binary format - whole cell array
  save([dirPath 'model'], 'model');                     
end

%% only debug purpose
fNameResults = solveUnredModelVS(dirPath);
params = [];
paramSpace = [];
results = [];
load(fNameResults);
plotData = plotResultsVS(results, params, paramSpace);

order = 8;
romDirName = buildRedModelVS(dirPath, order);


%% test wcawe

dim = 10;
order = 4;
rhs{1} = randn(dim, 1);
sys{1} = sparse(randn(dim));
sys{2} = sparse(randn(dim));
[fact.L fact.U fact.P fact.Q] = lu(sys{1});
Q1 = wcaweVS(fact, sys, rhs, order);

sys{3} = sys{2};
Q2 = wcaweVS(fact, sys, rhs, order);



function a = writeModelVS_Short(dirPath, model)

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
  % save([dirPath 'sysMat'], 'sysMat');                     
  % save([dirPath 'rhs'], 'rhs');                     
  % save([dirPath 'outputFunctional'], 'outputFunctional');                     



