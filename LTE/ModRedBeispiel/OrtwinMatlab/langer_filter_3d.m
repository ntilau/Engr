close all;
clear all;

fontsize = 24;
% filename = 'C:\work\examples\langer_dual_coarse\results\langer_dual_coarse_7e+009_38_13\sParam_total.txt';
% [mus, freqs, s, de] = readS_ParamDet(filename);
% 
% 
% 
% figure
% surf(freqs*1e-9, mus, abs(s))
% title(filename)
% axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end)])
% xlabel('frequency [GHz]', 'FontSize', fontsize);
% ylabel('relative electric permittivity', 'FontSize', fontsize);
% zlabel('|S_{11}|', 'FontSize', fontsize);
% view([-119.00 68.00]);


filename = 'C:\work\examples\langer_dual_coarse\results\langer_dual_coarse_7e+009_38_10\s11_f_4e9_3e7_10e9_m_1_0p195_40.txt';
filename = 'C:\work\examples\langer_dual_coarse\results\langer_dual_coarse_7e+009_38_10_opt_ortho\s_f_4e+009_2.4e+007_1e+010_m_1_0.156_40.txt';
[mus, freqs, s, de] = readS_ParamDet(filename);

figHandle = figure;
set(figHandle,'color','w');
surf(freqs*1e-9, mus, abs(s))
%title(filename)
axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end)])
xlabel('Frequency (GHz)', 'FontSize', fontsize);
%ylabel('Relative electric permittivity', 'FontSize', fontsize);
ylabel('\epsilon_{r}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
view([-6 74]);
