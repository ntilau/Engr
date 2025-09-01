close all;
clear all;

set(0,'DefaultFigureWindowStyle','docked');

linewidth = 2.5;
fontsize = 14;

%% New Frequency Sweep

Path = 'C:\work\examples\SMA_Accurate\';
figHandle = figure;
set(figHandle,'color','w');

% model with one TFE Port, Radiation BCs and PECs and Loss Less
fNameWsolver = ...
  [Path 'sParamLossLess.txt'];
[fr sMatWaveSolv] = readSparamWaveSolverCell(fNameWsolver);
s11 = zeros(length(fr),1);
for k = 1:length(fr)
  s11(k) = sMatWaveSolv{k}(1,1);
end
plot(fr*1e-9, 20*log10(abs(s11)), 'rd', 'LineWidth', linewidth);
hold;
grid;

fNameSpara = ...
  'C:\work\examples\SMA_AccurateModRed\SMA_Accurate_3e+009_9\S_f_1000000000_20000000000_191.txt';

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
% one parameter plot
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)), 'b', 'LineWidth', linewidth);

fNameSpara = ...
  'C:\work\examples\SMA_AccurateModRed\SMA_Accurate_3e+009_9\S_f_1000000000_20000000000_291.txt';

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
% one parameter plot
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)), 'm', 'LineWidth', linewidth);


modelName = ...
'C:\work\examples\SMA_Accurate\SMA_Accurate_1e+010_20\';
% fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 'S_f_1e+009_2e+010_191.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sValO5)), 'k-', 'LineWidth', linewidth);


% modelName = ...
% 'C:\work\examples\SMA_Accurate\SMA_Accurate_1e+010_EPSILON_RELATIVE_dielec_01_02_(3.8,0)_EPSILON_RELATIVE_dielec_05_06_(3.8,0)_5\';
% % fNameSpara = modelEvaluationGeneral(modelName);
% fNameSpara = [modelName 'S_f_1e+009_2e+010_191_EPSILON_RELATIVE_dielec_01_02_(3.8,0)_(8,0)_1_EPSILON_RELATIVE_dielec_05_06_(3.8,0)_(8,0)_1.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%     = loadSmatrix(fNameSpara);
% % plot results
% sValO5 = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sValO5(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, 20*log10(abs(sValO5)), 'b-', 'LineWidth', linewidth);

% modelName = ...
% 'C:\work\examples\SMA_AccurateModRed\SMA_Accurate_1e+010_100\';
% % fNameSpara = modelEvaluationGeneral(modelName);
% fNameSpara = [modelName 'S_f_1e+009_2e+010_191.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%     = loadSmatrix(fNameSpara);
% % plot results
% sValO5 = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sValO5(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, 20*log10(abs(sValO5)), 'b-', 'LineWidth', linewidth);

legend('WaveSolver', 'WCAWE: order 30', 'WCAWE: order 50', ...
  'Old approach', ...
  'Location', 'SouthEast');

% modelName = ...
% 'C:\work\examples\SMA_Accurate\SMA_Accurate_1e+010_30\';
% % fNameSpara = modelEvaluationGeneral(modelName);
% fNameSpara = [modelName 'S_f_1e+009_2e+010_191.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%     = loadSmatrix(fNameSpara);
% % plot results
% sValO5 = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sValO5(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, 20*log10(abs(sValO5)), 'k-', 'LineWidth', linewidth);
% 
% modelName = ...
% 'C:\work\examples\SMA_Accurate\SMA_Accurate_1e+010_100\';
% % fNameSpara = modelEvaluationGeneral(modelName);
% fNameSpara = [modelName 'S_f_1e+009_2e+010_191.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%     = loadSmatrix(fNameSpara);
% % plot results
% sValO5 = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sValO5(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, 20*log10(abs(sValO5)), 'y-', 'LineWidth', linewidth);


