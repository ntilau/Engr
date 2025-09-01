close all;
clear;

addpath(genpath('C:\work\Matlab'));
addpath(genpath('V:\Ortwin\ModRedBeispiel\OrtwinMatlab'));
set(0,'DefaultFigureWindowStyle', 'docked');
fontsize = 12;
linewidth = 1.0;


%% Build ROM

order = 10;
% modelName = 'C:\work\examples\coax\coax2\coax2_4.77135e+007_7_sqrtK\';
% modelName = 'C:\work\examples\coax\coax2\coax2_4.77135e+007_7_sqrtK_C\';
% modelName = 'V:\Ortwin\dielPostWG_2e+008_30\';
modelName = 'C:\work\examples\permittivity_measurement\wg_perm_sym_test\wg_perm_sym_1.3e+010_100\';

impedanceFlag = true;
linFreqParamFlag = true;
 
% buildRedModelInterpTransp(modelName, order, linFreqParamFlag);
% fNameSpara = modelEvaluationSqrtK(modelName, impedanceFlag);
% fNameSpara = [modelName 'S_f_1000000000_4500000000_101_MU_RELATIVE_74_1_7_101.txt'];
fNameSpara = [modelName 'S_f_8e+009_1.7e+010_91.txt'];

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
hold;
fNameSpara = 'C:\work\examples\permittivity_measurement\wg_perm_sym_test_ws\sparam.txt';
[fr sMatWaveSolv] = readSparamWaveSolverModyfied(fNameSpara);
s11 = zeros(length(fr),1);
for k = 1:length(fr)
  s11(k) = sMatWaveSolv{k}(1,2);
  s12(k) = sMatWaveSolv{k}(1,1);
end
plot(fr * 1e-9, abs(s11), 'rd', 'LineWidth', linewidth);

% error plot
figure;
semilogy(fr * 1e-9, abs(s11 - sVal1), 'LineWidth', linewidth);
