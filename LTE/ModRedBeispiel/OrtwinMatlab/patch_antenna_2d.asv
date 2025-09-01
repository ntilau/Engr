% 2D-Plots of patch_antenna

close all;
clear all;

set(0,'DefaultFigureWindowStyle','docked')

linewidth = 2.5;
fontsize = 16;
stepDisc = 3;

% e1=1; e2=3
figHandle = figure;
set(figHandle,'color','w');
filename = 'S:\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_e1_4_e2_2_new\s_11_f_3e+009_8e+009_201_e1_1_1_1_e2_1_1_1.txt';
filename = 'C:\work\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_e1_4_e2_2_new\s_11_f_3e+009_8e+009_201_e1_1_1_1_e2_1_1_1.txt';
[mus, freqs, s] = readSparamMORs11(filename);
abs_s = abs(s);
plot(freqs*1e-9, abs_s', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize)
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
grid;
hold;

fNameSpara = 'S:\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_10\S_f_3e+009_8e+009_201_EPSILON_RELATIVE_Box1_(1,0)_(5,0)_1_EPSILON_RELATIVE_Box2_(1,0)_(3,0)_1.txt';
fNameSpara = 'C:\work\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_10\S_f_3e+009_8e+009_201_EPSILON_RELATIVE_Box1_(1,0)_(5,0)_1_EPSILON_RELATIVE_Box2_(1,0)_(3,0)_1.txt';
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, (abs(sValO5)), 'g', 'LineWidth', linewidth);

fNameWsolver = 'S:\examples\patch_antenna\patch_antenna_wSolver\sParam_e1_1_e2_1.txt';
fNameWsolver = 'C:\work\examples\patch_antenna\patch_antenna_wSolver\sParam_e1_1_e2_1.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
%semilogy(fr*1e-9, abs(s11vector),'dr');
plot(fr*1e-9, abs(s11vector),'dr');
legend('ROM', 'Full FE');

% plot error
figHandle = figure;
set(figHandle,'color','w');
pos = zeros(1,length(s11vector));
for k = 1:length(s11vector)
  pos(k) = find(parameterVals(1,:) == fr(k));
end
semilogy(fr*1e-9, abs(s11vector - sValO5(pos)), 'LineWidth', linewidth);
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

% e1=1; e2=3
figHandle = figure;
set(figHandle,'color','w');
% filename = 'C:\work\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_e1_4_e2_2_new\s_11_f_3e+009_8e+009_201_e1_1_1_1_e2_3_3_1.txt';
% [mus, freqs, s] = readSparamMORs11(filename);
% abs_s = abs(s);
% plot(freqs*1e-9, abs_s', 'LineWidth', linewidth);
% set(gca,'FontSize',fontsize)
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
grid;
hold;

fNameSpara = 'S:\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_10\S_f_3e+009_8e+009_401_EPSILON_RELATIVE_Box1_(1,0)_(5,0)_1_EPSILON_RELATIVE_Box2_(3,0)_(3,0)_1.txt';
fNameSpara = 'C:\work\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_10\S_f_3e+009_8e+009_401_EPSILON_RELATIVE_Box1_(1,0)_(5,0)_1_EPSILON_RELATIVE_Box2_(3,0)_(3,0)_1.txt';
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, (abs(sValO5)), 'b', 'LineWidth', linewidth);

fNameWsolver = 'S:\examples\patch_antenna\patch_antenna_wSolver\sParam_e1_1_e2_3.txt';
fNameWsolver = 'C:\work\examples\patch_antenna\patch_antenna_wSolver\sParam_e1_1_e2_3.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
%semilogy(fr*1e-9, abs(s11vector),'dr');
plot(fr*1e-9, abs(s11vector), 'dr', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize);
legend('ROM', 'Full FE', 'Location', 'SouthWest');
% title('\epsilon_{r1}=1, \epsilon_{r2}=3');
xlabel('Frequency (GHz)');
ylabel('|S_{11}| (dB)');

% plot error
figHandle = figure;
set(figHandle,'color','w');
pos = zeros(1,length(s11vector));
for k = 1:length(s11vector)
  pos(k) = find(parameterVals(1,:) == fr(k));
end
semilogy(fr*1e-9, abs(s11vector - sValO5(pos)), 'LineWidth', linewidth);
hold;
semilogy(fr*1e-9, abs(s11vector - sValO5(pos)), ...'g', ...
  'LineWidth', linewidth);
grid;
set(gca,'FontSize',fontsize);
xlabel('Frequency (GHz)');
ylabel('|Error|');
% legend('Order7', 'Order 5');
% title('\epsilon_{r1}=1, \epsilon_{r2}=1');
print -depsc error_eps1_eps1

% e1 = 5; e2 = 1
figHandle = figure;
set(figHandle,'color','w');
filename = 'S:\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_e1_4_e2_2_new\s_11_f_3e+009_8e+009_201_e1_5_5_1_e2_1_1_1.txt';
filename = 'C:\work\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_e1_4_e2_2_new\s_11_f_3e+009_8e+009_201_e1_5_5_1_e2_1_1_1.txt';
[mus, freqs, s] = readSparamMORs11(filename);
abs_s = abs(s);
plot(freqs*1e-9, abs_s', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize)
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
grid;
hold;

fNameSpara = 'S:\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_10\S_f_3e+009_8e+009_201_EPSILON_RELATIVE_Box1_(5,0)_(5,0)_1_EPSILON_RELATIVE_Box2_(1,0)_(3,0)_1.txt';
fNameSpara = 'C:\work\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_10\S_f_3e+009_8e+009_201_EPSILON_RELATIVE_Box1_(5,0)_(5,0)_1_EPSILON_RELATIVE_Box2_(1,0)_(3,0)_1.txt';
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, (abs(sValO5)), 'g', 'LineWidth', linewidth);


fNameWsolver = 'S:\examples\patch_antenna\patch_antenna_wSolver\sParam_e1_5_e2_1.txt';
fNameWsolver = 'C:\work\examples\patch_antenna\patch_antenna_wSolver\sParam_e1_5_e2_1.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
plot(fr*1e-9, abs(s11vector),'dr');
legend('ROM', 'Full FE');


% e1 = 5; e2 = 3
figHandle = figure;
set(figHandle,'color','w');
filename = 'S:\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_e1_4_e2_2_new\s_11_f_3e+009_8e+009_201_e1_5_5_1_e2_3_3_1.txt';
filename = 'C:\work\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_e1_4_e2_2_new\s_11_f_3e+009_8e+009_201_e1_5_5_1_e2_3_3_1.txt';
[mus, freqs, s] = readSparamMORs11(filename);
abs_s = abs(s);
plot(freqs*1e-9, abs_s', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize)
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
grid;
hold;


fNameSpara = 'S:\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_10\S_f_3e+009_8e+009_201_EPSILON_RELATIVE_Box1_(5,0)_(5,0)_1_EPSILON_RELATIVE_Box2_(3,0)_(3,0)_1.txt';
fNameSpara = 'C:\work\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_10\S_f_3e+009_8e+009_201_EPSILON_RELATIVE_Box1_(5,0)_(5,0)_1_EPSILON_RELATIVE_Box2_(3,0)_(3,0)_1.txt';
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, (abs(sValO5)), 'g', 'LineWidth', linewidth);


fNameSpara = 'S:\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6\S_f_3000000000_8000000000_151_EPSILON_RELATIVE_Box1_5_5_1_EPSILON_RELATIVE_Box2_3_3_1.txt';
fNameSpara = 'C:\work\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6\S_f_3000000000_8000000000_151_EPSILON_RELATIVE_Box1_5_5_1_EPSILON_RELATIVE_Box2_3_3_1.txt';
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);

% one parameter plot
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, abs(sVal), 'k', 'LineWidth', linewidth);


fNameWsolver = 'S:\examples\patch_antenna\patch_antenna_wSolver\sParam_e1_5_e2_3.txt';
fNameWsolver = 'C:\work\examples\patch_antenna\patch_antenna_wSolver\sParam_e1_5_e2_3.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
plot(fr*1e-9, abs(s11vector),'dr', 'LineWidth', linewidth);
legend('Old 8', 'Old 10', 'New 8', 'Full FE');
