close all;
clear all;

tic;

linewidth = 3;
fontsize = 24;

set(0,'DefaultFigureWindowStyle','docked');

load tsch3dPics;

figHandle = figure;
set(figHandle, 'color', 'w');
surf((sTest{2} * 2e3) + 4, (sTest{1} * 2e3) + 14, abs(s11));
set(gca, 'FontSize', fontsize);
xlabel('b (mm)');
ylabel('a (mm)');
zlabel('|S_{11}|');
axis([1 7 10 18 0 1]);
view([-80 56]);
set(gca, 'xtick', 1:2:9);
set(gca, 'ytick', 10:2:18);
set(gca, 'ztick', 0:0.2:1);

figHandle = figure;
set(figHandle, 'color', 'w');
surf((sTest{2} * 2e3) + 4, (sTest{1} * 2e3) + 14, abs(s11Test));
set(gca, 'FontSize', fontsize);
xlabel('b (mm)');
ylabel('a (mm)');
zlabel('|S_{11}|');
axis([1 7 10 18 0 1]);
view([-80 56]);
set(gca, 'xtick', 1:2:9);
set(gca, 'ytick', 10:2:18);
set(gca, 'ztick', 0:0.2:1);

figHandle = figure;
set(figHandle, 'color', 'w');
surf((sTest{2} * 2e3) + 4, (sTest{1} * 2e3) + 14, abs(s11 - s11Test));
set(gca, 'FontSize', fontsize);
xlabel('b (mm)');
ylabel('a (mm)');
zlabel('|Error|');
axis([1 7 10 18 0 4e-3]);
% view([-80 56]);
set(gca, 'xtick', 1:2:7);
set(gca, 'ytick', 10:2:18);
% set(gca, 'ztick', 0:0.02:0.08);



