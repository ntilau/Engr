close all;
clear all;

tic;

linewidth = 3;
fontsize = 24;

set(0,'DefaultFigureWindowStyle','docked');

load remesh;

% figure;
% plot(sTest{1}, abs(s11(:, 1)));
% grid;
% hold;

fNameHFSS_Results = 'lenseQuarterShortModifiedShort';
run(fNameHFSS_Results);

% s11hfss = zeros(length(s1), 1);
% for s1Cnt = 1:length(s1)
%   s11hfss(s1Cnt) = S_HFSS{s1Cnt}(1, 1);
% end
% inRange = find((s1 >= -4) & (s1 <= 4));
% plot(s1(inRange) * 1e-3, abs(s11hfss(inRange)), 'rd');
% 
% % error plot
% figHandle = figure;
% set(figHandle, 'color', 'w');
% posS_Test1 = zeros(length(inRange), 1);
% for pntCnt = 1:length(inRange)
%   posS_Test1(pntCnt) = find(sTest{1} == ...
%     (s1(inRange(pntCnt)) * 1e-3));
% end
% plot(s1(inRange), abs(s11hfss(inRange) - s11(posS_Test1, 1)), ...
%   'LineWidth', linewidth);
% grid;
% set(gca, 'FontSize', fontsize);
% xlabel('Frequency (GHz)');
% ylabel('|Error|');

% load dataPic1;

figHandle = figure;
set(figHandle, 'color', 'w');
plot((sTest{1} * 2e3) + 14, abs(s11(:, 1)), 'LineWidth', linewidth);
grid;
hold;
% fNameHFSS_Results = 'lenseQuarterShortModified';
% run(fNameHFSS_Results);
s11hfss = zeros(length(s1), 1);
for s1Cnt = 1:length(s1)
  s11hfss(s1Cnt) = S_HFSS{s1Cnt}(1, 1);
end
inRange = find((s1 >= -2) & (s1 <= 2));
plot(s1(inRange) * 2 + 14, abs(s11hfss(inRange)), 'rd', ...
  'LineWidth', linewidth);
set(gca, 'FontSize', fontsize);
set(gca, 'xtick', 10:2:18);
set(gca, 'ytick', 0:0.2:1);
xlabel('a (mm)');
ylabel('|S_{11}|');
axis([10 18 0 1]);
legend('Deformation', 'Remeshing', 'Location', 'NorthEast');
% print -dmeta -r600 pic1

% error plot
figHandle = figure;
set(figHandle, 'color', 'w');
posS_Test1 = zeros(length(inRange), 1);
for pntCnt = 1:length(inRange)
  posS_Test1(pntCnt) = find(sTest{1} == ...
    (s1(inRange(pntCnt)) * 1e-3));
end
plot(s1(inRange) * 2 + 14, abs(s11hfss(inRange) - s11(posS_Test1, 1)), ...
  'LineWidth', linewidth);
grid;
set(gca, 'FontSize', fontsize);
set(gca, 'xtick', 2:2:18);
set(gca, 'ytick', 0:0.005:0.02);
xlabel('a (mm)');
ylabel('|Error|');
axis([10 18 0 0.02]);
% print -dmeta -r600 epic1

%% new remeshing pic

newMeshData = load('newMeshResults');

figHandle = figure;
set(figHandle, 'color', 'w');
plot((newMeshData.deltaA * 2e3) + 14, abs(newMeshData.sVal), 'LineWidth', linewidth);
grid;
hold;
remeshData = load('remeshingResultsNew');
plot(remeshData.a, abs(remeshData.sVal), 'rd', 'LineWidth', linewidth);
set(gca, 'FontSize', fontsize);
set(gca, 'xtick', 10:2:18);
set(gca, 'ytick', 0:0.2:1);
xlabel('a (mm)');
ylabel('|S_{11}|');
axis([10 18 0 1]);
legend('Deformation', 'Remeshing', 'Location', 'NorthEast');
% print -dmeta -r600 pic1
% print -deps remesh

% error plot
figHandle = figure;
set(figHandle, 'color', 'w');
posS_Test1 = zeros(length(inRange), 1);
plot(remeshData.a, abs(remeshData.sVal - newMeshData.sVal), 'LineWidth', linewidth);
grid;
set(gca, 'FontSize', fontsize);
set(gca, 'xtick', 2:2:18);
% set(gca, 'ytick', 0:0.005:0.02);
xlabel('a (mm)');
ylabel('|Error|');
% axis([10 18 0 0.02]);
% print -deps remeshError
