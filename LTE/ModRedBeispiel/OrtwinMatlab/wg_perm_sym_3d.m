% 3D-plots of wg_perm_sym

%close all;
clear all;

fontsize = 20;

%filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10\s11_f_8e9_36e6_17e9_m_1_0p076_20.txt';
filename = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_12_pN\s_f_8e9_36e6_17e9_m_1_0p076_20.txt';
[mus, freqs, s, de] = readS_ParamDet(filename);

figHandle = figure
set(figHandle,'color','w');
limit = 2;
abs_s = abs(s);
for col = 1:length(freqs)
    for row = 1:length(mus)
        if(abs_s(row,col) > limit)
            abs_s(row,col) = NaN;
        end
    end
end

surf(freqs*1e-9, mus, abs_s);
axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end) 0 1.1])
set(gca,'FontSize',fontsize)
xlabel('f (GHz)', 'FontSize', fontsize);
caxis([0 1.1]);
%ylabel('Relative electric permittivity', 'FontSize', fontsize);
ylabel('\epsilon_{r}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
colorbar();
view([0 90]);


