
fontsize = 24;
linewidth = 1;

filename = 'C:\work\examples\DualModeDielWG_Filter\results\sParam_discrete.txt';
[fr sD] = readSdiscrete(filename);
figHandle = figure;
set(figHandle,'color','w');

plot(fr*1e-9, abs(sD), 'd', 'Color','red', 'LineWidth', linewidth);


filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\s_11_m_f_8e+009_6e+007_1.7e+010_m_6_0.076_6.txt';
figHandle = figure
set(figHandle,'color','w');
[m, fr, sc20, deC20] = readS_ParamDet(filename);
%semilogy(fr*1e-9, abs(sc20-sD), 'LineWidth', linewidth, 'Color','blue');
%plot(fr*1e-9, abs(sc20-sD), 'LineWidth', linewidth, 'Color','blue');
plot(fr*1e-9, abs(sc20), 'Color','blue', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize)

xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
