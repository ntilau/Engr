close all;
clear;

addpath(genpath('C:\work\Matlab'));
set(0,'DefaultFigureWindowStyle','docked');
% fontsize = 14;
% linewidth = 2.5;
fontsize = 12;
linewidth = 1.0;


%% Build ROM

% order = 15;
% modelName = 'C:\Ortwin\langer_dual_coarse_7e+009_MU_RELATIVE_3_(38,0)_15_old\';
% 
% impedanceFlag = true;
% linFreqParamFlag = true;
%  
% buildRedModelTransp(modelName, order, linFreqParamFlag);
% buildRedModelInterpTransp(modelName, order, linFreqParamFlag);
% fNameSpara = modelEvaluation(modelName, impedanceFlag);
% fNameSpara = [modelName 'S_f_1000000000_4500000000_101_MU_RELATIVE_74_1_7_101.txt'];

% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);

% % one parameter plot
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% sVal1 = sVal;
% freqs1 = freqs;
% figHandle = figure;
% set(figHandle, 'color', 'w');
% plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
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


%% Comparing ROM and original model

% % ROM old
% modelNameOld = 'C:\Ortwin\langer_dual_coarse_7e+009_MU_RELATIVE_3_(38,0)_15_old\';
% fNameSpara = [modelNameOld 'S_f_4000000000_10000000000_301_MU_RELATIVE_3_5_40_1.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% sValOld = sVal;
% freqsOld = freqs;
% figHandle = figure;
% set(figHandle, 'color', 'w');
% plot(freqsOld * 1e-9, abs(sValOld), 'LineWidth', linewidth);
% grid;
% % xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% hold;
% % ROM new
% modelName = 'C:\Ortwin\langer_dual_coarse_7e+009_MU_RELATIVE_3_(38,0)_15\';
% fNameSpara = [modelName 'S_f_4000000000_10000000000_301_MU_RELATIVE_3_5_40_1_imp.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% sVal1 = sVal;
% freqs1 = freqs;
% % figHandle = figure;
% % set(figHandle, 'color', 'w');
% % plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
% plot(freqs1 * 1e-9, abs(sVal1), 'g', 'LineWidth', linewidth);
% % grid;
% % xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% % ylabel('|S_{11}|', 'FontSize', fontsize);
% % hold;
% % Original model
% fNameSpara = [modelName 'S_f_4000000000_10000000000_101_MU_RELATIVE_3_5_40_1_full.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% sValFull = sVal;
% plot(freqs * 1e-9, abs(sValFull), 'rd', 'LineWidth', linewidth);
% % legend('Redzuiertes Modell', 'Originalmodell', 'Location', 'SouthWest');
% legend('Old approach', 'New approach', 'Full FE', 'FonsSize', fontsize, ...
%   'Location', 'SouthWest');
% set(gca, 'FontSize', fontsize);
% print('-dmeta', 'langer_eps_5');
% 
% % plot error
% % ROM old
% fNameSpara = [modelNameOld 'S_f_4000000000_10000000000_101_MU_RELATIVE_3_5_40_1.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% sValRomOldCoarse = sVal;
% figHandle = figure;
% set(figHandle, 'color', 'w');
% semilogy(freqs * 1e-9, abs(sValRomOldCoarse - sValFull), 'LineWidth', linewidth);
% grid;
% hold;
% % xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% % ylabel('|Fehler|', 'FontSize', fontsize);
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('|Error|', 'FontSize', fontsize);
% % ROM new
% fNameSpara = [modelName 'S_f_4000000000_10000000000_101_MU_RELATIVE_3_5_40_1.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% sValRomCoarse = sVal;
% % figHandle = figure;
% % set(figHandle, 'color', 'w');
% % semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
% semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'g', ...
%   'LineWidth', linewidth);
% set(gca, 'YMinorGrid', 'off');
% set(gca, 'YMinorTick', 'off');
% axis([4 10 1e-10 1e-4]);
% set(gca, 'YTick', [1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4]);
% legend('Old approach', 'New approach', 'Full FE', 'FonsSize', fontsize, ...
%   'Location', 'NorthWest');
% % grid;
% % hold;
% % xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% % ylabel('|Fehler|', 'FontSize', fontsize);
% set(gca, 'FontSize', fontsize);
% print('-dmeta', 'langer_eps_5_error');
% 
% % use subplots
% figHandle = figure;
% set(figHandle, 'color', 'w');
% subplot(2, 1, 1);
% plot(freqs1 * 1e-9, abs(sValOld), '--', 'LineWidth', linewidth);
% hold;
% plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
% grid;
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% plot(freqs * 1e-9, abs(sValFull), 'd', 'LineWidth', linewidth);
% % legend('Reduziertes Modell', 'Originalmodell', 'Location', 'SouthWest');
% legend('Algorithmus 8.1', 'Algorithmus 8.2', 'Originalmodell', ...
%   'Location', 'SouthWest');
% set(gca, 'YTick', [0 0.2 0.4 0.6 0.8 1.0]);
% subplot(2, 1, 2);
% semilogy(freqs * 1e-9, abs(sValRomOldCoarse - sValFull), '--', ...
%   'LineWidth', linewidth);
% grid;
% hold;
% semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('|Fehler|', 'FontSize', fontsize);
% set(gca, 'YMinorGrid', 'off');
% % axis([4 10 1e-10 1e-3]);
% % set(gca, 'YTick', [1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3]);
% axis([4 10 1e-10 1e-4]);
% set(gca, 'YTick', [1e-10 1e-8 1e-6 1e-4]);
% print('-deps', 'langer_eps_5');
% % print('-dmeta', 'langer_eps_5');



%% 3D plot

modelName = 'C:\Ortwin\langer_dual_coarse_7e+009_MU_RELATIVE_3_(38,0)_15\';
% fNameSpara = [modelName 'S_f_4000000000_10000000000_101_MU_RELATIVE_3_1_40_101.txt'];
fNameSpara = [modelName 'S_f_4000000000_10000000000_301_MU_RELATIVE_3_1_40_301.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
% two parameter plot
figHandle = figure;
set(figHandle, 'color', 'w');
pos = 1;
nonOnePos = find(numParameterPnts(2:end) ~= 1) + 1;
freqs = zeros(numParameterPnts(1),1);
matVals = zeros(numParameterPnts(2),1);
sVal = zeros(numParameterPnts(nonOnePos),numParameterPnts(1));
for fCnt = 1:numParameterPnts(1)
  for pCnt = 1:numParameterPnts(nonOnePos)
    freqs(fCnt) = parameterVals(1,pos);
    matVals(pCnt) = parameterVals(2,pos);
    sVal(pCnt, fCnt) = sMatrices{pos}(1, 1);
    pos = pos + 1;
  end
end
surf(freqs * 1e-9, matVals, abs(sVal), 'FaceColor', 'interp');
az = -9.00;
el = 74.00;
view(az, el);
xlabel('Frequenz (GHz)', 'FontSize', fontsize);
ylabel('\epsilon_{r}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
% %axis([1 4.5 1 7 0 1]);
set(gca, 'FontSize', fontsize);
colormap('gray');
% brighten(0.4);
print('-deps', '-r450', 'langer3d_450');




