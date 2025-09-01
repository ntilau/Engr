% curves of constant param1/param2 ratio

% close all;
% clear all;

f0 = 12e9;
c0 = 299792.458e3;
k0 = 2.0*pi*f0/c0;
mu0_ = 4e-7*pi;
mu0 = 21;

f = 1e9:1e6:40e9;
alphaDeg = 80;
alphaRad = alphaDeg/180*pi;
tanAlpha = tan(alphaRad);
tanAlpha = 0.58/639557;
mu = mu0./(1+tanAlpha*(k0^2-4*(pi^2)/(c0^2)*(f.^2)));
figure;
plot(f,mu);
axis([f(1) f(end) 0 40]);

zErg = (k0^2-4*(pi^2)/(c0^2)*(f.^2))
f1 = 12.1e9;
4*pi^2/c0^2*f1^2