function load_t(Z1,k1,er,mr)

k2 = k1*sqrt(er*mr);
Z2 = Z1*sqrt(mr/er);

l1 = (0:1000)/100;
l2 = -(0:1000)/100;

G = GammaL(Z1,Z2,0,k1);
T = 1 + G;

Vp = OndaP(1,k1,l1);
Vm = OndaR(G,k1,l1);
Vt = OndaP(T,k2,l2);

for i=1:400
    t = i/100;
    Vpt = real(Vp*exp(sqrt(-1)*2*pi*t));
    Vmt = real(Vm*exp(sqrt(-1)*2*pi*t));
    Vtt = real(Vt*exp(sqrt(-1)*2*pi*t));

    Ipt = Vpt/Z1;
    Imt = -Vmt/Z1;
    Itt = Vtt/Z2;
    
    subplot (1,2,1);
    plot (-l1,Vpt,'r--',-l1,Vmt,'g--',-l1,Vpt+Vmt,'b',-l2,Vtt,'b',...
          -l1,abs(Vp+Vm),'k',-l1,-abs(Vp+Vm),'k',-l2,abs(Vt),'k',-l2,-abs(Vt),'k');
    axis([-10 10 -2 2]);
    title ('Campo Elettrico');
    F1(i)=getframe;
    subplot (1,2,2);
    plot (-l1,Ipt,'r--',-l1,Imt,'g--',-l1,Ipt+Imt,'b',-l2,Itt,'b',...
          -l1,abs(Vp-Vm)/Z1,'k',-l1,-abs(Vp-Vm)/Z1,'k',-l2,abs(Vt)/Z2,'k',-l2,-abs(Vt)/Z2,'k');
    axis([-10 10 -0.02 0.02]);
    title ('Campo Magnetico');
    text(-9,+0.017,strcat('e_r = ',num2str(er)));
    text(-9,+0.015,strcat('m_r = ',num2str(mr)));
    text(0,+0.017,strcat('Z1 = ',num2str(Z1)));
    text(0,+0.015,strcat('k1 = ',num2str(k1)));
    text(0,+0.013,strcat('Z2 = ',num2str(Z2)));
    text(0,+0.011,strcat('k2 = ',num2str(k2)));

    text(-9,-0.015,strcat('Gamma = ',num2str(G)));
    text(-9,-0.017,strcat('T     = ',num2str(T)));
    F2(i)=getframe;
end

%movie2avi(F1,'line50_load0v2.avi','compression','None');
%movie2avi(F2,'line50_load0i2.avi','compression','None');