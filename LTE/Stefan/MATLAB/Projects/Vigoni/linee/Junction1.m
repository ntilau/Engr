function Junction1(Z1,k1,Z2,k2)
l1 = (0:1000)/200;
l2 = -(0:1000)/200;

G = GammaL(Z1,Z2,0,k1);

Vp = OndaP(1,k1,l1);
Vm = OndaR(G,k1,l1);
Vt = OndaP(1+G,k2,l2);

plot (-l1,real(Vp),'r--',-l1,real(Vm),'g--',-l1,abs(Vp+Vm),'k',-l2,real(Vt),'r--',-l2,abs(Vt),'k');
axis([-10 10 -1.5 1.5]);