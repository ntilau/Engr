close all;
clear;

set(0,'DefaultFigureWindowStyle','docked');

order = 10;
fontsize = 12;
linewidth = 1.5;
modelName = 'C:\Ortwin\wg51s\wg51s_8e+009_10\';

impedanceFlag = true;
linFreqParamFlag = true;

% buildRedModelInterpolation(modelName, order, linFreqParamFlag);
% buildRedModelInterpTransp(modelName, order, linFreqParamFlag);
% fNameSpara = modelEvaluation(modelName, impedanceFlag);
% fNameSpara = [modelName 'S_f_1000000000_4500000000_1001_MU_RELATIVE_74_1_7_1.txt'];


%% plot results

fNameSpara = [modelName 'S_f_2000000000_14000000000_241.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);

sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 5);
end
sVal1 = sVal;

sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(2, 6);
end
sVal2 = sVal;

sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(3, 7);
end
sVal3 = sVal;

sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(4, 8);
end
sVal4 = sVal;

figHandle = figure;
set(figHandle, 'color', 'w');
subplot(2,1,1);
plot(freqs * 1e-9, db(abs(sVal1)), 'LineWidth', linewidth);
hold;
plot(freqs * 1e-9, db(abs(sVal2)), ':', 'LineWidth', linewidth);
plot(freqs * 1e-9, db(abs(sVal3)), '-.', 'LineWidth', linewidth);
plot(freqs * 1e-9, db(abs(sVal4)), '--', 'LineWidth', linewidth);
xlabel('Frequenz (GHz)');
ylabel('|Transmissionsfaktor| (dB)');
legend('TE_{10}', 'TE_{20}', 'TE_{30}', 'TE_{40}', 'Location', 'SouthEast') ;
axis([2 14 -140 20]);
grid;


%% analytical solution

width = 0.05;
height = 0.01;
length = 0.06;

c0 = 299792.458e3;
waveNumber = 2 * pi * freqs / c0;
gamma10 = sqrt((1 * pi / width)^2 - waveNumber .^ 2);
gamma20 = sqrt((2 * pi / width)^2 - waveNumber .^ 2);
gamma30 = sqrt((3 * pi / width)^2 - waveNumber .^ 2);
gamma40 = sqrt((4 * pi / width)^2 - waveNumber .^ 2);
sVal1analyt = exp(-gamma10 * length);
sVal2analyt = exp(-gamma20 * length);
sVal3analyt = exp(-gamma30 * length);
sVal4analyt = exp(-gamma40 * length);
subplot(2,1,2);
semilogy(freqs * 1e-9, abs(sVal1analyt - sVal1));
xlabel('Frequenz (GHz)');
ylabel('|Fehler|');
hold;
semilogy(freqs * 1e-9, abs(sVal2analyt - sVal2), ':', 'LineWidth', linewidth);
semilogy(freqs * 1e-9, abs(sVal3analyt + sVal3), '-.', 'LineWidth', linewidth);
semilogy(freqs * 1e-9, abs(sVal4analyt + sVal4), '--', 'LineWidth', linewidth);
grid;
axis([2 14 1e-12 1e-3]);
set(gca, 'YTick', [1e-12 1e-9 1e-6 1e-3]);
print('-deps', 'wg51_ROM_Analyt');


%% Solve original model

% fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag);


%% Compare reduced model with original model

% % load results of reduced order model
% fNameSpara = [modelName 'S_f_2000000000_14000000000_241.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 5);
% end
% fresRom = freqs;
% sVal1 = sVal;
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(2, 6);
% end
% sVal2 = sVal;
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(3, 7);
% end
% sVal3 = sVal;
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(4, 8);
% end
% sVal4 = sVal;
% 
% % load results of original model
% fNameSpara = [modelName 'S_f_2000000000_14000000000_61_full.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 5);
% end
% sVal1full = sVal;
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(2, 6);
% end
% sVal2full = sVal;
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(3, 7);
% end
% sVal3full = sVal;
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(4, 8);
% end
% sVal4full = sVal;
% 
% figHandle = figure;
% set(figHandle, 'color', 'w');
% % subplot(2,1,1);
% plot(fresRom * 1e-9, db(abs(sVal1)), 'LineWidth', linewidth);
% hold;
% plot(fresRom * 1e-9, db(abs(sVal2)), ':', 'LineWidth', linewidth);
% plot(fresRom * 1e-9, db(abs(sVal3)), '-.', 'LineWidth', linewidth);
% plot(fresRom * 1e-9, db(abs(sVal4)), '--', 'LineWidth', linewidth);
% plot(freqs * 1e-9, db(abs(sVal1full)), 'o', 'LineWidth', linewidth);
% plot(freqs * 1e-9, db(abs(sVal2full)), 's', 'LineWidth', linewidth);
% plot(freqs * 1e-9, db(abs(sVal3full)), '+', 'LineWidth', linewidth);
% plot(freqs * 1e-9, db(abs(sVal4full)), 'd', 'LineWidth', linewidth);
% xlabel('Frequenz (GHz)');
% ylabel('|Transmissionsfaktor| (dB)');
% legend('TE_{10} red. Modell', 'TE_{20} red. Modell', 'TE_{30} red. Modell', ...
%   'TE_{40} red. Modell', 'TE_{10} Originalmodell', 'TE_{20} Originalmodell', ...
%   'TE_{30} Originalmodell', 'TE_{40} Originalmodell', 'Location', 'SouthEast') ;
% % axis([2 14 -150 0]);
% grid;
% axis([2 14 -140 20]);
% print('-deps', 'wg51_ROM_Full');
% 
% 
% % eror plot
% figHandle = figure;
% set(figHandle, 'color', 'w');
% fNameSpara = [modelName 'S_f_2000000000_14000000000_61.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 5);
% end
% sVal1short = sVal;
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(2, 6);
% end
% sVal2short = sVal;
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(3, 7);
% end
% sVal3short = sVal;
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(4, 8);
% end
% sVal4short = sVal;
% 
% % subplot(2,1,2);
% semilogy(freqs * 1e-9, abs(sVal1full - sVal1short), 'LineWidth', linewidth);
% xlabel('Frequenz (GHz)');
% ylabel('|Fehler|');
% hold;
% semilogy(freqs * 1e-9, abs(sVal2full - sVal2short), ':', 'LineWidth', linewidth);
% semilogy(freqs * 1e-9, abs(sVal3full - sVal3short), '-.', 'LineWidth', linewidth);
% semilogy(freqs * 1e-9, abs(sVal4full - sVal4short), '--', 'LineWidth', linewidth);
% grid;
% set(gca, 'YMinorGrid', 'off');
% % axis([2 14 1e-12 1e-2]);
% print('-deps', 'wg51_ROM_Full_error');
