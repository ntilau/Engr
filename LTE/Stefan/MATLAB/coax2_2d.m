% 2D-Plots of coax2
close all;
clear all;

fontsize = 24;
linewidth = 2.5;


filename = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_10_pN_simple\s_11_f_1e+009_4.5e+009_1001_m_1_1_1.txt';
[mus, freqs, s2] = readSparamMORs11(filename);
figHandle = figure;
plot(freqs*1e-9, abs(s2), 'LineWidth', linewidth)
hold;

%filename = 'C:\work\examples\DualModeDielWG_Filter\DualModeDielWG_Filter_1.3e+010_1_10\sParam.txt';
%filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_15_real\sParam.txt';
filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_pN\sParam.txt';
filename = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_10_pN\s_11_f_1e+009_4.5e+009_1001_m_1_1_1.txt';

%filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_pN\s_11_m_f_1e+008_2e+005_4.5e+009_m_3_0.03_3.txt';
% filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_empty\s_11_m_f_1e+008_2e+006_4.5e+009_m_1_0.02_1.txt';
%[m, f, s, de] = readS_ParamDetOld(filename);
[m, f, s, de] = readSparamMOR(filename);

set(figHandle,'color','w');
plot(f*1e-9, abs(s), 'r-', 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);
grid;

% analytical solution
eta0 = 376.73031346177066;
c = 299792458.00000000;
pi_ = 3.1415926535897931;
% analytical calculation of reflection coefficent
len1=0.05;
len2=0.025;
k0 = 2*pi_*f/c;
zW1 = ones(length(m), length(k0)).*eta0;
%zW2 = ones(length(mu), length(k0)).*(eta0/2));
zW2 = ones(length(m), length(k0)).*(eta0/(2));

for row = 1:length(m)
    zW2(row,:) = zW2(row,:).*sqrt(m(row));
end

gamma1 = zeros(length(m), length(k0));
gamma2 = zeros(length(m), length(k0));
for row=1:length(m)
    gamma1(row,:) = j*k0.';
    for col=1:length(k0)
        gamma2(row,col) = j*k0(col)*2.*sqrt(m(row));
    end
end

rho0 = (zW1-zW2)./(zW1+zW2).*ones(length(m), length(k0));
rhoLen = rho0.*exp(2*gamma2*len1);
zLen = zW2.*(1+rhoLen)./(1-rhoLen);

rho0_1 = (zLen - zW1)./(zLen + zW1);
rhoLen_1 = rho0_1.*exp(2*gamma1*len2);

plot(f*1e-9, abs(rhoLen_1), 'g', 'LineWidth', linewidth)

legend('Old approach', 'New approach', 'Analytical solution');
%title('\mu_r = 1');


figHandle = figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compare to unstable method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_10_pN_simple\s_11_f_1e+009_4.5e+009_1001_m_1_1_1.txt';

%filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_pN\s_11_m_f_1e+008_2e+005_4.5e+009_m_3_0.03_3.txt';
% filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_empty\s_11_m_f_1e+008_2e+006_4.5e+009_m_1_0.02_1.txt';
%[m, f, s, de] = readS_ParamDetOld(filename);
[mus, freqs, sU] = readSparamMORs11(filename);
error2 = abs(sU-conj(rhoLen_1));
semilogy(freqs*1e-9, error2, 'LineWidth', linewidth);
grid;
hold;

fontsize = 24;
linewidth = 2.5;

%figHandle = figure;
set(figHandle,'color','w');
%plot(f*1e-9, abs(s), 'LineWidth', linewidth);

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stable method 
%%%%%%%%%%%%%%%%%%%%%%%%%%
%error = abs(s-rhoLen_1);
error = abs(s-conj(rhoLen_1));
semilogy(f*1e-9, error, 'r-', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize);
% grid;
%axis([f(1)*1e-9 f(end)*1e-9 1e-5 1e-2])
% plot(f, error);
% axis([f(1) f(end) 0 0.2e-1])
set(figHandle,'color','w');
xlabel('Frequency (GHz)', 'FontSize', fontsize);
%ylabel('|Error S_{11}| with analytical solution', 'FontSize', fontsize);
ylabel('|Error|', 'FontSize', fontsize);
%hold;
legend('Old approach', 'New approach');
%title('error at \mu_r = 1');
%grid;

%% Fig. for MCMDS 2007
figHandle = figure;
semilogy(f*1e-9, error, 'r-', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error S_{11}|', 'FontSize', fontsize);
set(figHandle,'color','w');
axis([1 4.5 1e-5 1e-2]);



%%


filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_15\s11fast.txt';
[fr abs_s] = readHFSS(filename);
fr = fr*1e9;
figure;
%plot(fr, abs_s, 'r', 'o')
semilogy(fr*1e-9, abs(abs_s-abs(s)), 'LineWidth', linewidth)
set(gca,'FontSize',fontsize);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('Error |S_{11}| with discrete sweep', 'FontSize', fontsize);
grid;


% filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_15\s11discrete.txt';
% [fr abs_s] = readHFSS(filename);
% fr = fr*1e9;
% figure;
% %plot(fr, abs_s, 'r', 'o')
% 
% for k = 1:length(fr)
%     s_da(k) = s(find( f == fr(k)));
% end
% 
% hold;
% semilogy(fr, abs(abs_s-abs(s_da)), 'x')
