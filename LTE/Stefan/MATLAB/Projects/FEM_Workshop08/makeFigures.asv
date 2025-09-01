% This script generates the Matlab figures for our FEM Workshop 2008 paper. 

close all;
clear;

set(0,'DefaultFigureWindowStyle','docked');
addpath(genpath('C:\work\Matlab\'));

fontsize = 12;
linewidth = 1.0;
c0 = 299792.458e3;


%% broadband frequency response: impedance formulation ->old ROM
%% ->resonance frequencies included

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.2e+008_10_oneMode\';
results = load([modelName 's11_broad_veryFine']);
fNameSpara = [modelName 'S_f_90076423.982878_90076423.982878_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sValRes = sMatrices{1}(1,1);
freqRes = parameterVals(1,1);
% insert resonance frequency into other sweep data
pos = max(find(results.freqs>freqRes,1));
freqs = [results.freqs(1:pos-1), freqRes, results.freqs(pos:end)];
sVal  = [results.sVal(1:pos-1);  sValRes; results.sVal(pos:end)];
% load results for second resonance frequency
fNameSpara = [modelName 'S_f_124913531.47648_124913531.47648_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sValRes = sMatrices{1}(1,1);
freqRes = parameterVals(1,1);
% insert resonance frequency into other sweep data
pos = max(find(freqs>freqRes,1));
freqs = [freqs(1:pos-1), freqRes, freqs(pos:end)];
sVal  = [sVal(1:pos-1);  sValRes; sVal(pos:end)];
figHandle = figure;
set(figHandle, 'color', 'w');
absS11dB = 20*log10(abs(sVal));
plot(freqs*1e-6, absS11dB, 'LineWidth', linewidth);
% grid;
% extendticklabel(gca,'x',16);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize);
axis([70 140 -220 0]);
set(gca, 'FontSize', fontsize);
% print -deps broad


%% broadband frequency response: impedance formulation ->old ROM

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.2e+008_10_oneMode\';
results = load([modelName 's11_broad_veryFine']);
figHandle = figure;
set(figHandle, 'color', 'w');
absS11dB = 20*log10(abs(results.sVal));
plot(results.freqs*1e-6, absS11dB, 'LineWidth', linewidth);
% grid;
% extendticklabel(gca,'x',16);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize);
axis([70 140 -220 -60]);
set(gca, 'FontSize', fontsize);
% print -deps broad´


%% zoom to first resonance

% sVal  = zeros(results.numParameterPnts,1);
% freqs = results.parameterVals.';
% for k = 1:results.numParameterPnts
%   sVal(k)  = results.sMatrices{k}(1,1);
% end
% results = load([modelName 'zoomFirstResonance']);
% save([modelName 'zoomFirstResonancePlotData'], 'freqs', 'sVal');

results = load([modelName 'zoomFirstResonancePlotData']);
% load results for first resonance frequency
fNameSpara = [modelName 'S_f_90076423.982878_90076423.982878_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sValRes = sMatrices{1}(1,1);
freqRes = parameterVals(1,1);
% insert resonance frequency into other sweep data
pos = max(find(results.freqs>freqRes,1));
freqs = [results.freqs(1:pos-1); freqRes; results.freqs(pos:end)];
sVal  = [results.sVal(1:pos-1);  sValRes; results.sVal(pos:end)];
figHandle = figure;
set(figHandle, 'color', 'w');
absS11dB = 20*log10(abs(sVal));
plot(freqs*1e-6, absS11dB, 'LineWidth', linewidth);
% grid;
% extendticklabel(gca,'x',16);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize);
axis([90.076 90.0768 -220 0]);
set(gca, 'FontSize', fontsize);
print -deps zoomFirstResonance


%% zoom to first resonance with transparten boundary conditions

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.2e+008_10_oneMode\';
results = load([modelName 'zoomFirstResonanceTransp']);
figHandle = figure;
set(figHandle, 'color', 'w');
absS11dB = 20*log10(abs(results.sVal));
plot(results.freqs*1e-6, absS11dB, 'LineWidth', linewidth);
% grid;
% extendticklabel(gca,'x',16);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize); 
axis([90.076 90.0768 -192.74 -192.68]);
set(gca, 'FontSize', fontsize);
print -deps zoomFirstResonanceTransp


%% zoom to second resonance

% sVal  = zeros(results.numParameterPnts,1);
% freqs = results.parameterVals.';
% for k = 1:results.numParameterPnts
%   sVal(k)  = results.sMatrices{k}(1,1);
% end
% results = load([modelName 'zoomFirstResonance']);
% save([modelName 'zoomFirstResonancePlotData'], 'freqs', 'sVal');

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.2e+008_10_oneMode\';
results = load([modelName 'zoomSecondResonance']);
fNameSpara = [modelName 'S_f_124913531.47648_124913531.47648_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
sValRes = sMatrices{1}(1,1);
freqRes = parameterVals(1,1);
% insert resonance frequency into other sweep data
pos = max(find(results.freqs>freqRes,1));
freqs = [results.freqs(1:pos-1); freqRes; results.freqs(pos:end)];
sVal  = [results.sVal(1:pos-1);  sValRes; results.sVal(pos:end)];
figHandle = figure;
set(figHandle, 'color', 'w');
absS11dB = 20*log10(abs(sVal));
plot(freqs*1e-6, absS11dB, 'LineWidth', linewidth);
% grid;
% extendticklabel(gca,'x',16);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize);
axis([124.9132 124.9138 -200 0]);
set(gca, 'FontSize', fontsize);
print -deps zoomSecondResonance


%% zoom to second resonance with transparten boundary conditions

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.2e+008_10_oneMode\';
results = load([modelName 'zoomSecondResonanceTransp']);
figHandle = figure;
set(figHandle, 'color', 'w');
absS11dB = 20*log10(abs(results.sVal));
plot(results.freqs*1e-6, absS11dB, 'LineWidth', linewidth);
% grid;
% extendticklabel(gca,'x',16);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize); 
axis([124.9132 124.9138 -174.453 -174.4505]);
set(gca, 'FontSize', fontsize);
print -deps zoomSecondResonanceTransp


%% compare to analytical solution

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.1e+008_20\';
results = load([modelName 'S_f_70000000_140000000_7000001_transp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
figHandle = figure;
set(figHandle, 'color', 'w');
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs*1e-6, absErrorS12dB, 'LineWidth', linewidth);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|Error S_{12}| (dB)', 'FontSize', fontsize); 
% axis([124.9132 124.9138 -174.453 -174.4505]);
set(gca, 'FontSize', fontsize);
print -deps comp2analytSol


%% broadband frequency response: combined approach

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.1e+008_20\';
results = load([modelName 'S_f_70000000_140000000_7000001_transp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s11 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s11(fCnt) = results.sMat{fCnt}(1,1);
end
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs*1e-6, 20*log10(abs(s11)), 'LineWidth', linewidth);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize);
axis([70 140 -220 -60]);
set(gca, 'FontSize', fontsize);
print -deps broadTransp


%% broadband frequency response: impedance formulation

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.1e+008_20\';
results = load([modelName 'S_f_70000000_140000000_7000001_imp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s11 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s11(fCnt) = results.sMat{fCnt}(1,1);
end
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs*1e-6, 20*log10(abs(s11)), 'LineWidth', linewidth);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize);
axis([70 140 -220 -60]);
set(gca, 'FontSize', fontsize);
print -deps broadImp


%% broadband frequency response: combined approach -> s12

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.1e+008_20\';
results = load([modelName 'S_f_70000000_140000000_7000001_transp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs*1e-6, 20*log10(abs(s12)), 'LineWidth', linewidth);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|S_{12}| (dB)', 'FontSize', fontsize);
set(gca, 'FontSize', fontsize);
print -deps broadTranspS12


%% compare to analytical solution -> lower order

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.1e+008_lowerOrder\';
results = load([modelName 'S_f_70000000_140000000_70001_o2_imp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
figHandle = figure;
set(figHandle, 'color', 'w');
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs*1e-6, absErrorS12dB, '--', 'LineWidth', linewidth);
hold;
results = load([modelName 'S_f_70000000_140000000_70001_o2_transp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs*1e-6, absErrorS12dB, '--', 'LineWidth', linewidth);
results = load([modelName 'S_f_70000000_140000000_70001_o4_imp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs*1e-6, absErrorS12dB, ':', 'LineWidth', linewidth);
results = load([modelName 'S_f_70000000_140000000_70001_o4_transp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs*1e-6, absErrorS12dB, ':', 'LineWidth', linewidth);
results = load([modelName 'S_f_70000000_140000000_70001_o6_imp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs*1e-6, absErrorS12dB, '-', 'LineWidth', linewidth);
results = load([modelName 'S_f_70000000_140000000_70001_o6_transp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs*1e-6, absErrorS12dB, '-', 'LineWidth', linewidth);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|Error S_{12}| (dB)', 'FontSize', fontsize); 
legend('Imp. 2', 'Comb. 2', 'Imp. 4', 'Comb. 4', 'Imp. 6', 'Comb. 6', 'FontSize', fontsize, 'Location', 'SouthEast');
% axis([124.9132 124.9138 -174.453 -174.4505]);
set(gca, 'FontSize', fontsize);
print -deps comp2analytSol2

%% compare to analytical solution -> lower order -> fewer points

modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.1e+008_lowerOrder\';
results = load([modelName 'S_f_70000000_140000000_70001_o2_imp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
figHandle = figure;
set(figHandle, 'color', 'w');
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs(1:100:end)*1e-6, absErrorS12dB(1:100:end), '--', 'LineWidth', linewidth);
hold;
results = load([modelName 'S_f_70000000_140000000_70001_o2_transp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs(1:100:end)*1e-6, absErrorS12dB(1:100:end), '--', 'LineWidth', linewidth);
results = load([modelName 'S_f_70000000_140000000_70001_o4_imp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs(1:100:end)*1e-6, absErrorS12dB(1:100:end), ':', 'LineWidth', linewidth);
results = load([modelName 'S_f_70000000_140000000_70001_o4_transp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs(1:100:end)*1e-6, absErrorS12dB(1:100:end), ':', 'LineWidth', linewidth);
results = load([modelName 'S_f_70000000_140000000_70001_o6_imp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs(1:100:end)*1e-6, absErrorS12dB(1:100:end), '-', 'LineWidth', linewidth);
results = load([modelName 'S_f_70000000_140000000_70001_o6_transp']);
freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, results.freqParam.numPnts).';
s12 = zeros(results.freqParam.numPnts,1);
for fCnt = 1:length(freqs)
    s12(fCnt) = results.sMat{fCnt}(1,2);
end
s12analyt = exp(-sqrt((pi/2)^2-(2*pi*freqs/c0).^2) * 3);
absErrorS12dB = 20*log10(abs(s12analyt - s12));
plot(freqs(1:100:end)*1e-6, absErrorS12dB(1:100:end), '-', 'LineWidth', linewidth);
xlabel('Frequency (MHz)', 'FontSize', fontsize);
ylabel('|Error S_{12}| (dB)', 'FontSize', fontsize); 
legend('Imp. 2', 'Comb. 2', 'Imp. 4', 'Comb. 4', 'Imp. 6', 'Comb. 6', 'FontSize', fontsize, 'Location', 'SouthEast');
% axis([124.9132 124.9138 -174.453 -174.4505]);
set(gca, 'FontSize', fontsize);
print -deps comp2analytSol2


%% Langer Filter
%% Langer Filter
modelName = 'C:\work\examples\langer\2009_PaperFEM_Workshop\langer_dual_coarse_7e+009_20_sMatrix\';
fNameSpara = [modelName 'S_f_1000000000_10000000000_601.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
sValTransp  = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
    freqs(k) = parameterVals(1,k);
    sValTransp(k)  = sMatrices{k}(1,1);
end
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs*1e-9, 20*log10(abs(sValTransp)), 'LineWidth', linewidth);
hold on;
modelName = 'C:\work\examples\langer\2009_PaperFEM_Workshop\langer_dual_coarse_7e+009_20\';
fNameSpara = [modelName 'S_f_1000000000_10000000000_601.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
sValComb = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
    freqs(k) = parameterVals(1,k);
    sValComb(k)  = sMatrices{k}(1,1);
end
plot(freqs*1e-9, 20*log10(abs(sValComb)), '--', 'LineWidth', linewidth);
modelName = 'C:\work\examples\langer\2009_PaperFEM_Workshop\langer_dual_coarse_7e+009_40_sMatrix\';
fNameSpara = [modelName 'S_f_1000000000_10000000000_601.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
sValTransp40 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
    freqs(k) = parameterVals(1,k);
    sValTransp40(k)  = sMatrices{k}(1,1);
end
plot(freqs*1e-9, 20*log10(abs(sValTransp40)), '-.', 'LineWidth', linewidth);
modelName = 'C:\work\examples\langer\2009_PaperFEM_Workshop\langer_dual_coarse_7e+009_40\';
fNameSpara = [modelName 'S_f_1000000000_10000000000_601.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
sValComb40 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
    freqs(k) = parameterVals(1,k);
    sValComb40(k)  = sMatrices{k}(1,1);
end
plot(freqs*1e-9, 20*log10(abs(sValComb40)), ':', 'LineWidth', linewidth);
modelName = 'C:\work\examples\langer\2009_PaperFEM_Workshop\langer_dual_coarse_7e+009_40\';
fNameSpara = [modelName 'S_f_1000000000_10000000000_601_full.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
sValFull  = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
    freqs(k) = parameterVals(1,k);
    sValFull(k)  = sMatrices{k}(1,1);
end
plot(freqs*1e-9, 20*log10(abs(sValFull)), 'r*', 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}| (dB)', 'FontSize', fontsize);
legend('S matrix: 20', 'Comb. Appr.: 20', 'S matrix: 40', 'Comb. Appr.: 40', 'Full FE', 'Location', 'SouthWest');
axis([1 10 -40 0]);
set(gca, 'FontSize', fontsize);
print -deps langerS11

% error plot
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs*1e-9, 20*log10(abs(sValTransp-sValFull)), '-', 'LineWidth', linewidth);
hold on;
plot(freqs*1e-9, 20*log10(abs(sValComb-sValFull)), '--', 'LineWidth', linewidth);
plot(freqs*1e-9, 20*log10(abs(sValTransp40-sValFull)), '-.', 'LineWidth', linewidth);
plot(freqs*1e-9, 20*log10(abs(sValComb40-sValFull)), ':', 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error S_{11}| (dB)', 'FontSize', fontsize);
legend('S matrix: 20', 'Comb. Appr.: 20', 'S matrix: 40', 'Comb. Appr.: 40', 'Location', 'NorthWest');
set(gca, 'FontSize', fontsize);
print -deps langerErrorS11

