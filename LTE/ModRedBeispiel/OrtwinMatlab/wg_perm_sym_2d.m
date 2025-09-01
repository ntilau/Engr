% 2D-Plots of wg_perm_sym

close all;
clear all;

linewidth = 2.5;
fontsize = 20;
stepDisc = 3;

% with losses

% magnitude
figHandle = figure;
set(figHandle,'color','w');
% subplot(2,1,2);

filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_1001_m_5_5_1.txt';
[m, f, s_, de] = readSparamMOR(filename);
plot(f*1e-9, abs(s_)', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize)
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
grid;
hold;

filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_1001_m_5-1i_5-1i_1.txt';
[m, f, s_, de] = readSparamMOR(filename);
plot(f*1e-9, abs(s_)', 'LineWidth', linewidth, 'Color','magenta');

filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_1001_m_5-5i_5-5i_1.txt';
[m, f, s_, de] = readSparamMOR(filename);
plot(f*1e-9, abs(s_)', 'LineWidth', linewidth, 'Color','green');

filename = 'C:\work\examples\wg_perm_sym\results\s_wg_perm_sym_mu_5_disc.txt';
[fr sMatrices] = readSparamWaveSolver(filename);
s11 = reshape(sMatrices(1,1,:), [length(fr) 1]);
pos = find(fr);
plot(fr(pos(1:stepDisc:end))*1e-9, abs(s11(pos(1:stepDisc:end))), ...
  'o', 'Color','red', 'LineWidth', linewidth);

filename = 'C:\work\examples\wg_perm_sym\results\s_wg_perm_sym_mu_(10,-1)_disc.txt';
filename = 'C:\work\examples\wg_perm_sym\results\s_m_(10,-5)_disc.txt';
filename = 'C:\work\examples\wg_perm_sym\results\s_wg_perm_sym_m_(5,-5).txt';
[fr sMatrices] = readSparamWaveSolver(filename);
s11 = reshape(sMatrices(1,1,:), [length(fr) 1]);
pos = find(fr);
plot(fr(pos(1:stepDisc:end))*1e-9, abs(s11(pos(1:stepDisc:end))), ...
  'd', 'Color','black', 'LineWidth', linewidth);

axis([fr(1)*1e-9 fr(end)*1e-9 0 1]);
legend('\epsilon_r{''''}=0', '\epsilon_r{''''}=1', '\epsilon_r{''''}=5',...
  '\epsilon_r{''''}=0 discrete', '\epsilon_r{''''}=5 discrete', ...
  'Location', 'NorthWest');

% print -djpeg100 CompAbsS11.jpg

% phase
figHandle = figure;
set(figHandle,'color','w');
filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_1001_m_5_5_1.txt';
[m, f, s_, de] = readSparamMOR(filename);
plot(f*1e-9, angle(s_)*180/pi', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize-2)
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('arg S_{11} (Degree)', 'FontSize', fontsize);
grid;
hold;

filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_1001_m_5-1i_5-1i_1.txt';
[m, f, s_, de] = readSparamMOR(filename);
plot(f*1e-9, angle(s_)*180/pi', 'LineWidth', linewidth, 'Color','magenta');

filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_1001_m_5-5i_5-5i_1.txt';
[m, f, s_, de] = readSparamMOR(filename);
plot(f*1e-9, angle(s_)*180/pi', 'LineWidth', linewidth, 'Color','green');

filename = 'C:\work\examples\wg_perm_sym\results\s_wg_perm_sym_mu_5_disc.txt';
[fr sMatrices] = readSparamWaveSolver(filename);
s11 = reshape(sMatrices(1,1,:), [length(fr) 1]);
pos = find(fr);
plot(fr(pos(1:stepDisc:end))*1e-9, angle(s11(pos(1:stepDisc:end)))*180/pi, ...
  'o', 'Color','red', 'LineWidth', linewidth);

filename = 'C:\work\examples\wg_perm_sym\results\s_wg_perm_sym_mu_(10,-1)_disc.txt';
filename = 'C:\work\examples\wg_perm_sym\results\s_m_(10,-5)_disc.txt';
filename = 'C:\work\examples\wg_perm_sym\results\s_wg_perm_sym_m_(5,-5).txt';
[fr sMatrices] = readSparamWaveSolver(filename);
s11 = reshape(sMatrices(1,1,:), [length(fr) 1]);
pos = find(fr);
plot(fr(pos(1:stepDisc:end))*1e-9, angle(s11(pos(1:stepDisc:end)))*180/pi, ...
  'd', 'Color','black', 'LineWidth', linewidth);

axis([fr(1)*1e-9 fr(end)*1e-9 -180 180]);
legend('\epsilon_r{''''}=0', '\epsilon_r{''''}=1', '\epsilon_r{''''}=5',...
  '\epsilon_r{''''}=0 discrete', '\epsilon_r{''''}=5 discrete', ...
  'Location', 'NorthWest');

% error plot
figHandle = figure;
set(figHandle,'color','w');

filename = 'C:\work\examples\wg_perm_sym\results\s_m_(10,-5)_disc.txt';
filename = 'C:\work\examples\wg_perm_sym\results\s_wg_perm_sym_m_(5,-5).txt';
[fr sMatrices] = readSparamWaveSolver(filename);
s11 = reshape(sMatrices(1,1,:), [length(fr) 1]);
pos = find(fr);

filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_151_m_10-5i_10-5i_1.txt';
filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_151_m_5-5i_5-5i_1.txt';
[m, f, s11rom, s12] = readSparamMOR(filename);
semilogy(f*1e-9, abs(s11-s11rom.'), 'LineWidth', linewidth, 'Color','blue');
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error S_{11}|', 'FontSize', fontsize);
axis([f(1)*1e-9 f(end)*1e-9 1e-7 1e-5]);
set(gca,'FontSize',fontsize);
% grid;

