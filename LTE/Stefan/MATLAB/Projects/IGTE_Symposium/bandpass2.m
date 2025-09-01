close all;
clear;

addpath(genpath('C:\work\Matlab'));
set(0,'DefaultFigureWindowStyle','docked');
fontsize = 14;
linewidth = 1.0;


%% Build ROM

order = 10;
modelName = 'C:\work\examples\bandpassfilter\bandpass2\bandpass2_1.1e+009_10\';
% modelName = 'C:\work\examples\bandpassfilter\bandpass2\bandpass2_1.1e+009_10_eff\';

impedanceFlag = true;
linFreqParamFlag = true;
 
% buildRedModelInterpTransp(modelName, order, linFreqParamFlag);
% buildRedModelInterpTranspEfficient(modelName, order, linFreqParamFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag);
% fNameSpara = [modelName 'S_f_1000000000_4500000000_101_MU_RELATIVE_74_1_7_101.txt'];

[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);

% one parameter plot
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sVal1 = sVal;
freqs1 = freqs;
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
grid;

figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs1 * 1e-9, 20 * log10(abs(sVal1)), 'LineWidth', linewidth);
grid;
hold;

[fPur, sMatrices] = readSparamWaveSolverCell('C:\work\examples\bandpassfilter\bandpass2_wSolver\sparam.txt');
sValWaveSolver = zeros(length(fPur), 1);
for k = 1 : length(fPur)
  sValWaveSolver(k) = sMatrices{k}(1, 1);
end
% figHandle = figure;
% set(figHandle, 'color', 'w');
plot(fPur * 1e-9, 20 * log10(abs(sValWaveSolver)), 'rd', 'LineWidth', linewidth);
grid;

