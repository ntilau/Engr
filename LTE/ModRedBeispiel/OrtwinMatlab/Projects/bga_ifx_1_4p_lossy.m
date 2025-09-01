close all;
clear all;

linewidth = 2.5;
fontsize = 14;

%% New Frequency Sweep

infinionPath = 'C:\work\examples\Quimonda\';
figHandle = figure;
set(figHandle,'color','w');

% model with all features
hfssResultsFileName = [infinionPath 'bga_ifx_1_4p_lossy_res.m'];
[freqs sMatHFSS] = readHFSSresults(hfssResultsFileName);
s11 = zeros(length(freqs),1);
for k = 1:length(freqs)
  s11(k) = sMatHFSS{k}(1,1);
end
plot(freqs*1e-9, 20*log10(abs(s11)), 'rd-', 'LineWidth', linewidth);
hold;
grid;

% model with with PEC and frequency independent materials
hfssResultsFileName = [infinionPath 'bga_ifx_1_4p_lossy_pecReal_constMaterials.m'];
[freqs sMatHFSS] = readHFSSresults(hfssResultsFileName);
s11 = zeros(length(freqs),1);
for k = 1:length(freqs)
  s11(k) = sMatHFSS{k}(1,1);
end
plot(freqs*1e-9, 20*log10(abs(s11)), 'kx-', 'LineWidth', linewidth);

% discrete sweep with EM_WaveSolver
fNameWsolver = ...
  'C:\work\examples\Infinion\sParam_newMaterials.txt';
[fr sMatWaveSolv] = readSparamWaveSolverCell(fNameWsolver);
s11 = zeros(length(fr),1);
for k = 1:length(fr)
  s11(k) = sMatWaveSolv{k}(1,1);
end
plot(fr*1e-9, 20*log10(abs(s11)), 'go-', 'LineWidth', linewidth);

set(gca,'FontSize',fontsize);
legend('HFSS: original', 'HFSS: PEC + const materials', ...
  'LTE: PEC + const materials', 'Location', 'NorthWest');
xlabel('Frequency (GHz)');
ylabel('|S_{11}| (dB)');
print -depsc comparisonDiscrete

% with ROM
modelName = ...
'C:\work\examples\Infinion\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5\';
% fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 's_11_f_500000000_5000000000_1001_EPSILON_RELATIVE_bta_4.82-0.062173i_8_1_EPSILON_RELATIVE_mca_4-0.028i_8_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sValO5)), 'b', 'LineWidth', linewidth);
legend('HFSS: original', 'HFSS: PEC + const materials', ...
  'LTE: PEC + const materials', 'ROM order 5', ...
  'Location', 'NorthWest');
print -depsc comparisonDiscreteWithROM


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Higher order %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figHandle = figure;
set(figHandle,'color','w');

% discrete sweep with EM_WaveSolver
fNameWsolver = ...
  'C:\work\examples\Infinion\sParamResonanceNewMaterials.txt';
[fr sMatWaveSolv] = readSparamWaveSolverCell(fNameWsolver);
s11 = zeros(length(fr),1);
for k = 1:length(fr)
  s11(k) = sMatWaveSolv{k}(1,1);
end
plot(fr*1e-9, 20*log10(abs(s11)), 'go-', 'LineWidth', linewidth);

hold;
grid;

fNameWsolver = ...
  'C:\work\examples\Infinion\s11_order3.txt';
[fr sMatWaveSolv] = readSparamWaveSolverCell(fNameWsolver);
s11 = zeros(length(fr),1);
for k = 1:length(fr)
  s11(k) = sMatWaveSolv{k}(1,1);
end
plot(fr*1e-9, 20*log10(abs(s11)), 'rd-', 'LineWidth', linewidth);

set(gca,'FontSize',fontsize);
legend('LTE: order 1', 'LTE: order 3', 'Location', 'NorthWest');
xlabel('Frequency (GHz)');
ylabel('|S_{11}| (dB)');
axis([4.3 4.7 -12.5 -8.5]);
print -depsc higherOrder

% %% HFSS results
% infinionPath = 'C:\work\examples\Infinion\';
% 
% figHandle = figure;
% set(figHandle,'color','w');
% 
% % model with all features
% hfssResultsFileName = [infinionPath 'bga_ifx_1_4p_lossy_res.m'];
% [freqs sMatHFSS] = readHFSSresults(hfssResultsFileName);
% s11 = zeros(length(freqs),1);
% for k = 1:length(freqs)
%   s11(k) = sMatHFSS{k}(1,1);
% end
% plot(freqs*1e-9, 20*log10(abs(s11)), 'rd', 'LineWidth', linewidth);
% hold;
% grid;
% 
% % % model with with PEC but frequency dependent materials
% % hfssResultsFileName = [infinionPath 'bga_ifx_1_4p_lossy_pec.m'];
% % [freqs sMatHFSS] = readHFSSresults(hfssResultsFileName);
% % s11 = zeros(length(freqs),1);
% % for k = 1:length(freqs)
% %   s11(k) = sMatHFSS{k}(1,1);
% % end
% % plot(freqs*1e-9, 20*log10(abs(s11)), 'bo', 'LineWidth', linewidth);
% 
% % model with with PEC and frequency independent materials
% hfssResultsFileName = [infinionPath 'bga_ifx_1_4p_lossy_freqIndepMat_res.m'];
% [freqs sMatHFSS] = readHFSSresults(hfssResultsFileName);
% s11 = zeros(length(freqs),1);
% for k = 1:length(freqs)
%   s11(k) = sMatHFSS{k}(1,1);
% end
% plot(freqs*1e-9, 20*log10(abs(s11)), 'kx', 'LineWidth', linewidth);
% 
% % discrete sweep with EM_WaveSolver
% fNameWsolver = ...
%   'C:\work\examples\Infinion\sParam_freqIndepMat.txt';
% [fr sMatWaveSolv] = readSparamWaveSolverCell(fNameWsolver);
% s11 = zeros(length(fr),1);
% for k = 1:length(fr)
%   s11(k) = sMatWaveSolv{k}(1,1);
% end
% plot(fr*1e-9, 20*log10(abs(s11)), 'co', 'LineWidth', linewidth);
% 
% 
% %% Model order reduction
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % One parameter model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% order = 10;
% modelName = ...
% 'C:\work\examples\Infinion\bga_ifx_1_4p_lossy_freqIndepMat\bga_ifx_1_4p_lossy_4e+009_10\';
% % fNameSpara = modelEvaluationGeneral(modelName);
% fNameSpara = [modelName 's_11_f_500000000_5000000000_1001.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%     = loadSmatrix(fNameSpara);
% % plot results
% sVal = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, 20*log10(abs(sVal)), 'b', 'LineWidth', linewidth);
% 
% set(gca,'FontSize',fontsize);
% legend('original', 'pec+lossless', 'LTE pec+lossless', ...
%   'One parameter model: order 10', 'Location', 'SouthWest');
% xlabel('Frequency (GHz)');
% ylabel('S_{11} (dB)');
% 
% modelName = ...
% 'C:\work\examples\Infinion\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5\';
% fNameSpara = [modelName 's_11_f_1000000_5000000000_1001_EPSILON_RELATIVE_bta_4.9-0.04655i_8_1_EPSILON_RELATIVE_mca_4-0.028i_8_1.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%     = loadSmatrix(fNameSpara);
% % plot results
% sVal = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, 20*log10(abs(sVal)), 'k', 'LineWidth', linewidth);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Low frequency behavior %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figHandle = figure;
set(figHandle,'color','w');
modelName = ...
'C:\work\examples\Infinion\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5\';
fNameSpara = [modelName 'LowFrequency_f_10_5000000000_1_EPSILON_RELATIVE_bta_4.82-0.062173i_8_1_EPSILON_RELATIVE_mca_4-0.028i_8_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
semilogx(freqs, 20*log10(abs(sVal)), 'bx-', 'LineWidth', linewidth);
hold;
grid;

% discrete sweep with EM_WaveSolver
fNameWsolver = ...
  'C:\work\examples\Infinion\sParamLowFrequency.txt';
[fr sMatWaveSolv] = readSparamWaveSolverCell(fNameWsolver);
s11 = zeros(length(fr),1);
for k = 1:length(fr)
  s11(k) = sMatWaveSolv{k}(1,1);
end
semilogx(fr, 20*log10(abs(s11)), 'go-', 'LineWidth', linewidth);

% HFSS results
hfssResultsFileName = [infinionPath 'bga_ifx_1_4p_lossy_pecReal_constMaterials_lowFrequency.m'];
[freqs sMatHFSS] = readHFSSresults(hfssResultsFileName);
s11 = zeros(length(freqs),1);
for k = 1:length(freqs)
  s11(k) = sMatHFSS{k}(1,1);
end
semilogx(freqs, 20*log10(abs(s11)), 'rd-', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize);
xlabel('Frequency (Hz)');
ylabel('|S_{11}| (dB)');
legend('ROM order 7', 'LTE discrete Sweep', ...
  'HFSS discrete sweep');
print -depsc lowFrequencyBehavior

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Three parameter model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figHandle = figure;
set(figHandle,'color','w');

modelName = ...
'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_7\';
% fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 's_11_f_500000000_5000000000_451_EPSILON_RELATIVE_bta_1_8_1_EPSILON_RELATIVE_mca_1_8_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)), 'b', 'LineWidth', linewidth);
hold;
grid;

modelName = ...
'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5\';
% fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 's_11_f_500000000_5000000000_451_EPSILON_RELATIVE_bta_1_8_1_EPSILON_RELATIVE_mca_1_8_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sValO5)), 'g', 'LineWidth', linewidth);
  
fNameWsolver = ...
  'C:\work\examples\Qimonda\sParam_eps1_eps1.txt';

[fr sMatWaveSolv] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatWaveSolv(1,1,:), [length(fr) 1]);
%semilogy(fr*1e-9, abs(s11vector),'dr');
plot(fr*1e-9, 20*log10(abs(s11vector)), 'dr', 'LineWidth', linewidth);

set(gca,'FontSize',fontsize);
legend('ROM order 7', 'ROM order 5', 'Discrete sweep', ...
  'Location', 'NorthWest');
xlabel('Frequency (GHz)');
ylabel('|S_{11}| (dB)');
title('\epsilon_{r1}=1, \epsilon_{r2}=1');
print -depsc eps1_eps1

% plot error
figHandle = figure;
set(figHandle,'color','w');
pos = zeros(1,length(s11vector));
for k = 1:length(s11vector)
  pos(k) = find(parameterVals(1,:) == fr(k));
end
semilogy(fr*1e-9, abs(s11vector - sVal(pos)), 'LineWidth', linewidth);
hold;
semilogy(fr*1e-9, abs(s11vector - sValO5(pos)), 'g', ...
  'LineWidth', linewidth);
grid;
set(gca,'FontSize',fontsize);
xlabel('Frequency (GHz)');
ylabel('|Error|');
legend('Order7', 'Order 5');
title('\epsilon_{r1}=1, \epsilon_{r2}=1');
print -depsc error_eps1_eps1

% plot results eps1=8 ep2=8
% model order 7
modelName = ...
'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_7\';
%fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 's_11_f_500000000_5000000000_451_EPSILON_RELATIVE_bta_8_8_1_EPSILON_RELATIVE_mca_8_8_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
figHandle = figure;
set(figHandle,'color','w');
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)), 'LineWidth', linewidth);
grid;
hold;

% model order 5
modelName = ...
'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5\';
%fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 's_11_f_500000000_5000000000_451_EPSILON_RELATIVE_bta_8_8_1_EPSILON_RELATIVE_mca_8_8_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sValO5)), 'g', 'LineWidth', linewidth);

fNameWsolver = ...
  'C:\work\examples\Qimonda\sParam_eps8_eps8.txt';

[fr sMatWaveSolv] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatWaveSolv(1,1,:), [length(fr) 1]);
plot(fr*1e-9, 20*log10(abs(s11vector)), 'dr', 'LineWidth', linewidth);

legend('ROM order 7', 'ROM order 5', 'Discrete Sweep', ...
  'FontSize', fontsize, 'Location', 'SouthWest');
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize);
title('\epsilon_{r1}=8, \epsilon_{r2}=8', ...
  'FontSize', fontsize+4);
set(gca,'FontSize',fontsize);
print -depsc eps8_eps8

% plot error
figHandle = figure;
set(figHandle,'color','w');
pos = zeros(1,length(s11vector));
for k = 1:length(s11vector)
  pos(k) = find(parameterVals(1,:) == fr(k));
end
semilogy(fr*1e-9, abs(s11vector - sVal(pos)), ...
  'LineWidth', linewidth);
hold;
semilogy(fr*1e-9, abs(s11vector - sValO5(pos)), 'g', ...
  'LineWidth', linewidth);
grid;
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
title('\epsilon_{r1}=8, \epsilon_{r2}=8', ...
  'FontSize', fontsize+4);
legend('Order7', 'Order 5', 'FontSize', fontsize, ...
  'Location', 'NorthWest');
set(gca,'FontSize',fontsize);
print -depsc error_eps8_eps8

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extreme losses %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot results eps1=(6,-6) ep2=(6,-6)
% model order 7
modelName = ...
'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_7\';
% fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 's_11_f_500000000_5000000000_451_EPSILON_RELATIVE_bta_6-6i_6-6i_1_EPSILON_RELATIVE_mca_6-6i_6-6i_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);

% plot results
figHandle = figure;
set(figHandle,'color','w');
% plot results
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)), 'LineWidth', linewidth);
grid;
hold;

% model order 5
modelName = ...
'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5\';
%fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 's_11_f_500000000_5000000000_451_EPSILON_RELATIVE_bta_6-6i_6-6i_1_EPSILON_RELATIVE_mca_6-6i_6-6i_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);

% plot results
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sValO5)), 'g', 'LineWidth', linewidth);

fNameWsolver = ...
  'C:\work\examples\Qimonda\sParam_bt(6-6)_eme(6-6).txt';

[fr sMatWaveSolv] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatWaveSolv(1,1,:), [length(fr) 1]);
%semilogy(fr*1e-9, abs(s11vector),'dr');
plot(fr*1e-9, 20*log10(abs(s11vector)), 'dr', 'LineWidth', linewidth);

legend('ROM order 7', 'ROM order 5', 'Discrete Sweep', ...
  'FontSize', fontsize, 'Location', 'SouthEast');
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize);
title('\epsilon_{r1}=6-6j, \epsilon_{r2}=6-6j', ...
  'FontSize', fontsize+4);
set(gca,'FontSize',fontsize);
print -depsc eps6-6j_eps6-6j

% plot error
figHandle = figure;
set(figHandle,'color','w');
pos = zeros(1,length(s11vector));
for k = 1:length(s11vector)
  pos(k) = find(parameterVals(1,:) == fr(k));
end
semilogy(fr*1e-9, abs(s11vector - sVal(pos)), 'LineWidth', linewidth);
hold;
semilogy(fr*1e-9, abs(s11vector - sValO5(pos)), 'g', ...
  'LineWidth', linewidth);
grid;
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
title('\epsilon_{r1}=6-6j, \epsilon_{r2}=6-6j', ...
  'FontSize', fontsize+4);
legend('Order7', 'Order 5', 'FontSize', fontsize, ...
  'Location', 'NorthWest');
set(gca,'FontSize',fontsize);
print -depsc error_eps6-6j_eps6-6j


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Response surface %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
modelName = ...
  'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5\';
%fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 's_11_f_1000000_5000000000_251_EPSILON_RELATIVE_bta_1_8_251_EPSILON_RELATIVE_mca_8_8_1.txt'];
tic;
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
toc;
% plot results
figHandle = figure;
set(figHandle,'color','w');
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
surf(freqs*1e-9, matVals, abs(sVal));
AZ = -1.4250e+002;
EL = 40;
view(AZ, EL);
xlabel('Frequency (GHz)', 'FontSize', fontsize+8);
ylabel('\epsilon_{r1}', 'FontSize', fontsize+8);
zlabel('|S_{11}|', 'FontSize', fontsize+8);
%title('\epsilon_{r2} = 8', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);
title('', 'FontSize', fontsize);







