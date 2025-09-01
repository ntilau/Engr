function polesMu = calcPolesMu(pathName, mu0, k0)

fNameSys0 = strcat(pathName, 'sysMatReduced0');
sys0 = readMatFull(fNameSys0);
fNameSys1 = strcat(pathName, 'sysMatReduced1');
sys1 = readMatFull(fNameSys1);
fNameIdent = strcat(pathName, 'identRed');
ident = readMatFull(fNameIdent);

c0 = 299792.458e3;
mu0_ = 4e-7*pi;
eta0 = mu0_*c0;

sys0 = sys0+j*k0*eta0*ident;

polesMu = eig(sys0,sys1,'qz');
polesMu = mu0./(-1*polesMu+1);
