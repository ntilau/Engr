close all;
clear;

set(0,'DefaultFigureWindowStyle','docked');
fontsize = 20;
linewidth = 1.0;
addpath(genpath('C:\work\Matlab'));


%% Build ROM

order = 8;
modelName = 'C:\work\examples\patch_antenna\patch_antenna_modRed\results\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable8\';
 
impedanceFlag = true;
linFreqParamFlag = false;

buildRedModelInterpTranspEfficient(modelName, order, linFreqParamFlag);
% % buildRedModelTransp(modelName, order, linFreqParamFlag);
% buildRedModelInterpTransp(modelName, order, linFreqParamFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag);
% % fNameSpara = [modelName 'S_f_1000000000_4500000000_101_MU_RELATIVE_74_1_7_101.txt'];
% 
% % [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
% %   = loadSmatrix(fNameSpara);
% 
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
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
% grid;

%% Solve original model

% fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag);
% % fNameSpara = [modelName 'S_f_160000000_240000000_11.txt'];
% 
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% 
% sValFull = zeros(numParameterPnts(1), 1);
% fFull = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   fFull(k) = parameterVals(1, k);
%   sValFull(k) = sMatrices{k}(1, 1);
% end


%% Comparing ROM and original model - eps1 = 5, eps2 = 7

% ROM - no reconstruction
% modelName = 'C:\Ortwin\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable1\';
modelName2 = 'C:\work\examples\patch_antenna\patch_antenna_modRed\results\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable2\';
% modelName2 = 'C:\Ortwin\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable3\';
fNameSpara = [modelName2 'S_f_3000000000_8000000000_501_EPSILON_RELATIVE_Box1_5_5_1_EPSILON_RELATIVE_Box2_7_7_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
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
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
hold;
% ROM - Interpolation using original interpolation points
modelName3 = 'C:\work\examples\patch_antenna\patch_antenna_modRed\results\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable3\';
fNameSpara = [modelName3 'S_f_3000000000_8000000000_501_EPSILON_RELATIVE_Box1_5_5_1_EPSILON_RELATIVE_Box2_7_7_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sVal2long = sVal;
freqs1 = freqs;
plot(freqs1 * 1e-9, abs(sVal2long), 'k', 'LineWidth', linewidth);
% ROM - Interpolation using Lagrange interpolation points
modelNameLag = 'C:\work\examples\patch_antenna\patch_antenna_modRed\results\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable8\';
fNameSpara = [modelNameLag 'S_f_3000000000_8000000000_501_EPSILON_RELATIVE_Box1_5_5_1_EPSILON_RELATIVE_Box2_7_7_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sValLaglong = sVal;
freqs1 = freqs;
plot(freqs1 * 1e-9, abs(sVal2long), 'g', 'LineWidth', linewidth);
% Original model
fNameSpara = [modelName2 'S_f_3000000000_8000000000_201_EPSILON_RELATIVE_Box1_5_5_1_EPSILON_RELATIVE_Box2_7_7_1_full.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sValFull = sVal;
plot(freqs * 1e-9, abs(sValFull), 'rd', 'LineWidth', linewidth);
legend('No reconstruction', 'Reconstruction - Simple', 'Reconstruction - Lagrange', 'Full FE', 'Location', 'South');
set(gca,'FontSize',fontsize);
% print('-dmeta', 'patchAntenna_e1_5_e2_7');

% plot error
% Method 1
fNameSpara = [modelName2 'S_f_3000000000_8000000000_201_EPSILON_RELATIVE_Box1_5_5_1_EPSILON_RELATIVE_Box2_7_7_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sValRomCoarse = sVal;
figHandle = figure;
set(figHandle, 'color', 'w');
semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
grid;
hold;
xlabel('Frequenzy (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
% ROM - Interpolation using original interpolation points
fNameSpara = [modelName3 'S_f_3000000000_8000000000_201_EPSILON_RELATIVE_Box1_5_5_1_EPSILON_RELATIVE_Box2_7_7_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sVal2 = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal2(k) = sMatrices{k}(1, 1);
end
sValRomCoarse2 = sVal2;
semilogy(freqs * 1e-9, abs(sValRomCoarse2 - sValFull), 'k', 'LineWidth', linewidth);
% ROM - Interpolation using Lagrange interpolation points
fNameSpara = [modelNameLag 'S_f_3000000000_8000000000_201_EPSILON_RELATIVE_Box1_5_5_1_EPSILON_RELATIVE_Box2_7_7_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sValLag = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sValLag(k) = sMatrices{k}(1, 1);
end
sValRomCoarseLag = sValLag;
semilogy(freqs * 1e-9, abs(sValRomCoarseLag - sValFull), 'g', 'LineWidth', linewidth);
legend('No reconstruction', 'Reconstruction - Simple', 'Reconstruction - Lagrange', 'Location', 'North');
set(gca,'FontSize',fontsize);
axis([3 8 1e-14 1e-2]);
set(gca, 'YTick', [1e-14 1e-12 1e-10 1e-8 1e-6 1e-4 1e-2]);
% print('-dmeta', 'patchAntenna_e1_5_e2_7_error');

% use subplots
fontsize = 14;
linewidth = 2.5;
% use subplots
figHandle = figure;
set(figHandle, 'color', 'w');
subplot(2, 1, 1);
plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
grid;
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
hold;
plot(freqs1 * 1e-9, abs(sVal2long), '--k', 'LineWidth', linewidth);
plot(freqs1 * 1e-9, abs(sValLaglong), '-.g', 'LineWidth', linewidth);
plot(freqs * 1e-9, abs(sValFull), 'rd', 'LineWidth', linewidth);
legend('No reconstruction', 'Reconstruction - Simple', 'Reconstruction - Lagrange', 'Full FE', 'Location', 'South');
set(gca, 'FontSize', fontsize);
subplot(2, 1, 2);
semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
grid;
hold;
semilogy(freqs * 1e-9, abs(sValRomCoarse2 - sValFull), '--k', 'LineWidth', linewidth);
semilogy(freqs * 1e-9, abs(sValRomCoarseLag - sValFull), '-.g', 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
axis([3 8 1e-13 1e-3]);
set(gca, 'YTick', [1e-13 1e-11 1e-9 1e-7 1e-5 1e-3]);
set(gca, 'FontSize', fontsize);

% for Powerpoint presentation
fontsize = 14;
linewidth = 2.5;
% use subplots
figHandle = figure;
set(figHandle, 'color', 'w');
subplot(2, 1, 1);
plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
grid;
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
hold;
plot(freqs1 * 1e-9, abs(sVal2long), 'k', 'LineWidth', linewidth);
plot(freqs1 * 1e-9, abs(sValLaglong), 'g', 'LineWidth', linewidth);
plot(freqs * 1e-9, abs(sValFull), 'rd', 'LineWidth', linewidth);
legend('No reconstruction', 'Reconstruction - Simple', 'Reconstruction - Lagrange', 'Full FE', 'Location', 'South');
set(gca, 'FontSize', fontsize);
subplot(2, 1, 2);
semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
grid;
hold;
semilogy(freqs * 1e-9, abs(sValRomCoarse2 - sValFull), 'k', 'LineWidth', linewidth);
semilogy(freqs * 1e-9, abs(sValRomCoarseLag - sValFull), 'g', 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
axis([3 8 1e-13 1e-3]);
set(gca, 'YTick', [1e-13 1e-11 1e-9 1e-7 1e-5 1e-3]);
set(gca, 'FontSize', fontsize);
% print('-dmeta', 'patchAntenna_e1_5_e2_5_comp');


%% Comparing ROM and original model - eps1 = 1, eps2 = 3

% ROM - method 1
% modelName = 'C:\Ortwin\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable1\';
modelNameWoRec = 'C:\work\examples\patch_antenna\patch_antenna_modRed\results\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable2\';
fNameSpara = [modelNameWoRec 'S_f_3000000000_8000000000_501_EPSILON_RELATIVE_Box1_1_5_1_EPSILON_RELATIVE_Box2_3_3_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
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
xlabel('Frequenz (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
hold;
% ROM - Interpolation using original interpolation points
modelNameOrig = 'C:\work\examples\patch_antenna\patch_antenna_modRed\results\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable3\';
fNameSpara = [modelNameOrig 'S_f_3000000000_8000000000_501_EPSILON_RELATIVE_Box1_1_5_1_EPSILON_RELATIVE_Box2_3_3_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sVal2long = sVal;
freqs1 = freqs;
plot(freqs1 * 1e-9, abs(sVal2long), 'k', 'LineWidth', linewidth);
% ROM - Interpolation using Lagrange interpolation points
modelNameLag = 'C:\work\examples\patch_antenna\patch_antenna_modRed\results\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable8\';
fNameSpara = [modelNameLag 'S_f_3000000000_8000000000_501_EPSILON_RELATIVE_Box1_1_5_1_EPSILON_RELATIVE_Box2_3_3_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sValLaglong = sVal;
freqs1 = freqs;
plot(freqs1 * 1e-9, abs(sVal2long), 'g', 'LineWidth', linewidth);
% Original model
modelName = 'C:\work\examples\patch_antenna\patch_antenna_modRed\results\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6_stable1\';
fNameSpara = [modelName 'S_f_3000000000_8000000000_51_EPSILON_RELATIVE_Box1_1_5_1_EPSILON_RELATIVE_Box2_3_3_1_full.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sValFull = sVal;
plot(freqs * 1e-9, abs(sValFull), 'rd', 'LineWidth', linewidth);
legend('No reconstruction', 'Reconstruction - Simple', 'Reconstruction - Lagrange', 'Full FE', ...
  'Location', 'SouthWest');

% plot error
% ROM - without reconstruction
fNameSpara = [modelNameWoRec 'S_f_3000000000_8000000000_51_EPSILON_RELATIVE_Box1_1_5_1_EPSILON_RELATIVE_Box2_3_3_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sValRomCoarse = sVal;
figHandle = figure;
set(figHandle, 'color', 'w');
semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
grid;
hold;
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
% ROM - Interpolation using original interpolation points
fNameSpara = [modelNameOrig 'S_f_3000000000_8000000000_51_EPSILON_RELATIVE_Box1_1_5_1_EPSILON_RELATIVE_Box2_3_3_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sVal2 = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal2(k) = sMatrices{k}(1, 1);
end
sValRomCoarseOrig = sVal2;
semilogy(freqs * 1e-9, abs(sValRomCoarseOrig - sValFull), 'k', 'LineWidth', linewidth);
% ROM - Interpolation using Lagrange interpolation points
fNameSpara = [modelNameLag 'S_f_3000000000_8000000000_51_EPSILON_RELATIVE_Box1_1_5_1_EPSILON_RELATIVE_Box2_3_3_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sVal2 = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal2(k) = sMatrices{k}(1, 1);
end
sValRomCoarseLag = sVal2;
semilogy(freqs * 1e-9, abs(sValRomCoarseLag - sValFull), 'g', 'LineWidth', linewidth);
legend('No reconstruction', 'Reconstruction - Simple', 'Reconstruction - Lagrange', 'Location', 'NorthWest');

% use subplots
figHandle = figure;
set(figHandle, 'color', 'w');
subplot(2, 1, 1);
plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
grid;
xlabel('Frequenz (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
hold;
plot(freqs1 * 1e-9, abs(sVal2long), '--k', 'LineWidth', linewidth);
plot(freqs1 * 1e-9, abs(sValLaglong), '-.g', 'LineWidth', linewidth);
plot(freqs * 1e-9, abs(sValFull), 'rd', 'LineWidth', linewidth);
legend('No reconstruction', 'Reconstruction - Simple', 'Reconstruction - Lagrange', 'Full FE', 'Location', 'SouthWest');
subplot(2, 1, 2);
semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
grid;
hold;
semilogy(freqs * 1e-9, abs(sValRomCoarseOrig - sValFull), '--k', 'LineWidth', linewidth);
semilogy(freqs * 1e-9, abs(sValRomCoarseLag - sValFull), '-.g', 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
axis([3 8 1e-13 1e-3]);
set(gca, 'YTick', [1e-13 1e-11 1e-9 1e-7 1e-5 1e-3]);
print('-deps', 'patchAntenna_e1_1_e2_3_comp');

% for Powerpoint presentation
fontsize = 14;
linewidth = 2.5;
% use subplots
figHandle = figure;
set(figHandle, 'color', 'w');
subplot(2, 1, 1);
plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
grid;
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
hold;
plot(freqs1 * 1e-9, abs(sVal2long), 'k', 'LineWidth', linewidth);
plot(freqs1 * 1e-9, abs(sValLaglong), 'g', 'LineWidth', linewidth);
plot(freqs * 1e-9, abs(sValFull), 'rd', 'LineWidth', linewidth);
legend('No reconstruction', 'Reconstruction - Simple', 'Reconstruction - Lagrange', 'Full FE', 'Location', 'SouthWest');
set(gca, 'FontSize', fontsize);
subplot(2, 1, 2);
semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
grid;
hold;
semilogy(freqs * 1e-9, abs(sValRomCoarseOrig - sValFull), 'k', 'LineWidth', linewidth);
semilogy(freqs * 1e-9, abs(sValRomCoarseLag - sValFull), 'g', 'LineWidth', linewidth);

xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
axis([3 8 1e-13 1e-3]);
set(gca, 'YTick', [1e-13 1e-11 1e-9 1e-7 1e-5 1e-3]);
set(gca, 'FontSize', fontsize);
% print('-dmeta', 'patchAntenna_e1_1_e2_3_comp');

