close all;
clear all;

modelNameM = ...
'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5_Ident\';

modelNameC = ...
'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5_Ident\';



% modelName = ...
% 'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_12\';
modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_EPSILON_RELATIVE_2_(1,0)_13\';
modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_EPSILON_RELATIVE_2_(1,0)_9_MatLab\';
modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_EPSILON_RELATIVE_2_(1,0)_EPSILON_RELATIVE_3_(4,0)_3_ML\';
modelName = ...
'C:\work\examples\bga_ifx_1_4p_lossy_freqIndepMat\bga_ifx_1_4p_lossy_4e+009_3_ML\';
buildRedModelIdent_ModScal(modelName, 3);
fNameSpara = modelEvaluationIdent(modelName);
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%     = loadSmatrix(fNameSpara);
% % plot results
% sValO5 = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sValO5(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, 20*log10(abs(sValO5)));
% 
% hold;
% grid;

s1 = readMatFull('C:\work\examples\bga_ifx_1_4p_lossy_freqIndepMat\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_3_C++\sysMatRed_0_0_1');
s2 = readMatFull('C:\work\examples\bga_ifx_1_4p_lossy_freqIndepMat\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_3_ML\sysMatRed_0_0_1');
s1-s2
(s1-s2)./s1

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quimonda Example %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

order = 6;
linewidth = 2.5;
fontsize = 14;

figHandle = figure;
set(figHandle,'color','w');

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

hold;
grid;

% modelName = ...
% 'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5\';
% fNameSpara = modelEvaluationGeneral(modelName);
% fNameSpara = [modelName 's_11_f_500000000_5000000000_451_EPSILON_RELATIVE_bta_1_8_1_EPSILON_RELATIVE_mca_1_8_1.txt'];
modelName = ...
'C:\work\examples\bga_ifx_1_4p_lossy_freqIndepMat\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_3\';
fNameSpara = [modelName 'S_f_5e+008_5e+009_451_EPSILON_RELATIVE_bta_(1,0)_(8,0)_1_EPSILON_RELATIVE_mca_(1,0)_(8,0)_1_mod.txt'];
fNameSpara = modelEvaluationIdent(modelName);
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sValO5)), 'r', 'LineWidth', linewidth);

modelName = ...
'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5_Ident\';
% fNameSpara = modelEvaluationIdent(modelName);
fNameSpara = [modelName 's_11_f_500000000_5000000000_451_EPSILON_RELATIVE_bta_1_8_1_EPSILON_RELATIVE_mca_1_8_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5I = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5I(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sValO5I)), 'k', 'LineWidth', linewidth);

modelName = ...
'C:\work\examples\Qimonda\bga_ifx_1_4p_lossy_4e+009_EPSILON_RELATIVE_bta_(4.9,0)_EPSILON_RELATIVE_mca_(4,0)_5_Ident_C++\';
% fNameSpara = modelEvaluationIdent(modelName);
fNameSpara = [modelName 'S_f_5e+008_5e+009_451_EPSILON_RELATIVE_bta_(1,0)_(8,0)_1_EPSILON_RELATIVE_mca_(1,0)_(8,0)_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5I_C = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5I_C(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sValO5I_C)), 'c', 'LineWidth', linewidth);

fNameWsolver = ...
  'C:\work\examples\Qimonda\sParam_eps1_eps1.txt';

[fr sMatWaveSolv] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatWaveSolv(1,1,:), [length(fr) 1]);
%semilogy(fr*1e-9, abs(s11vector),'dr');
plot(fr*1e-9, 20*log10(abs(s11vector)), 'dr', 'LineWidth', linewidth);

set(gca,'FontSize',fontsize);
legend('ROM order 7', 'ROM order 5', 'ROM order 5 Ident', ... 
  'Discrete sweep', 'Location', 'NorthWest');
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
semilogy(fr*1e-9, abs(s11vector - sValO5(pos)), 'g', ...
  'LineWidth', linewidth);
hold;
semilogy(fr*1e-9, abs(s11vector - sValO5I(pos)), 'k', ...
  'LineWidth', linewidth);
semilogy(fr*1e-9, abs(s11vector - sValO5I_C(pos)), 'c', ...
  'LineWidth', linewidth);
grid;
set(gca,'FontSize',fontsize);
xlabel('Frequency (GHz)');
ylabel('|Error|');
legend('Order 5', 'Order 5 Ident', 'Order 5 Ident C++');
title('\epsilon_{r1}=1, \epsilon_{r2}=1');




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Without special treatment of ident matrix %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modelName = ...
% 'C:\work\examples\permittivity_measurement\wg_perm_sym\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(5,0)_6\';
% buildRedModelTranspBC_ModScal(modelName, order);
% fNameSpara = modelEvaluationGeneral(modelName);
% fNameSpara = [modelName 's_11_f_8000000000_17000000000_201_MU_RELATIVE_sample_5_5_1.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%     = loadSmatrix(fNameSpara);
% 
% plot results
% sVal = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, (abs(sVal)), 'g');
% hold;
%  
% modelName = ...
% 'C:\work\examples\permittivity_measurement\wg_perm_sym\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(5,0)_6_ident\';
% buildRedModelIdent_ModScal(modelName, order);
% fNameSpara = modelEvaluationIdent(modelName);
% fNameSpara = [modelName 's_11_f_8000000000_17000000000_201_MU_RELATIVE_sample_5_5_1.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%     = loadSmatrix(fNameSpara);
% 
% plot results
% sVal = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, (abs(sVal)));
% 
% 
% modelName = ...
% 'C:\work\examples\permittivity_measurement\wg_perm_sym\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(5,0)_8\';
% buildRedModelIdent_ModScal(modelName, order);
% fNameSpara = modelEvaluationIdent(modelName);
% fNameSpara = [modelName 's_11_f_8000000000_17000000000_201_MU_RELATIVE_sample_5_5_1.txt'];
% [parameterNames, numParameterPnts, parameterVals, sMatrices] ...
%     = loadSmatrix(fNameSpara);
% 
% plot results
% sVal = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, (abs(sVal)), 'k');
