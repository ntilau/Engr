close all;
clear all;

fontsize = 20;
fNameSpara = 'C:\work\examples\patch_antenna\patch_antenna_6e+009_e1_4_e2_2_new\s_11_f_3e+009_8e+009_101_e1_1_5_101_e2_1_1_1.txt';
[mus, freqs, s] = readSparamMORs11(fNameSpara);

figHandle = figure;
set(figHandle,'color','w');
abs_s = abs(s);
surf(freqs*1e-9, mus, abs_s);
%mesh(freqs*1e-9, mus, abs_s);
hold;
grid;
view([0 90]);
axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end) 0 1.1])
set(gca,'FontSize',fontsize)
xlabel('f (GHz)', 'FontSize', fontsize);
caxis([0 1.1]);
%ylabel('Relative electric permittivity', 'FontSize', fontsize);
ylabel('\epsilon_{r1}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
colorbar();
% %surf(freqs*1e-9, mus, 2+abs_s);
% mesh(freqs*1e-9, mus, 2+abs_s);
% 
% %surf(freqs*1e-9, mus, 4+abs_s);
% mesh(freqs*1e-9, mus, 4+abs_s);

fNameSpara = 'C:\work\examples\patch_antenna\patch_antenna_6e+009_e1_4_e2_2_new\s_11_f_3e+009_8e+009_101_e1_1_5_101_e2_2_2_1.txt';
[mus, freqs, s] = readSparamMORs11(fNameSpara);
figHandle = figure;
set(figHandle,'color','w');
abs_s = abs(s);
surf(freqs*1e-9, mus, abs_s);
%mesh(freqs*1e-9, mus, abs_s);
hold;
grid;
view([0 90]);
axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end) 0 1.1])
set(gca,'FontSize',fontsize)
xlabel('f (GHz)', 'FontSize', fontsize);
caxis([0 1.1]);
%ylabel('Relative electric permittivity', 'FontSize', fontsize);
ylabel('\epsilon_{r1}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
colorbar();


fNameSpara = 'C:\work\examples\patch_antenna\patch_antenna_6e+009_e1_4_e2_2_new\s_11_f_3e+009_8e+009_101_e1_1_5_101_e2_3_3_1.txt';
[mus, freqs, s] = readSparamMORs11(fNameSpara);

figHandle = figure;
set(figHandle,'color','w');
abs_s = abs(s);
surf(freqs*1e-9, mus, abs_s);
%mesh(freqs*1e-9, mus, abs_s);
hold;
grid;
view([0 90]);
axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end) 0 1.1])
set(gca,'FontSize',fontsize)
xlabel('f (GHz)', 'FontSize', fontsize);
caxis([0 1.1]);
%ylabel('Relative electric permittivity', 'FontSize', fontsize);
ylabel('\epsilon_{r1}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
colorbar();