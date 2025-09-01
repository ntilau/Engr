close all;
clear;

load C:\work\examples\Vigoni\DDM_Saar\results\freqEpsMu_6.mat

fontsize = 12;
figHandle = figure;
set(figHandle,'color','w');
ff = pcolor(real(results.param{paramId(1)}.Vals) * 1e-9, real(results.param{paramId(2)}.Vals), ...
  20*log10(abs(sVal)));
set(ff, 'EdgeColor', 'none', 'FaceColor', 'interp');
colormap('Gray');
colorbar;
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('\epsilon_r', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);

figHandle = figure;
set(figHandle,'color','w');
ff = pcolor(real(results.param{paramId(1)}.Vals) * 1e-9, real(results.param{paramId(2)}.Vals), abs(sVal - s11analytic.'));
% ff = contour(real(results.param{paramId(1)}.Vals) * 1e-9, real(results.param{paramId(2)}.Vals), abs(sVal - s11analytic.'));
set(ff, 'EdgeColor', 'none', 'FaceColor', 'interp');
colormap('Gray');
colorbar;
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('\epsilon_r', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);
brighten(0.5);