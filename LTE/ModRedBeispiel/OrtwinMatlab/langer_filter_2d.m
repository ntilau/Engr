% 2D-Plots of langer filter

close all;
clear all;
fontsize = 24;
linewidth = 3;


% filename = 'C:\work\examples\langer_dual_coarse\results\sParam_dicrete_eps38_clean.txt';
% [freqs, s] = readS_ParamOurs(filename);

% filename = 'C:\work\examples\langer_dual_coarse\results\langer_dual_coarse_7e+009_38_13\sParam_eps38.txt';
% [mus, freqs, s, de] = readS_ParamDet(filename);
% 
% figure
% plot(freqs, abs(s), 'LineWidth', linewidth)
% %title(filename)
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% title('\epsilon_r = 38', 'FontSize', fontsize);
% grid;
% %caxis([0 1])
% 
% % filename = 'C:\work\examples\langer_dual_coarse\hfss\eps38s11mag.txt';
% % [fr abs_s] = readHFSS(filename);
% % hold;
% % plot(fr, abs_s, 'r', 'LineWidth', linewidth)
% % 
% % figure
% % error = abs(abs(s)-abs_s);
% % semilogy(fr, error, 'LineWidth', linewidth);
% % %axis([f(1)*1e-9 f(end)*1e-9 1e-4 1e-2])
% % xlabel('Frequency (GHz)', 'FontSize', fontsize);
% % ylabel('Error |S_{11}| with discrete sweep', 'FontSize', fontsize);
% % title('Error at \epsilon_r = 38', 'FontSize', fontsize);
% % grid;
% 
% filename = 'C:\work\examples\langer_dual_coarse\results\sParam_discrete_eps38_short.txt';
% [freq, sd] = readS_ParamOurs(filename);
% hold
% plot(freq, sd, 'r', 'LineWidth', linewidth)
% 
% figure
% startPos = find(freqs==8e9);
% error = abs(abs(s(startPos:end))-sd);
% semilogy(freqs(startPos:end), error, 'LineWidth', linewidth);
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('Error |S_{11}| with discrete sweep', 'FontSize', fontsize);
% title('Error at \epsilon_r = 38', 'FontSize', fontsize);
% grid;
% 
% filename = 'C:\work\examples\langer_dual_coarse\results\langer_dual_coarse_7e+009_20_13\sParam_eps38.txt';
% [mus, freqs, s, de] = readS_ParamDet(filename);
% 
% figure
% plot(freqs*1e-9, abs(s), 'LineWidth', linewidth)
% %title(filename)
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% title('\epsilon_r = 38', 'FontSize', fontsize);
% grid;
% %caxis([0 1])
% 
% filename = 'C:\work\examples\langer_dual_coarse\hfss\eps38s11mag.txt';
% [fr abs_s] = readHFSS(filename);
% hold;
% plot(fr, abs_s, 'r', 'LineWidth', linewidth)
% 
% figure
% error = abs(abs(s)-abs_s);
% semilogy(fr, error, 'LineWidth', linewidth);
% %axis([f(1)*1e-9 f(end)*1e-9 1e-4 1e-2])
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('Error |S_{11}| with discrete sweep', 'FontSize', fontsize);
% title('Error at \epsilon_r = 38', 'FontSize', fontsize);
% grid;
% 
% 
% 
% filename = 'C:\work\examples\langer_dual_coarse\results\langer_dual_coarse_7e+009_38_13\sParam_eps11,8.txt';
% [mus, freqs, s, de] = readS_ParamDet(filename);
% 
% figure
% plot(freqs, abs(s), 'LineWidth', linewidth)
% %title(filename)
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% title('\epsilon_r = 11,8', 'FontSize', fontsize);
% grid;
% %caxis([0 1])
% 
% filename = 'C:\work\examples\langer_dual_coarse\hfss\eps11_8s11mag.txt';
% [fr abs_s] = readHFSS(filename);
% fr = fr*1e9;
% hold;
% plot(fr, abs_s, 'r', 'LineWidth', linewidth)
% 
% figure
% error = abs(abs(s)-abs_s);
% semilogy(fr, error, 'LineWidth', linewidth);
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('Error |S_{11}| with discrete sweep', 'FontSize', fontsize);
% title('Error at \epsilon_r = 11.8', 'FontSize', fontsize);
% grid;

filename = 'C:\work\examples\langer_dual_coarse\results\langer_dual_coarse_7e+009_38_10\s11_f_4e9_12e6_10e9_m_5_0_5.txt';
[mus, freqs, s, de] = readS_ParamDet(filename);

figHandle = figure
set(figHandle,'color','w');
plot(freqs*1e-9, abs(s), 'LineWidth', linewidth)
set(gca,'FontSize',fontsize)
%title(filename)
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
%title('\epsilon_r = 5', 'FontSize', fontsize);
grid;
hold;
%caxis([0 1])

% filename = 'C:\work\examples\langer_dual_coarse\hfss\eps5s11mag.txt';
% [fr abs_s] = readHFSS(filename);
% fr = fr*1e9;
% plot(fr, abs_s, 'g', 'LineWidth', linewidth)

% figure
% error = abs(abs(s)-abs_s);
% semilogy(fr, error, 'LineWidth', linewidth);
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('Error |S_{11}| with discrete sweep', 'FontSize', fontsize);
% title('Error at \epsilon_r = 5', 'FontSize', fontsize);
% grid;

%filename = 'C:\work\examples\langer_dual_coarse\results\sParam_discrete_eps5_short_1.txt';
filename = 'C:\work\examples\langer_dual_coarse\results\s11_disc_f_4e9_12e6_10e9_eps_5.txt';
[freqs, sd] = readSdiscrete(filename);
plot(freqs*1e-9, abs(sd), 'rd', 'LineWidth', linewidth)

figHandle = figure
set(figHandle,'color','w');
%startPos = find(fr==8e9);
%error = abs(abs(s(startPos:end))-sd);
error = abs(s-sd);
semilogy(freqs*1e-9, error, 'LineWidth', linewidth);
set(gca,'FontSize',fontsize)
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
%title('Error at \epsilon_r = 5', 'FontSize', fontsize);
grid;

figHandle = figure;
set(figHandle,'color','w');
subplot(2,1,1);
plot(freqs*1e-9, abs(s), 'LineWidth', linewidth);
grid;
hold;
plot(freqs*1e-9, abs(sd), 'rd', 'LineWidth', linewidth)
set(gca,'FontSize',fontsize)
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
legend('ROM', 'Discrete', 'Location', 'SouthWest');

subplot(2,1,2);
semilogy(freqs*1e-9, error, 'LineWidth', linewidth);
set(gca,'FontSize',fontsize)
grid;
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);

