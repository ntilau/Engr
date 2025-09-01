% close all;
clear all:

set(0,'DefaultFigureWindowStyle','docked');
  
order = 10;
fontsize = 12;
modelName = 'C:\work\Yves\rectWG\rectWG_1port_Hplane_175e6\testEV\';

impedanceFlag = true;
linFreqParamFlag = true;

buildRedModelInterpolation(modelName, order, linFreqParamFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag);

[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);

% plot results
figHandle = figure;
set(figHandle,'color','w');

% one parameter plot
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs * 1e-9, angle(sVal));

% Referenz
fNameSparaRef = 'C:\work\Yves\rectWG\rectWG_1port_Hplane_175e6\testEV\S_f_150000000_350000000_101_ref.txt'
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSparaRef);

% plot results
figHandle = figure;
set(figHandle,'color','w');

% one parameter plot
sValRef = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sValRef(k) = sMatrices{k}(1, 1);
end
plot(freqs * 1e-9, angle(sValRef));

figHandle = figure;
set(figHandle,'color','w');
plot(freqs * 1e-9, abs(sVal - sValRef));





