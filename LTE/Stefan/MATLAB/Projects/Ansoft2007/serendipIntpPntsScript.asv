close all;
clear all;

load serendipIntpPnts;
linewidth = 3;
fontsize = 20;
markersize = 16;

figHandle = figure;
set(figHandle, 'color', 'w');
plot((sIntPntsList(:, 1) * 2e3) + 14, (sIntPntsList(:, 2) * 2e3) + 4, 'x', ...
  'LineWidth', linewidth, 'MarkerSize', markersize);
grid;
% surf((sTest{2} * 2e3) + 4, (sTest{1} * 2e3) + 14, abs(s11));
set(gca, 'FontSize', fontsize);
xlabel('a (mm)');
ylabel('b (mm)');
axis([10 18 1 7]);

print -dmeta -r600 intpPntsSerendip

