function Junction1(Z1,k1,Z2,k2,L,Z3,k3)
l1 = (0:1000)/100;
l2 = (0:1000)/1000*L;
l3 = -(0:1000)/100;

G1 = GammaL(Z2,Z3,0,k1);

ZL = ZetaL(Z2,Z3,L,k2);
G2 = GammaL(Z1,ZL,0,k1)

Vp1 = OndaP(1,k1,l1-k2*L/k1);%*exp(sqrt(-1)*k2*L);
Vr1 = OndaR(G2,k1,l1+k2*L/k1);%*exp(-sqrt(-1)*k2*L);

Vp2 = OndaP(1+G2,k2,l2);
Vr2 = OndaR(G1*(1+G2),k2,l2);

Vt = OndaP((1+G1)*(1+G2),k2,l3);

plot (-l1-L,real(Vp1),'r--',-l1-L,real(Vr1),'g--',-l1-L,abs(Vp1+Vr1),'k',-l2,real(Vp2),'r',-l2,real(Vr2),'g',-l2,abs(Vp2+Vr2),'k',-l3,real(Vt),'r--',-l3,abs(Vt),'k');
