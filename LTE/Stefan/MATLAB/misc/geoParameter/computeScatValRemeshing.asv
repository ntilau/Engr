close all;
clear;

set(0,'DefaultFigureWindowStyle','docked');
fontsize = 14;
linewidth = 1.0;


%% Solve full model

impedanceFlag = true;
linFreqParamFlag = true;
order = 2;

a = 10 : 18;
sVal = zeros(1, length(a));
for aCnt = 1 : length(a)
  modelName = ['C:\work\examples\wgIris\wgIrisQuarterShortRemeshing\wgIrisQuarterShort_1e+010_8_a' num2str(a(aCnt)) '\'];
  buildRedModelInterpTransp(modelName, order, linFreqParamFlag);
  fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag);
  [parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
  sVal(aCnt) = sMatrices{1}(1, 1);
end


%% Solve full model

impedanceFlag = true;
linFreqParamFlag = true;
order = 2;

deltaA = -0.002 : 0.0005 : 0.002;
deltaB = -0.0015;
sVal = zeros(1, length(deltaA));
for aCnt = 1 : length(deltaA)
  modelName = ['C:\work\examples\wgIris\wgIrisQuarterShortRemeshing\deformedMeshes\wgIrisQuarterShort_1e+010_6_dy_' num2str(deltaA(aCnt)) '_dz_' num2str(deltaB) '\'];
%   buildRedModelInterpTransp(modelName, order, linFreqParamFlag);
  fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag);
  [parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
  sVal(aCnt) = sMatrices{1}(1, 1);
end


%% plot results
% one parameter plot
plot(deltaA, abs(sVal), 'LineWidth', linewidth);

save('C:\work\MATLAB\Projects\Ansoft2007\newMeshResults', 'deltaA', 'deltaB', 'sVal');
