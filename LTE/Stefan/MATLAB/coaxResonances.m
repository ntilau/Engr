% This script calculates the imput impedance of the short circuited 
% and open circuited coaxial cable with insert.

close all;

fontsize = 24;
linewidth = 2.5;

eta0 = 376.73031346177066;
c0 = 299792.458e3;

f = 0.1e9:0.001e9:4.5e9;

l_1 = 0.025;
l_2 = 0.05;

eps_r1 = 1;
mu_r1 = 1;

eps_r2 = 4;
mu_r2 = 1;

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

figHandle = figure;
set(figHandle,'color','w');
plot(f*1e-9,abs(Z_3), 'LineWidth', linewidth);
% plot(f*1e-9,rho_5, 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('Input Impedance (Ohms)', 'FontSize', fontsize)
grid;
hold;

figHandle = figure;
plot(f*1e-9,real(rho_5));
grid;
ylabel('Reflection Coefficient');
xlabel('Frequency (GHz)', 'FontSize', fontsize);

% figHandle = figure;
% set(figHandle,'color','w');
% 
% rho_0 = -1; % short circuit
% rho_1 = rho_0*exp(-2j*beta_1*l_1);
% Z_1 = Z_w1*(1+rho_1)./(1-rho_1);
% rho_2 = (Z_1-Z_w2)./(Z_1+Z_w2);
% rho_3 = rho_2.*exp(-2j*beta_2*l_2);
% Z_2 = Z_w2*(1+rho_3)./(1-rho_3)
% rho_4 = (Z_2-Z_w1)./(Z_2+Z_w1);
% rho_5 = rho_4.*exp(-2j*beta_1*l_1);
% Z_3 = Z_w2*(1+rho_5)./(1-rho_5);
% plot(f*1e-9,abs(Z_3), 'LineWidth', linewidth);
% plot(f,rho_5, 'LineWidth', linewidth);

% % alternative way of computing
% Z_in0 = 0;
% Z_in1 = Z_w1.*(Z_in0+j*Z_w1*tan(beta_1*l_1))./...
%   (Z_w1+j*Z_in0*tan(beta_1*l_1));
% Z_in2 = Z_w2.*(Z_in1+j*Z_w2.*tan(beta_2*l_2))./...
%   (Z_w2+j*Z_in1.*tan(beta_2*l_2))
% Z_in3 = Z_w1.*(Z_in2+j*Z_w1.*tan(beta_1*l_1))./...
%   (Z_w1+j*Z_in2.*tan(beta_1*l_1));
% figHandle = figure;
% set(figHandle,'color','w');
% plot(f*1e-9,abs(Z_in3), 'LineWidth', linewidth);
% grid;

