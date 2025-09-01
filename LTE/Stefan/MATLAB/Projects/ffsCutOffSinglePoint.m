close all;
clear all:

addpath C:\work\Alwin\Matlab_Multipoint;
set(0, 'DefaultFigureWindowStyle', 'docked');
  
order = 50;
fontsize = 16;

modelName = ...
  'C:\work\Alwin\wg3_singlePnt\wg3_3e+008_20\';

% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);

% Compute analytic solution
[s11, s12] = wg3_analytisch(freqParam);

impedanceFlag = true;
linFreqParamFlag = true;

buildRedModelInterpolation(modelName, order, linFreqParamFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag);

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);

% one parameter plot
s11Single = zeros(numParameterPnts(1),1);
s12Single = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  s11Single(k) = sMatrices{k}(1, 1);
  s12Single(k) = sMatrices{k}(1, 2);
end

%% plot S_11

% plot results
figHandle=figure(1);
set(figHandle,'color','w');
subplot(3,1,1);
% plot(freqs * 1e-6, 20*log(abs(s11)), 'black', 'LineWidth', linewidth);
% hold on;
plot(freqs*1e-6, 20*log(abs(s11Single)), 'blue', ...
  'LineWidth', linewidth);
hold off;
set(gca, 'FontSize', fontsize);
ylabel('|s_{11}| (dB)');
xlabel('Frequency (MHz)');
% legend('Analytical solution', 'Numerical solution');
grid on;

subplot(3,1,2);
% plot(freqs * 1e-6, angle(s11), 'black', 'LineWidth', linewidth);
% hold on;
plot(freqs * 1e-6, angle(s11Single), 'blue', 'LineWidth', linewidth);
hold off;
set(gca, 'FontSize', fontsize);
ylabel('Phase s_{11} (rad)');
xlabel('Frequency (MHz)');
% legend('Analytical solution', 'Numerical solution');
grid on;


subplot(3,1,3);
semilogy(freqs * 1e-6, abs(s11Single - s11.'), 'blue', ...
  'LineWidth', linewidth);
set(gca, 'FontSize', fontsize);
ylabel('|Error s_{11}|');
xlabel('Frequency (MHz)');
grid on;


%% Plot S_12

% plot results
figHandle=figure(2);
set(figHandle,'color','w');
subplot(3,1,1);
% plot(freqs * 1e-6, 20*log(abs(s12)), 'black', 'LineWidth', linewidth);
% hold on;
plot(freqs * 1e-6, 20*log(abs(s12Single)), 'blue', ...
  'LineWidth', linewidth);
hold off;
set(gca, 'FontSize', fontsize);
ylabel('|s_{12}| (dB)');
xlabel('Frequency (MHz)');
% legend('Analytical solution', 'Numerical solution');
grid on;

subplot(3,1,2);
% plot(freqs * 1e-6, angle(s12), 'black', 'LineWidth', linewidth);
% hold on;
plot(freqs * 1e-6, angle(s12Single), 'blue', 'LineWidth', linewidth);
hold off;
set(gca, 'FontSize', fontsize);
ylabel('Phase s_{12} (rad)');
xlabel('Frequency (MHz)');
% legend('Analytical solution', 'Numerical solution');
grid on;

subplot(3,1,3);
semilogy(freqs * 1e-6, abs(s12Single - s12.'), 'blue', ...
  'LineWidth', linewidth);
set(gca, 'FontSize', fontsize);
ylabel('|Error s_{12}|');
xlabel('Frequency (MHz)');
grid on;



