close all;
clear;

format short e;
addpath(genpath('C:\work\Matlab'));
set(0, 'DefaultFigureWindowStyle', 'docked');
modelPath = 'C:\work\examples\MOR_Example_VoithSiemens\';
shortFlag = false;
% dirPath = convertProjectVS(modelPath, shortFlag);
% dirPath = [modelPath 'GeneralParameterDependenceTestModel\'];
dirPath = [modelPath 'GeneralParameterDependence\'];


%% only debug purpose
% fNameResults = solveModelVS(dirPath);
% fNameResults = [dirPath 'Frequency_0_10_201_Dmpr_1_100_1_Impd_1_100_1.mat'];
fNameResults = [modelPath 'results\Frequency_0_100_201_Dmpr_0.1_100_1_Impd_1_100_1.mat'];
% fNameResults = 'C:\work\examples\MOR_Example_VoithSiemens\pureFrequencyDependenceSmall\Frequency_0_100_201.mat';
load(fNameResults);
outputId = [1 1];
plotData = plotResultsVS(results, params, paramSpace, outputId);


%% model order reduction
order = 100;
expansionPoint = [50 0 2];
pureQuadraticFreqDep = false;
if expansionPoint(2) == 0 && expansionPoint(3) == 0 && pureQuadraticFreqDep
  romDirName = buildRedModelSquareFreqDepOnlyVS(dirPath, order, expansionPoint);
else
  freqModelOnlyFlag = true;
  romDirName = buildRedModelVS(dirPath, order, expansionPoint, freqModelOnlyFlag);
end
romDirName = 'C:\work\examples\MOR_Example_VoithSiemens\results\rom_200_Frequency_50_Dmpr_0_Impd_2_FreqOnly_1_orth\';
fNameResultsRom = solveModelVS(romDirName);
load(fNameResultsRom);
outputId = [1 1];
plotDataRom = plotResultsVS(results, params, paramSpace, outputId);

figure;
semilogy(plotData.xData, abs(plotData.yData - plotDataRom.yData) ./ abs(plotData.yData));


%% test createGeneralModelInExpPointVS
dim = 5;
model.sysMat{1} = ones(dim);
model.sysMat{2} = 2 * ones(dim);
model.sysMat{3} = 3 * ones(dim);
model.sysMat{4} = 4 * ones(dim);
model.sysMat{5} = 5 * ones(dim);
model.sysMat{6} = 6 * ones(dim);

model.rhs{1} = ones(dim, 1);
model.outputFunctional{1} = ones(1, dim);
expPnt = [2 3];
maxOrder = 2;
coeffSequence = [];
numParams = 2;
for k = 0 : maxOrder
  coeffSequence = rec(numParams, k, coeffSequence, 0, 1);
end
model.coeffSequence = coeffSequence;

modelInExpPnt = createGeneralModelInExpPointVS(model, expPnt);


%% test wcawe

dim = 100;
order = 10;
rhs{1} = randn(dim, 1);
rhs{2} = randn(dim, 1);
sys{1} = sparse(randn(dim));
sys{2} = sparse(randn(dim));
model.sysMat = sys;
model.rhs = rhs;
[fact.L fact.U fact.P fact.Q] = lu(sys{1});
Q1 = wcaweVS(fact, model, order);

% sys{3} = sys{2};
% model.sysMat = sys;
% Q2 = wcaweVS(fact, model, order);

Q3 = wcaweVS2(fact, model, order);

% (U, w, m, n)
% dim = 10;
% A = randn(dim);
% [Q R] = qr(A);
% M1 = PUw(R, 1, 3, 7);
% display(M1);
% M2 = PUwInverse(R, 1, 3, 7);
% display(inv(M2));

%% Create test model

modelPath = 'C:\work\examples\MOR_Example_VoithSiemens\GeneralParameterDependenceTestModel\';
dim = 100;
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
% model.sysMat{1} = sparse(diag(1 : dim));
model.sysMat{1} = sparse(randn(dim));
model.rhs{1} = (1 + j) * ones(dim, 1);
model.outputFunctional{1} = zeros(1, dim);
model.outputFunctional{1}(1, 1) = 1.0;
% first order parameter dependence
% linear dmpr dependence
row = [0 1 0];
posFound = findRowInMat(row, coeffSequence);
% model.sysMat{posFound} = j * sparse(diag(ones(1, dim)));
model.sysMat{posFound} = sparse(randn(dim));
% second order parameter dependence
% square frequency dependence: convert omega dependence into frequency dependence
row = [2 0 0];
posFound = findRowInMat(row, coeffSequence);
% model.sysMat{posFound} = sparse((-1) * (2 * pi) ^ 2 * diag(-30 + (1 : dim)));
model.sysMat{posFound} = sparse(randn(dim));
model.rhs{posFound} = (2 * pi) ^ 2 * (-50 + (1 : dim)).';
% linear frequency dependence and linear impd dependence
row = [1 0 1];
posFound = findRowInMat(row, coeffSequence);
% model.sysMat{posFound} = sparse(j * (2 * pi) * diag(-70 + (1 : 2 : (2 * dim))));
model.sysMat{posFound} = sparse(randn(dim));

model.coeffSequence = coeffSequence;

writeModel(model, modelPath);



