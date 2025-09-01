
l = 0.0004;
eps_0 = 8.854e-12;
mu_0 = 4*pi*1e-7;
%eps_r = 114.64;
mu_r = 1;
f = 14e9;
lambda = 5*l;
eps_r = 1/(lambda*f*sqrt(mu_0*mu_r*eps_0))^2
lambda = 1/sqrt(mu_0*eps_0*mu_r*eps_r)/f


eps_loss = 100
omega = 2*pi*f;
alpha = real(j*omega*sqrt(mu_0*mu_r*eps_0*(eps_r-j*eps_loss)));
skinDepth = alpha^-1
