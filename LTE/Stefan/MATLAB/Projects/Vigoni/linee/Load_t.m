function load_t(Z1,k1,Z2)
l1 = (0:1000)/100;

G = GammaL(Z1,Z2,0,k1);

Vp = OndaP(1,k1,l1);
Vm = OndaR(G,k1,l1);

for i=1:400
    t = i/100;
    Vpt = real(Vp*exp(sqrt(-1)*2*pi*t));
    Vmt = real(Vm*exp(sqrt(-1)*2*pi*t));

    Ipt = Vpt/Z1;
    Imt = -Vmt/Z1;
    
    subplot (1,2,1);
    plot (-l1,Vpt,'r--',-l1,Vmt,'g--',-l1,Vpt+Vmt,'b',-l1,abs(Vp+Vm),'k',-l1,-abs(Vp+Vm),'k');
    axis([-10 0 -2 2]);
    title ('Tensione');
    F1(i)=getframe;
    subplot (1,2,2);
    plot (-l1,Ipt,'r--',-l1,Imt,'g--',-l1,Ipt+Imt,'b',-l1,abs(Vp-Vm)/Z1,'k',-l1,-abs(Vp-Vm)/Z1,'k');
    axis([-10 0 -0.05 0.05]);
    title ('Corrente');
    F2(i)=getframe;
end

%movie2avi(F1,'line50_load0v2.avi','compression','None');
%movie2avi(F2,'line50_load0i2.avi','compression','None');