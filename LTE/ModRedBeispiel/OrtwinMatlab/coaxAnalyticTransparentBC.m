% close all;

fontsize = 24;
linewidth = 2.5;

eta0 = 376.73031346177066;
c0 = 299792.458e3;

f = 0.1e9:0.001e9:4.5e9;

l_1 = 0.025;
l_2 = 0.05;

eps_r1 = 1;
mu_r1 = 1;

eps_r2 = 1-0.1j;
mu_r2 = 4;

beta_1 = 2*pi*f/c0*sqrt(mu_r1*eps_r1);
beta_2 = 2*pi*f/c0*sqrt(mu_r2*eps_r2);
Z_w1 = eta0*sqrt(mu_r1/eps_r1);
Z_w2 = eta0*sqrt(mu_r2/eps_r2);

rho_0 = 0;  % no reflections
rho_1 = rho_0*exp(-2j*beta_1*l_1);
Z_1 = Z_w1*(1+rho_1)./(1-rho_1);
rho_2 = (Z_1-Z_w2)./(Z_1+Z_w2);
rho_3 = rho_2.*exp(-2j*beta_2*l_2);
Z_2 = Z_w2*(1+rho_3)./(1-rho_3);
rho_4 = (Z_2-Z_w1)./(Z_2+Z_w1);
rho_5 = rho_4.*exp(-2j*beta_1*l_1);
Z_3 = Z_w2*(1+rho_5)./(1-rho_5);

figHandle = figure;
set(figHandle,'color','w');
plot(f*1e-9,abs(Z_3), 'LineWidth', linewidth);
% plot(f*1e-9,rho_5, 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('Input Impedance (Ohms)', 'FontSize', fontsize)
grid;
hold;

figHandle = figure;
plot(f*1e-9,abs(rho_5));
grid;
