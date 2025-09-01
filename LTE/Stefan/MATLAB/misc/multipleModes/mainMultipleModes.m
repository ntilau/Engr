close all;
clear;

addpath(genpath('C:\work\Matlab'));
% addpath(genpath('V:\Ortwin\ModRedBeispiel\OrtwinMatlab'));
set(0,'DefaultFigureWindowStyle', 'docked');
fontsize = 12;
linewidth = 1.0;


%% Build ROM

order = 7;
% modelName = 'C:\work\examples\block\block_1e+010_10\';
modelName = 'C:\work\examples\block\block\block_1e+010_15\';
% modelName = 'C:\work\examples\block\blockLong\blockLong_1e+010_15\';
impedanceFlag = true;
linFreqParamFlag = true;
newEndingFlag = true;

%%%%%%%%%%%%%%%%%%%%%%%%
%%% modifications needed only for first call
% sys0 = MatrixMarketReader([modelName 'system matrix']);
% k2Mat = MatrixMarketReader(strcat(modelName, 'k^2 matrix'));
% [f0, paramNames, paramValInExp, numLeftVecs, abcFlag] = readModParaTxt(strcat(modelName, 'modelParam.txt'));
% c0 = 299792.458e3;
% k0 = 2 * pi * f0 / c0;
% sys0 = sys0 - k0 ^ 2 * k2Mat;
% MatrixMarketWriter(sys0, [modelName 'system matrix']);
%%%%%%%%%%%%%%%%%%%%%%%

% expPnt = -4.3926e+004;
expPnt = +4.3926e+004;
buildRedModelInterpTranspArbExpPnt(modelName, order, linFreqParamFlag, expPnt);
fNameSpara = modelEvaluation(modelName, impedanceFlag, newEndingFlag);
% fNameSpara = [modelName 'S_f_8e+009_1.2e+010_401.txt'];
% fNameSpara = [modelName 'S_f_8000000000_12000000000_401.txt'];

[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);

% one parameter plot
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
    freqs(k) = parameterVals(1, k);
    sVal(k) = sMatrices{k}(1, 2);
end
sVal1 = sVal;
freqs1 = freqs;
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs1 * 1e-9, 20*log10(abs(sVal1)), 'LineWidth', linewidth);
grid;
% hold;



