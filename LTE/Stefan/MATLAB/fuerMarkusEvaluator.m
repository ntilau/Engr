close all;
clear;

addpath(genpath('C:\work\Matlab'));
% addpath(genpath('V:\Ortwin\ModRedBeispiel\OrtwinMatlab'));
set(0, 'DefaultFigureWindowStyle', 'docked');
fontsize = 12;
linewidth = 1.0;


%%
fNameSpara = 'C:\work\examples\langer\langer\langer_rom\Bandpassfilter_8e+009_100\S_f_1e+009_1.2e+010_11001.txt';
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);

% magnitude
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sVal1 = sVal;
freqs1 = freqs;
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs1 * 1e-9, 20 * log10(abs(sVal1)), 'LineWidth', linewidth);
grid;
hold on;
fNameSpara = 'C:\work\examples\langer\langer\langer_ws\langer_ws.txt';
[fr sMatWaveSolv] = readSparamWaveSolverModyfied(fNameSpara);
s11 = zeros(length(fr),1);
for k = 1:length(fr)
  s11(k) = sMatWaveSolv{k}(1,2);
  s12(k) = sMatWaveSolv{k}(1,1);
end
plot(fr * 1e-9, 20 * log10(abs(s12)), 'rd', 'LineWidth', linewidth);
BandpassfilterHFSS;
plot(f * 1e-9, 20 * log10(abs(S(:, 1, 1))), 'k', 'LineWidth', linewidth); 
xlabel('Frequency (GHz)');
ylabel('|S_{11}|');
legend('MOR', 'Full FE', 'Fast Sweep HFSS', 'Location', 'SouthWest');
axis([1 12 -60 10]);

% phase plot
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs1 * 1e-9, 180 / pi * angle(sVal1), 'LineWidth', linewidth);
grid;
hold on;
plot(fr * 1e-9, 180 / pi * angle(s12), 'rd', 'LineWidth', linewidth);
plot(f * 1e-9, 180 / pi * angle(S(:, 1, 1)), 'k', 'LineWidth', linewidth); 
xlabel('Frequency (GHz)');
set(gca, 'YTick', [-180 -120 -60 0 60 120 180]);
ylabel('Phase (S_{11}) (deg)');
legend('MOR', 'Full FE', 'Fast Sweep HFSS', 'Location', 'West');
axis([1 12 -180 +180]);

% error plot
fNameSpara = 'C:\work\examples\langer\langer\langer_rom\Bandpassfilter_8e+009_100\S_f_1e+009_1.2e+010_56.txt';
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
sVal = zeros(numParameterPnts(1), 1);
freqs = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  freqs(k) = parameterVals(1, k);
  sVal(k) = sMatrices{k}(1, 1);
end
sVal1 = sVal;
freqs1 = freqs;
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs1 * 1e-9, abs(sVal1.' - s12), 'LineWidth', linewidth);
xlabel('Frequency (GHz)');
ylabel('|Error S_{11}|');
grid;
axis([1 12 0e-7 7e-7]);

