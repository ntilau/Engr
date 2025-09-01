close all;
clear;

set(0,'DefaultFigureWindowStyle','docked');
fontsize = 12;
linewidth = 1.0;


%% Build ROM

order = 10;
modelName = 'C:\Ortwin\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(10,0)_10\';

impedanceFlag = true;
linFreqParamFlag = true;
 
% buildRedModelTransp(modelName, order, linFreqParamFlag);
% buildRedModelInterpTransp(modelName, order, linFreqParamFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag);
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
% figHandle = figure;
% plot(fFull * 1e-9, abs(sValFull));


%% Comparing ROM and original model

% % epsilon = 5
% % ROM 
% fNameSpara = [modelName 'S_f_8000000000_17000000000_901_MU_RELATIVE_sample_5_20_1.txt'];
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
% figHandle = figure;
% set(figHandle, 'color', 'w');
% plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
% grid;
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% hold;
% % Original model
% fNameSpara = [modelName 'S_f_8000000000_17000000000_91_MU_RELATIVE_sample_5_20_1_full.txt'];
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
% legend('Reduziertes Modell', 'Originalmodell', 'Location', 'NorthWest');
% 
% % plot error
% fNameSpara = [modelName 'S_f_8000000000_17000000000_91_MU_RELATIVE_sample_5_20_1.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% sValRomCoarse = sVal;
% figHandle = figure;
% set(figHandle, 'color', 'w');
% semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
% grid;
% hold;
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('|Fehler|', 'FontSize', fontsize);
% 
% % use subplots
% figHandle = figure;
% set(figHandle, 'color', 'w');
% subplot(2, 1, 1);
% plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
% grid;
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% hold;
% plot(freqs * 1e-9, abs(sValFull), 'rd', 'LineWidth', linewidth);
% legend('Reduziertes Modell', 'Originalmodell', 'Location', 'NorthWest');
% subplot(2, 1, 2);
% semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
% grid;
% hold;
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('|Fehler|', 'FontSize', fontsize);
% set(gca, 'YMinorGrid', 'off');
% % axis([3 8 1e-13 1e-3]);
% % set(gca, 'YTick', [1e-13 1e-11 1e-9 1e-7 1e-5 1e-3]);
% print('-deps', 'wgPermSym_eps_5');
% 
% 
% % epsilon = 5 - 5j
% % ROM 
% fNameSpara = [modelName 'S_f_8000000000_17000000000_901_MU_RELATIVE_sample_5-5i_20_1.txt'];
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
% figHandle = figure;
% set(figHandle, 'color', 'w');
% plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
% grid;
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% hold;
% % Original model
% fNameSpara = [modelName 'S_f_8000000000_17000000000_91_MU_RELATIVE_sample_5-5i_20_1_full.txt'];
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
% legend('Reduziertes Modell', 'Originalmodell', 'Location', 'NorthEast');
% 
% % plot error
% fNameSpara = [modelName 'S_f_8000000000_17000000000_91_MU_RELATIVE_sample_5-5i_20_1.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% sVal = zeros(numParameterPnts(1), 1);
% freqs = zeros(numParameterPnts(1), 1);
% for k = 1 : numParameterPnts(1)
%   freqs(k) = parameterVals(1, k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% sValRomCoarse = sVal;
% figHandle = figure;
% set(figHandle, 'color', 'w');
% semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
% grid;
% hold;
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('|Fehler|', 'FontSize', fontsize);
% 
% % use subplots
% figHandle = figure;
% set(figHandle, 'color', 'w');
% subplot(2, 1, 1);
% plot(freqs1 * 1e-9, abs(sVal1), 'LineWidth', linewidth);
% grid;
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% hold;
% plot(freqs * 1e-9, abs(sValFull), 'rd', 'LineWidth', linewidth);
% legend('Reduziertes Modell', 'Originalmodell', 'Location', 'NorthEast');
% subplot(2, 1, 2);
% semilogy(freqs * 1e-9, abs(sValRomCoarse - sValFull), 'LineWidth', linewidth);
% grid;
% hold;
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('|Fehler|', 'FontSize', fontsize);
% set(gca, 'YMinorGrid', 'off');
% % axis([3 8 1e-13 1e-3]);
% % set(gca, 'YTick', [1e-13 1e-11 1e-9 1e-7 1e-5 1e-3]);
% print('-deps', 'wgPermSym_eps_5-5j');


%% 3D plot

% modelName = 'C:\Ortwin\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(10,0)_10\\';
% % fNameSpara = [modelName 'S_f_4000000000_10000000000_101_MU_RELATIVE_3_1_40_101.txt'];
% fNameSpara = [modelName 'S_f_8000000000_17000000000_301_MU_RELATIVE_sample_1_20_301.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%   = loadSmatrix(fNameSpara);
% % two parameter plot
% figHandle = figure;
% set(figHandle, 'color', 'w');
% pos = 1;
% nonOnePos = find(numParameterPnts(2:end) ~= 1) + 1;
% freqs = zeros(numParameterPnts(1),1);
% matVals = zeros(numParameterPnts(2),1);
% sVal = zeros(numParameterPnts(nonOnePos),numParameterPnts(1));
% for fCnt = 1:numParameterPnts(1)
%   for pCnt = 1:numParameterPnts(nonOnePos)
%     freqs(fCnt) = parameterVals(1,pos);
%     matVals(pCnt) = parameterVals(2,pos);
%     sVal(pCnt, fCnt) = sMatrices{pos}(1, 1);
%     pos = pos + 1;
%   end
% end
% pcolor(freqs*1e-9, matVals, abs(sVal));
% % surf(freqs * 1e-9, matVals, abs(sVal), 'FaceColor', 'interp', ...
% %   'EdgeColor', 'none');
% % az = 0.00;
% % el = 90.00;
% % view(az, el);
% xlabel('Frequenz (GHz)', 'FontSize', fontsize);
% ylabel('\epsilon_{r}', 'FontSize', fontsize);
% % zlabel('|S_{11}|', 'FontSize', fontsize);
% % caxis([-0.1 1.1]);
% % %axis([1 4.5 1 7 0 1]);
% set(gca, 'FontSize', fontsize);
% colormap('gray');
% brighten(0.4);
% % print('-deps', '-r450', 'wgPermSym3d');




