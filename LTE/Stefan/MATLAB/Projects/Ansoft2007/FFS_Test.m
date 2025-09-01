% close all;
clear all:

set(0,'DefaultFigureWindowStyle','docked');
fontsize = 12;





%% wgIris
fNameWsolver = 'C:\work\examples\wgIris\wgIrisQuarterShortWS\sParam_8e9_17e9_newWS.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
% s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
s11vector = reshape(sMatrices(1,2,:), [length(fr) 1]);
% plot results
figHandle = figure;
set(figHandle,'color','w');
plot(fr*1e-9, abs(s11vector),'dr');
grid;
hold;

fNameWsolver = 'C:\work\examples\wgIris\wgIrisQuarterShort_waveSolver\sParam.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
% s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
% plot results
plot(fr*1e-9, abs(s11vector),'ok');

order = 30;
modelName = ...
  'C:\work\examples\wgIris\wgIrisQuarterShort\wgIrisQuarterShort_1.5e+010_30\';

impedanceFlag = true;
linFreqParamFlag = true;

% buildRedModelInterpolation(modelName, order, linFreqParamFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag);

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);

% one parameter plot
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, abs(sVal));

fNameWsolver = 'C:\work\examples\wgIris\wgIrisQuarterShortWS\sParam_opt.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
% s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
% plot results
plot(fr*1e-9, abs(s11vector),'+c');


%% wg_perm_sym

fNameWsolver = 'C:\work\examples\permittivity_measurement\wg_perm_sym_wSolver\sParam_dual.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
% s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
s11vector = reshape(sMatrices(1,2,:), [length(fr) 1]);
% plot results
figHandle = figure;
set(figHandle,'color','w');
plot(fr*1e-9, abs(s11vector),'dr');
hold;
grid;


fNameWsolver = 'C:\work\examples\permittivity_measurement\wg_perm_sym_wSolver\sParam_w16_new.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
% s11vector = reshape(sMatrices(1,2,:), [length(fr) 1]);
% plot results
figHandle = figure;
set(figHandle,'color','w');
plot(fr*1e-9, abs(s11vector),'dr');
hold;
grid;

fNameWsolver = 'C:\work\examples\permittivity_measurement\wg_perm_sym_wSolver\sParam_opt.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
% s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
s11vector = reshape(sMatrices(1,2,:), [length(fr) 1]);
% plot results
plot(fr*1e-9, abs(s11vector),'ok');