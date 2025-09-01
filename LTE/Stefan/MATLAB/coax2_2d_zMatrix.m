% 2D-Plots of coax2 to show inner resonances
close all;
clear all;

set(0,'DefaultFigureWindowStyle','docked');
%filename = 'C:\work\examples\DualModeDielWG_Filter\DualModeDielWG_Filter_1.3e+010_1_10\sParam.txt';
%filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_15_real\sParam.txt';
filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_pN\sParam.txt';
filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_pN\s_11_m_f_1e+008_2e+005_4.5e+009_m_3_0.03_3.txt';
% filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_empty\s_11_m_f_1e+008_2e+006_4.5e+009_m_1_0.02_1.txt';
%[m, f, s, de] = readS_ParamDetOld(filename);
%[m, f, s, de] = readS_ParamDet(filename);
filename = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_10_pN\s_11_f_1e+009_4.5e+009_10001_m_2_7_1.txt';
[m, f, s, s12] = readSparamMOR(filename);

fontsize = 13;
linewidth = 2.5;

figHandle = figure;
set(gca,'FontSize',fontsize);
subplot(2,1,1)
set(figHandle,'color','w');
plot(f*1e-9, abs(s), 'g--', 'LineWidth', linewidth);
set(gca,'FontSize',fontsize);
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

hold;
plot(f*1e-9, abs(rhoLen_1), 'r', 'LineWidth', linewidth)
legend('Reduced model', 'Analytical solution');
%title('\mu_r = 1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analytic calculation of input impedance of open circuit transmission line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,2);

eta0 = 376.73031346177066;
c0 = 299792.458e3;

f = 1e9:0.001e9:4.5e9;

l_1 = 0.025;
l_2 = 0.05;

eps_r1 = 1;
mu_r1 = 1;

eps_r2 = 4;
mu_r2 = 2;

beta_1 = 2*pi*f/c0*sqrt(mu_r1*eps_r1);
beta_2 = 2*pi*f/c0*sqrt(mu_r2*eps_r2);
Z_w1 = eta0*sqrt(mu_r1/eps_r1);
Z_w2 = eta0*sqrt(mu_r2/eps_r2);

rho_0 = 1;  % open circuit
rho_1 = rho_0*exp(-2j*beta_1*l_1);
Z_1 = Z_w1*(1+rho_1)./(1-rho_1);
rho_2 = (Z_1-Z_w2)./(Z_1+Z_w2);
rho_3 = rho_2.*exp(-2j*beta_2*l_2);
Z_2 = Z_w2*(1+rho_3)./(1-rho_3);
rho_4 = (Z_2-Z_w1)./(Z_2+Z_w1);
rho_5 = rho_4.*exp(-2j*beta_1*l_1);
Z_3 = Z_w2*(1+rho_5)./(1-rho_5);

set(figHandle,'color','w');
set(gca,'FontSize',fontsize);
plot(f*1e-9,abs(Z_3), 'LineWidth', linewidth);
axis([f(1)*1e-9 f(end)*1e-9 0 1e5]);
% plot(f*1e-9,rho_5, 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('Input Impedance (Ohms)', 'FontSize', fontsize)
grid;
hold;
print -deps coaxImpCompMu2b.eps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figHandle = figure;
% %error = abs(s-rhoLen_1);
% error = abs(s-conj(rhoLen_1));
% semilogy(f*1e-9, error, 'LineWidth', linewidth);
% set(gca,'FontSize',fontsize);
% grid;
% %axis([f(1)*1e-9 f(end)*1e-9 1e-4 1e-2])
% % plot(f, error);
% % axis([f(1) f(end) 0 0.2e-1])
% set(figHandle,'color','w');
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% %ylabel('|Error S_{11}| with analytical solution', 'FontSize', fontsize);
% ylabel('|Error|', 'FontSize', fontsize);
% %title('error at \mu_r = 1');
% %grid;
% 
% 
% filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_15\s11fast.txt';
% [fr abs_s] = readHFSS(filename);
% fr = fr*1e9;
% figure;
% %plot(fr, abs_s, 'r', 'o')
% semilogy(fr*1e-9, abs(abs_s-abs(s)), 'LineWidth', linewidth)
% set(gca,'FontSize',fontsize);
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('Error |S_{11}| with discrete sweep', 'FontSize', fontsize);
% grid;


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
