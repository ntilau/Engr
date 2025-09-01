close all;
clear all;


load fsOrig;

linewidth = 2.5;
fontsize = 16;
figHandle = figure;
set(figHandle, 'color', 'w');
plot(fOrig * 1e-9, abs(s11FOrig), 'rd', 'LineWidth', linewidth);
set(gca, 'FontSize', fontsize);
grid;
hold;
plot(f * 1e-9, abs(s11F), 'ko', 'LineWidth', linewidth);
fDiscr = f;
load rom_15_1_o6;
% 2d plot
if freqParam.numPnts == 1
  deltaF = 0;
else
  deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
end
for kStepCnt = 1:freqParam.numPnts
  s11(kStepCnt) = sMat{kStepCnt}(1, 1);
  f(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
end
plot(f * 1e-9, abs(s11), 'LineWidth', linewidth);
load rom_15_1;
% 2d plot
if freqParam.numPnts == 1
  deltaF = 0;
else
  deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
end
for kStepCnt = 1:freqParam.numPnts
  s11(kStepCnt) = sMat{kStepCnt}(1, 1);
  f(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
end
plot(f * 1e-9, abs(s11), 'g-.', 'LineWidth', linewidth);
legend('Exact', 'Interpolated', 'ROM 6', 'ROM 8', 'Location', 'North');
axis([8 17 0 0.25]);
xlabel('Frequency (GHz)');
ylabel('|S_{11}|');


%% plot 1 in black and white
load fsOrig;
linewidth = 2.5;
fontsize = 18;
figHandle = figure;
set(figHandle, 'color', 'w');
plot(fOrig * 1e-9, abs(s11FOrig), 'kd', 'LineWidth', linewidth);
set(gca, 'FontSize', fontsize);
grid;
hold;
plot(f * 1e-9, abs(s11F), 'ko', 'LineWidth', linewidth);
fDiscr = f;
load rom_15_1_o6;
% 2d plot
if freqParam.numPnts == 1
  deltaF = 0;
else
  deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
end
for kStepCnt = 1:freqParam.numPnts
  s11(kStepCnt) = sMat{kStepCnt}(1, 1);
  f(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
end
plot(f * 1e-9, abs(s11), 'k', 'LineWidth', linewidth);
load rom_15_1;
% 2d plot
if freqParam.numPnts == 1
  deltaF = 0;
else
  deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
end
for kStepCnt = 1:freqParam.numPnts
  s11(kStepCnt) = sMat{kStepCnt}(1, 1);
  f(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
end
plot(f * 1e-9, abs(s11), 'k-.', 'LineWidth', linewidth);
legend('Exact', 'Interpolated', 'ROM 6', 'ROM 8', 'Location', 'North');
axis([8 17 0 0.25]);
xlabel('Frequency (GHz)');
ylabel('|S_{11}|');



%% error plot 1
load rom_15_1_o6;
figHandle = figure;
set(figHandle, 'color', 'w');
set(gca, 'FontSize', fontsize);
sIntp = zeros(length(fOrig), 1);
sROM = zeros(length(fOrig), 1);
for fCnt = 1:length(fOrig)
%   sIntp(fCnt) = s11F(find(fIntp == fOrig(fCnt)));
  sROM(fCnt) = s11(find(f == fOrig(fCnt)));
end
semilogy(fOrig * 1e-9, abs(s11F - s11FOrig), 'k', 'LineWidth', linewidth);
hold;
grid;
xlabel('Frequency (GHz)');
ylabel('|Error|');
semilogy(fOrig * 1e-9, abs(s11F - sROM), 'LineWidth', linewidth);


load rom_15_1;
for fCnt = 1:length(fOrig)
%   sIntp(fCnt) = s11F(find(fIntp == fOrig(fCnt)));
  sROM(fCnt) = s11(find(f == fOrig(fCnt)));
end
semilogy(fOrig * 1e-9, abs(s11F - sROM), 'g', 'LineWidth', linewidth);

axis([8 17 1e-9 1e-0]);
legend('Exact - Interp.', 'Interp. - ROM 6', 'Interp. - ROM 8');
% , ...
%   'Location', 'NorthWest');
set(gca, 'ytick', [1e-9 1e-6 1e-3 1e-0]);
% print -dmeta -r600 errorRoms


%% error plot 1 - black and white
fontsize = 18;
load rom_15_1_o6;
figHandle = figure;
set(figHandle, 'color', 'w');
set(gca, 'FontSize', fontsize);
sIntp = zeros(length(fOrig), 1);
sROM = zeros(length(fOrig), 1);
for fCnt = 1:length(fOrig)
%   sIntp(fCnt) = s11F(find(fIntp == fOrig(fCnt)));
  sROM(fCnt) = s11(find(f == fOrig(fCnt)));
end
semilogy(fOrig * 1e-9, abs(s11F - s11FOrig), 'k--', 'LineWidth', linewidth);
hold;
grid;
xlabel('Frequency (GHz)');
ylabel('|Error|');
semilogy(fOrig * 1e-9, abs(s11F - sROM), 'k-', 'LineWidth', linewidth);
load rom_15_1;
for fCnt = 1:length(fOrig)
%   sIntp(fCnt) = s11F(find(fIntp == fOrig(fCnt)));
  sROM(fCnt) = s11(find(f == fOrig(fCnt)));
end
semilogy(fOrig * 1e-9, abs(s11F - sROM), 'k-.', 'LineWidth', linewidth);
axis([8 17 1e-9 1e-1]);
legend('Exact - Interp.', 'Interp. - ROM 6', 'Interp. - ROM 8');
% , ...
%   'Location', 'NorthWest');
set(gca, 'ytick', [1e-9 1e-7 1e-5 1e-3 1e-1]);
% print -dmeta -r600 errorRoms

