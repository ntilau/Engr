% 3D-Plots of DualModeDielWG_Filter

close all;
clear all;

fontsize = 20;

%filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_12\sParam.txt';
%filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\sParam.txt';
filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10_p2_old\s_f_1e8_1596e5_4e10_m_1_0p196_50.txt';
%filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_12\sParam3d.txt';
%filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\sParam.txt';
%filename = 'Z:\ortwin\dualmodedielwg_filter_1.2e+010_21_10\sParam.txt';
%filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\sParam.txt';
%filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10_p2\sParam.txt';
filename = 'C:\work\examples\DualModeDielWG_Filter\dualmodedielwg_filter_1.2e+010_21_10_opt_new\sParam.txt';
%filename = 'C:\work\examples\DualModeDielWG_Filter\DualModeDielWG_Filter_1.2e+010_21_10\sParam.txt';
filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\s_f_1e+009_1.95e+008_m_1_0.245_50.txt';
%filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_3e+010_30_10\s_f_1e+009_1.95e+008_m_1_0.245_50.txt';
filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_2.5e+010_25_10\s_f_1e+009_1.95e+008_m_1_0.245_50.txt';
filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_2e+010_21_10_opt_ortho\s_f_1e+009_1.95e+008_4e+010_m_1_0.245_50.txt';
% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_2e+010_21_10_opt_oInt\s_f_1e+009_1.95e+008_4e+010_m_1_0.245_50.txt';
filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_2e+010_21_10_opt_oExt\s_f_1e+009_1.95e+008_4e+010_m_1_0.245_50.txt';

[mus, freqs, s, de] = readS_ParamDet(filename);

figHandle = figure;
set(figHandle,'color','w');
limit = 1.3;
abs_s = abs(s);
% for col = 1:length(freqs)
%     for row = 1:length(mus)
%         if(abs_s(row,col) > limit)
%             abs_s(row,col) = NaN;
%         end
%     end
% end
surf(freqs*1e-9, mus, abs_s);
axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end)])
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('\epsilon_{r}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
view([-6 74]);

figHandle = figure;
set(figHandle,'color','w');
% limit = 1.3;
% abs_s = abs(s);
% for col = 1:length(freqs)
%     for row = 1:length(mus)
%         if(abs_s(row,col) > limit)
%             abs_s(row,col) = NaN;
%         end
%     end
% end
surf(freqs*1e-9, mus, abs_s);
axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end)])
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('\epsilon_{r}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
view([0 90]);
