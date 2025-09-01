% 2D-Plots of dualModeDielWG_Filter
close all;
%clear all;

fontsize = 24;
linewidth = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename = 'C:\work\examples\coaxParam\coaxParam_1e+008_1_3\sParam.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% figure;
% plot(m, abs(s_));
% hold;
% filename = 'C:\work\examples\coaxParam\coaxParam_1e+008_1_6\sParam.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, abs(s_),'r');
% filename = 'C:\work\examples\coaxParam\coaxParam_1e+008_1_10\sParam.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, abs(s_),'g');
% filename = 'C:\work\examples\coaxParam\coaxParam_1e+008_1_5\sParam.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, abs(s_),'k');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10_Freq\sParamDiskret.txt';
[fr sD] = readSdiscrete(filename);
figHandle = figure;
set(figHandle,'color','w');
find_end = find(sD);
sD = sD(1:find_end(end));
fr = fr(1:find_end(end));
plot(fr*1e-9, abs(sD), 'd', 'Color','red', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize)
hold;

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10_p2_fine\sParamFine.txt';
[m, f, s_, de] = readS_ParamDet(filename);
plot(f*1e-9, abs(s_), 'LineWidth', linewidth, 'Color','green');

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\sParamFine20.txt';
[m, freq, s, de] = readS_ParamDet(filename);
plot(freq*1e-9, abs(s), 'LineWidth', linewidth, 'Color','blue');
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
grid;
axis([0 40 0 1.1]);
legend('Discrete', 'Order 10', 'Order 20', 'Location', 'SouthWest')


figHandle = figure;
set(figHandle,'color','w');
filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10_p2_fine\sParamCoarse.txt';
[m, fr, sc10, deC10] = readS_ParamDet(filename);
semilogy(fr*1e-9, abs(sc10-sD), 'LineWidth', linewidth, 'Color','green');
hold

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\sParamCoarse20.txt';
[m, fr, sc20, deC20] = readS_ParamDet(filename);
semilogy(fr*1e-9, abs(sc20-sD), 'LineWidth', linewidth, 'Color','blue');
set(gca,'FontSize',fontsize);

xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
grid;
axis([0 40 1e-10 1])
legend('Order 10', 'Order 20', 'Location', 'NorthWest');


filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10_Freq\sParamDiskret.txt';
[fr sD] = readSdiscrete(filename);
figHandle = figure;
set(figHandle,'color','w');
subplot(2,1,1)
find_end = find(sD);
sD = sD(1:find_end(end));
fr = fr(1:find_end(end));
plot(fr*1e-9, abs(sD), 'd', 'Color','red', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize)
hold;

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10_p2_fine\sParamFine.txt';
[m, f, s_, de] = readS_ParamDet(filename);
plot(f*1e-9, abs(s_), 'LineWidth', linewidth, 'Color','green');

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\sParamFine20.txt';
[m, freq, s, de] = readS_ParamDet(filename);
plot(freq*1e-9, abs(s), 'LineWidth', linewidth, 'Color','blue');
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
grid;
axis([0 40 0 1.1]);

legend('Discrete', 'Order 10', 'Order 20', 'Location', 'SouthWest')

%figure
filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10_p2_fine\sParamCoarse.txt';
[m, fr, sc10, deC10] = readS_ParamDet(filename);
subplot(2,1,2)
semilogy(fr*1e-9, abs(sc10-sD), 'LineWidth', linewidth, 'Color','green');
hold

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\sParamCoarse20.txt';
[m, fr, sc20, deC20] = readS_ParamDet(filename);
semilogy(fr*1e-9, abs(sc20-sD), 'LineWidth', linewidth, 'Color','blue');
set(gca,'FontSize',fontsize);

xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
grid;
axis([0 40 1e-10 1])
legend('Order 10', 'Order 20', 'Location', 'NorthWest');

% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\anst_f_14e9_30p952380952e6_4e10_m_15_0_15.dat';
% [fr abs_s] = readHFSS(filename);
% %fr = fr*1e9;
% figure;
% plot(fr, abs_s, 'LineWidth', linewidth, 'Color','red')

% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\sParam.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% figure;
% subplot(2,1,1)
% plot(f*1e-9, abs(s_), 'LineWidth', linewidth, 'Color','red');
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% grid;
% 
% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\sParam.txt';
% [m, f, s, de] = readS_ParamDet(filename);
% %figure;
% hold;
% plot(f*1e-9, abs(s), 'LineWidth', linewidth);
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% %grid;
% 
% %figure;
% subplot(2,1,2)
% semilogy(f*1e-9, abs(abs(s)-abs(s_)), 'LineWidth', linewidth)
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('|S_{11}|', 'FontSize', fontsize);
% grid;
% 
% 
% 
% % filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\anst_f_14e9_30p952380952e6_4e10_m_15_0_15.dat';
% % [fr abs_s] = readHFSS(filename);
% % fr = fr*1e9;
% % figure;
% % plot(fr, abs_s, 'LineWidth', linewidth, 'Color','red')
% % 
% % filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_12\sParam.txt';
% % [m, f, s, de] = readS_ParamDet(filename);
% % figure;
% % hold;
% % plot(f*1e-9, abs(s), 'LineWidth', linewidth);
% % xlabel('Frequency (GHz)', 'FontSize', fontsize);
% % ylabel('|S_{11}|', 'FontSize', fontsize);
% % grid;
% % 
% % figure;
% % semilogy(fr, abs(abs_s-abs(s)), 'x')