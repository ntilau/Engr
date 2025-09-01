close all;
clear all;

linewidth = 3;
fontsize = 24;
% az = 121;
% el = 28;
az = 121;
el = 34;
set(0,'DefaultFigureWindowStyle','docked');

load f_8;
figHandle = figure;
set(figHandle, 'color', 'w');
surf((geoParams(2).steps * 2e3) + 4, (geoParams(1).steps * 2e3) + 14, ...
  abs(s11));
set(gca, 'FontSize', fontsize);
xlabel('b (mm)');
ylabel('a (mm)');
zlabel('|S_{11}|');
axis([1 7 10 18 0 1]);
view([az el]);
set(gca, 'xtick', 1:2:9);
set(gca, 'ytick', 10:2:18);
set(gca, 'ztick', 0:0.2:1);


load f_11;
figHandle = figure;
set(figHandle, 'color', 'w');
surf((geoParams(2).steps * 2e3) + 4, (geoParams(1).steps * 2e3) + 14, ...
  abs(s11));
set(gca, 'FontSize', fontsize);
xlabel('b (mm)');
ylabel('a (mm)');
zlabel('|S_{11}|');
axis([1 7 10 18 0 1]);
view([az el]);
set(gca, 'xtick', 1:2:9);
set(gca, 'ytick', 10:2:18);
set(gca, 'ztick', 0:0.2:1);

load f_14;
figHandle = figure;
set(figHandle, 'color', 'w');
surf((geoParams(2).steps * 2e3) + 4, (geoParams(1).steps * 2e3) + 14, ...
  abs(s11));
set(gca, 'FontSize', fontsize);
xlabel('b (mm)');
ylabel('a (mm)');
zlabel('|S_{11}|');
axis([1 7 10 18 0 1]);
view([az el]);
set(gca, 'xtick', 1:2:9);
set(gca, 'ytick', 10:2:18);
set(gca, 'ztick', 0:0.2:1);

load f_17;
figHandle = figure;
set(figHandle, 'color', 'w');
surf((geoParams(2).steps * 2e3) + 4, (geoParams(1).steps * 2e3) + 14, ...
  abs(s11));
set(gca, 'FontSize', fontsize);
xlabel('b (mm)');
ylabel('a (mm)');
zlabel('|S_{11}|');
axis([1 7 10 18 0 1]);
view([az el]);
set(gca, 'xtick', 1:2:9);
set(gca, 'ytick', 10:2:18);
set(gca, 'ztick', 0:0.2:1);

%% test
load f_14;
s11_o6 = s11;
load f_14_o8;
figure;
surf((geoParams(2).steps * 2e3) + 4, (geoParams(1).steps * 2e3) + 14, ...
  abs(s11 - s11_o6));

%%
m=6;
p=3;
total = 0;
for oCnt = 0:m
  total = total + factorial(oCnt+p-1) / factorial(oCnt) / factorial(p-1);
end
total




