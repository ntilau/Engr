% 2D-Plots of wg_perm_sym

close all;
clear all;

linewidth = 2.5;
fontsize = 20;
stepDisc = 1;

% with losses

% magnitude
figHandle = figure;
set(figHandle,'color','w');
% subplot(2,1,2);

filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.4e+010_101_m_22.5_22.5_1.txt';
[m, f, s_, de] = readSparamMOR(filename);
plot(f*1e-9, abs(s_)', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize)
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
grid;
hold;

% filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_(30,0)_10\s_11_f_8e+009_1.4e+010_101_m_40_40_1.txt';
% [m, f, s_, de] = readSparamMOR(filename);
% plot(f*1e-9, abs(s_)', 'LineWidth', linewidth, 'Color', 'green');

% filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_(30,0)_12\s_11_f_8e+009_1.4e+010_101_m_20_20_1.txt';
% [m, f, s_, de] = readSparamMOR(filename);
% plot(f*1e-9, abs(s_)', 'LineWidth', linewidth, 'Color', 'black');

filename = 'C:\work\examples\wg_perm_sym\results\sPar_wg_perm_sym_mu22.5_disc.txt';
[fr sMatrices] = readSparamWaveSolver(filename);
s11 = reshape(sMatrices(1,1,:), [length(fr) 1]);
pos = find(fr);
plot(fr(pos(1:stepDisc:end))*1e-9, abs(s11(pos(1:stepDisc:end))), ...
  'o', 'Color','red', 'LineWidth', linewidth);

axis([fr(1)*1e-9 fr(end)*1e-9 0 1]);

% print -djpeg100 CompAbsS11% error plot
% figHandle = figure;
% set(figHandle,'color','w');
% 
% filename = 'C:\work\examples\wg_perm_sym\results\s_m_(10,-5)_disc.txt';
% filename = 'C:\work\examples\wg_perm_sym\results\s_wg_perm_sym_m_(5,-5).txt';
% [fr sMatrices] = readSparamWaveSolver(filename);
% s11 = reshape(sMatrices(1,1,:), [length(fr) 1]);
% pos = find(fr);
% 
% filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_151_m_10-5i_10-5i_1.txt';
% filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_151_m_5-5i_5-5i_1.txt';
% [m, f, s11rom, s12] = readSparamMOR(filename);
% semilogy(f*1e-9, abs(s11-s11rom.'), 'LineWidth', linewidth, 'Color','blue');
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('|Error S_{11}|', 'FontSize', fontsize);
% axis([f(1)*1e-9 f(end)*1e-9 1e-7 1e-5]);
% set(gca,'FontSize',fontsize);
% .jpg

% grid;
% 
