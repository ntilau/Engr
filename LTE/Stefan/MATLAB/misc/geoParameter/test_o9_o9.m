close all;
clear all;

linewidth = 3;
fontsize = 24;

geoModelName = ...
  'C:\work\examples\wgIrisQuarterShort\wgIrisQuarterShort_1e+010_geoModel\';
fNameAll = strcat(geoModelName, 'all_h0_p2_t_9');

load(fNameAll);
fIntp = f;
figHandle = figure;
set(figHandle, 'color', 'w');
plot(fOrig * 1e-9, abs(s11FOrig), 'rd', 'LineWidth', linewidth);
grid;
hold;
plot(fIntp * 1e-9, abs(s11F), 'ko', 'LineWidth', linewidth);
set(gca, 'FontSize', fontsize);
xlabel('Frequency (GHz)');
ylabel('|S_{11}|');
axis([8 17 0 0.8]);

% ROM
load mor_o9_o9;
plot(f * 1e-9, abs(s11), 'LineWidth', linewidth);
legend('Exact', 'Interpolated', 'ROM');

% error plot 1
figHandle = figure;
set(figHandle, 'color', 'w');
set(gca, 'FontSize', fontsize);
sIntp = zeros(length(fOrig), 1);
sROM = zeros(length(fOrig), 1);
for fCnt = 1:length(fOrig)
  sIntp(fCnt) = s11F(find(fIntp == fOrig(fCnt)));
  sROM(fCnt) = s11(find(f == fOrig(fCnt)));
end
semilogy(fOrig * 1e-9, abs(s11F - s11FOrig), 'k', 'LineWidth', linewidth);
hold;
grid;
xlabel('Frequency (GHz)');
ylabel('|Error|');
axis([8 17 1e-3 1e-1]);

% error plot 2
figHandle = figure;
set(figHandle, 'color', 'w');
set(gca, 'FontSize', fontsize);
semilogy(fOrig * 1e-9, abs(s11F - sROM), 'b', 'LineWidth', linewidth);
hold;
grid;
xlabel('Frequency (GHz)');
ylabel('|Error|');
axis([8 17 1e-6 1e-4]);

% error plot 3
figHandle = figure;
set(figHandle, 'color', 'w');
set(gca, 'FontSize', fontsize);
semilogy(fOrig * 1e-9, abs(s11F - s11FOrig), 'k', 'LineWidth', linewidth);
hold;
% grid;
semilogy(fOrig * 1e-9, abs(s11F - sROM), 'b', 'LineWidth', linewidth);
xlabel('Frequency (GHz)');
ylabel('|Error|');
axis([8 17 1e-6 1e-1]);
set(gca, 'ytick', [1e-6 1e-5 1e-4 1e-3 1e-2 1e-1]);
% set(gca, 'ytick', [1e-6 1e-4 1e-2 1e-0]);
legend('Exact - Interp.', 'Interp. - ROM', 'Location', 'East');
print -dmeta -r600 eRomComb


