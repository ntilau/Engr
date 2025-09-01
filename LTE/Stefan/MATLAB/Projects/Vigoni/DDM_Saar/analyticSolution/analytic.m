function [ G ] = analytic( a,b, d1,d2, er,mr, f )
%ANALYTIC computation of a dielectric slab loaded waveguide
% [IN]
%    a,b   - waveguide dimensions (mm)
%    d1,d2 - waveguide is d1 long, then there is a d2 thick slab, then
%            another d1 of emptiness (mm)
%    er,mr - guess....
%    f     - a vector of frequencies (GHz)
%
% [OUT]
%    G(N) - Gamma as a function of frequency.

% SI!
a  = a * 0.001;
b  = b * 0.001;
d1 = d1 * 0.001;
d2 = d2 * 0.001;

% set constants
c0   = 0.2998e9;   %[m/s]
mu0  = pi*4e-7;    %[A/s]

% frequency independent stuff
kc = (pi/a);
fc0 = c0 / (2*a);
fcd = c0 / (2*a*sqrt(er*mr));
% eta0 = 120*pi;
eta0 = c0 * mu0;
etad = eta0*sqrt(mr/er);

for i= 1:length(f)
    % Line characteristics
    wf = f(i) * 10^9;
    
    k0 = 2*pi*wf/299800000;
    kd = k0*sqrt(er*mr);
    
    beta0 = sqrt(k0^2-kc^2);
    betad = sqrt(kd^2-kc^2);
    
    lambda0 = 2*pi/beta0;
    lambdad = 2*pi/betad;
    
    Z0 = eta0/sqrt(1-(fc0/wf)^2);
    Zd = etad/sqrt(1-(fcd/wf)^2);
    
    % Let's transport Z0 along Zd for d2
    ZL = Zd * (Z0 + sqrt(-1)*Zd*tan(betad * d2)) / (Zd + sqrt(-1)*Z0*tan(betad * d2));
    
    % And this along Z0 for d1
    ZLL = Z0 * (ZL + sqrt(-1)*Z0*tan(beta0 * d1)) / (Z0 + sqrt(-1)*ZL*tan(beta0 * d1));
    
    G(i) = (ZLL - Z0)/(ZLL + Z0);
end
