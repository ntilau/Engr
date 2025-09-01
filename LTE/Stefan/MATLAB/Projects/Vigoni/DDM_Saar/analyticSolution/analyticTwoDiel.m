function [ G ] = analyticTwoDiel(a, b, d1, d2, d3, er1, mr1, er2, mr2, f)
%ANALYTIC computation of a dielectric slab loaded waveguide
% [IN]
%    a,b   - waveguide dimensions (m)
%    d1,d2 - waveguide is d1 long, then there is a d2 thick slab, then
%            d3 of emptiness, the second d2 thick slab and
%            finally d1 of emptiness (m)
%    er,mr - guess....
%    f     - a vector of frequencies (Hz)
%
% [OUT]
%    G(N) - Gamma as a function of frequency.


% frequency independent stuff
kc = (pi/a);
fc0 = 299800000/(2*a);
fcd1 = 299800000/(2*a*sqrt(er1*mr1));
fcd2 = 299800000/(2*a*sqrt(er2*mr2));
eta0 = 120*pi;
etad1 = eta0*sqrt(mr1/er1);
etad2 = eta0*sqrt(mr2/er2);

for i= 1:length(f)
    % Line characteristics
    wf = f(i);
    
    k0 = 2*pi*wf/299800000;
    kd1 = k0*sqrt(er1*mr1);
    kd2 = k0*sqrt(er2*mr2);
    
    beta0 = sqrt(k0^2-kc^2);
    betad1 = sqrt(kd1^2-kc^2);
    betad2 = sqrt(kd2^2-kc^2);
    
    lambda0 = 2*pi/beta0;
    lambdad1 = 2*pi/betad1;
    lambdad2 = 2*pi/betad2;
    
    Z0 = eta0/sqrt(1-(fc0/wf)^2);
    Zd1 = etad1/sqrt(1-(fcd1/wf)^2);
    Zd2 = etad2/sqrt(1-(fcd2/wf)^2);
    
    % Let's transport Z0 along Zd2 for d2
    ZL = Zd2 * (Z0 + sqrt(-1)*Zd2*tan(betad2 * d2)) / (Zd2 + sqrt(-1)*Z0*tan(betad2 * d2));
    
    % Let's transport ZL along Z0 for d3
    ZL1 = Z0 * (ZL + sqrt(-1)*Z0*tan(beta0 * d3)) / (Z0 + sqrt(-1)*ZL*tan(beta0 * d3));    
    
    % Let's transport ZL1 along Zd1 for d2
    ZL2 = Zd1 * (ZL1 + sqrt(-1)*Zd1*tan(betad1 * d2)) / (Zd1 + sqrt(-1)*ZL1*tan(betad1 * d2));
    
    % And this along Z0 for d1
    ZLL = Z0 * (ZL2 + sqrt(-1)*Z0*tan(beta0 * d1)) / (Z0 + sqrt(-1)*ZL2*tan(beta0 * d1));
    
    % calc transfer function
    G(i) = (ZLL - Z0)/(ZLL + Z0);
end
