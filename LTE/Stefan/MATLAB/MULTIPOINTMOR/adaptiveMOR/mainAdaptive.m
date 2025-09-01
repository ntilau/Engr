close all;
clear all;

format long;

% Define pathes
[status,result] = system('echo %LTE_ROOT%');
mainFolder = [ result(1:end-1) '\MATLAB\' ];
IOPath = [mainFolder 'IO'];
drivenPath = [mainFolder 'multiPointMOR\drivenMOR'];

addpath(IOPath, drivenPath);
addpath(genpath([mainFolder '\multiPointMOR\additional'] ));


%% Load model data

% Define Model Paramater
modelName = 'C:\daten\2009_cpp\langer_dual_coarse\langer_dual_coarse_1e+010_2\';


% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);

fNameSpara = strcat(modelName, 'sOrig_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
  num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));
fNameSparaOrig = strcat(fNameSpara, '.txt');


%% Model order reduction

% Generate Multipoint ROM 
numExpFreq = 41;
generateAdaptiveModel(modelName, numExpFreq);
fNameSparaMulti = evaluateReducedModel(modelName);

% Genearte Singlepoint ROM
linFreqParamFlag = true;
impedanceFlag = true;
order = numExpFreq -1;
fExpansion = 10.15e9;
%generateSinglePointModel(modelName, order, linFreqParamFlag, fExpansion);
%fNameSparaSingle = evaluateSingleModel(modelName, impedanceFlag, fExpansion);



%% Single-point ROM error versus expansion frequency

% singlePointSweep;


%% Plot Results

%Load Original Model Data
[parameterNamesMulti, numParameterPntsMulti, parameterValsMulti, sMatricesMulti] ...
  = loadSmatrix(fNameSparaOrig);
sValOrig = zeros(numParameterPntsMulti(1),1);
freqsMulti = zeros(numParameterPntsMulti(1),1);
for k = 1:numParameterPntsMulti(1)
  fr(k) = parameterValsMulti(1,k);
  sValOrig111(k) = sMatricesMulti{k}(1, 1);
  sValOrig112(k) = sMatricesMulti{k}(1, 2);
%   sValOrig211(k) = sMatricesMulti{k}(2, 2);
%   sValOrig212(k) = sMatricesMulti{k}(2, 5);  
%   sValOrig311(k) = sMatricesMulti{k}(3, 3);
%   sValOrig312(k) = sMatricesMulti{k}(3, 6);  
end

% % % % 
% % Wavesolver Computation
% fNameSpara = strcat(modelName, 'sSolver_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
%   num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));
% fNameWsolver = strcat(fNameSpara, '.txt');
% 
% [fr sMatWaveSolv] = readSparamWaveSolverCell(fNameWsolver);
% sValOrig111 = zeros(length(fr),1);
% for k = 1:length(fr)
%    sValOrig111(k) = sMatWaveSolv{k}(1,1);
%    sValOrig112(k) = sMatWaveSolv{k}(1,2);
% end




%Load Multipoint Data
[parameterNamesMulti, numParameterPntsMulti, parameterValsMulti, sMatricesMulti] ...
  = loadSmatrix(fNameSparaMulti);
sValMulti = zeros(numParameterPntsMulti(1),1);
freqsMulti = zeros(numParameterPntsMulti(1),1);
for k = 1:numParameterPntsMulti(1)
  freqsMulti(k) = parameterValsMulti(1,k);
  sValMulti111(k) = sMatricesMulti{k}(1, 1);
   sValMulti112(k) = sMatricesMulti{k}(1, 2);
%   sValMulti211(k) = sMatricesMulti{k}(2, 2);
%   sValMulti212(k) = sMatricesMulti{k}(2, 5);
%   sValMulti311(k) = sMatricesMulti{k}(3, 3);
%   sValMulti312(k) = sMatricesMulti{k}(3, 6);
end


% 
% %Load Singlepoint Data
% [parameterNamesSingle, numParameterPntsSingle, parameterValsSingle, sMatricesSingle] ...
%   = loadSmatrix(fNameSparaSingle);
% sValSingle = zeros(numParameterPntsSingle(1),1);
% freqsSingle = zeros(numParameterPntsSingle(1),1);
% for k = 1:numParameterPntsSingle(1)
%   freqsSingle(k) = parameterValsSingle(1,k);
%   sValSingle111(k) = sMatricesSingle{k}(1, 1);
%   sValSingle112(k) = sMatricesSingle{k}(1, 2);
% end





% plot results
figHandle=figure(1);
set(figHandle,'color','w');
text('Interpreter','latex');
subplot('Position',[0.17 0.62 0.8 0.33 ]);
set(gca, 'FontSize',18);
%semilogy(fr*1e-9, abs( sValOrig111 - sValSingle111), 'green', 'LineWidth', 2);
%hold on;
semilogy(fr*1e-9, abs( sValOrig111 - sValMulti111), 'black', 'LineWidth', 2);
%hold off;
ylabel('e_{11}');
xlabel('Frequency (GHz)');
grid on;
legend('SPM', 'MPM');



subplot('Position',[0.17 0.14 0.8 0.33 ]);
set(gca, 'FontSize',18);
%semilogy(fr*1e-9, abs( sValOrig112 + sValSingle112), 'green', 'LineWidth', 2);
%hold on;
semilogy(fr*1e-9, abs( sValOrig112 + sValMulti112), 'black', 'LineWidth', 2);
%hold off;
ylabel('e_{12}');
xlabel('Frequency (GHz)');
grid on;
legend('SPM', 'MPM');




% plot results
figHandle=figure(2);
set(figHandle,'color','w');
set(gca, 'FontSize',18);
plot(freqsMulti*1e-9, 20*log10(abs(sValMulti112)),  'green --', 'LineWidth',2);
hold on;
plot(fr*1e-9, 20*log10(abs(sValMulti111)),  'black -', 'LineWidth', 3);
hold off;
ylabel('|s_{11}| (dB), |s_{12}| (dB)');
xlabel('Frequency (GHz)');
grid on;
legend('|s_{11}|', '|s_{12}|');
axis([4 12 -60 0]);

