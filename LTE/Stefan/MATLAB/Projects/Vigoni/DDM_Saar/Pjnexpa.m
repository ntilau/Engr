function p=Pjnexpa(n,j,a)
%   n=polinomial order
%   j=???
%   a=argument of the exponential function

a2=a*a;
a3=a2*a;
a4=a3*a;
a5=a4*a;
expa=exp(a);

val=n*(n-1)/2-1+j;

if abs(a)>1e-6
    if val == 1
        p=(expa-a-1)/a2;
    elseif val==2
        p=(expa*(a-1)+1)/a2;
    elseif val==3
        p=-expa*(a-4)/a3-(a2+3*a+4)/a3;
    elseif val==4
        p=4*expa*(a-2)/a3+4*(a+2)/a3;
    elseif val==5
        p=expa*(a2-3*a+4)/a3-(a+4)/a3;
    elseif val==6
        p=expa*(a2-9*a+27)/a4-(2*a3+11*a2+36*a+54)/(2*a4);
    elseif val==7
        p=9*(a2-5*a+9)/a4-9*expa*(a2-8*a+18)/2/a4;
    elseif val==8
        p=9*expa*(a2-5*a+9)/a4-9*(a2+8*a+18)/2/a4;
    elseif val==9
        p=expa*(2*a3-11*a2+36*a-54)/2/a4+(a2+9*a+27)/a4;
    elseif val==10
        p=-expa*(3*a3-44*a2+288*a-768)/(3*a5)-(3*a4+25*a3+140*a2+480*a+768)/(3*a5);
    elseif val==11
        p=16*expa*(a3-14.*a2+84.*a-192.)/(3.*a5)+16.*(3.*a3+26.*a2+108.*a+192.)/(3.*a5);
    elseif val==12
        p=-4*expa*(3*a3-38*a2+192*a-384)/a5-4*(3*a3+38*a2+192*a+384)/a5;
    elseif val==13
        p=16*expa*(3*a3-26*a2+108*a-192)/(3*a5)+16*(a3+14*a2+84*a+192)/(3*a5);
    elseif val==14 
        p=expa*(3*a4-25*a3+140*a2-480*a+768)/(3*a5) -(3*a3+44*a2+288*a+768)/(3*a5);
    end
else
    if val==1
        p= a3/120+a2/24+a/6+1/2;
    elseif val==2
        p=  a3/30+a2/8+a/3+1/2;
    elseif val==3
        p= -a3/360-a2/120+1/6;
    elseif val==4
        p= a3/45+a2/10+a/3+2/3;
    elseif val==5
        p= a3/45+3*a2/40+a/6+1/6;
    elseif val==6
        p= a3/840+a2/240+a/60+1/8;
    elseif val==7
        p= -a3/280+3*a/40+3/8;
    elseif val==8
        p= a3/35+9*a2/80+3*a/10+3/8;
    elseif val==9
        p= 13*a3/840+a2/20+13*a/120+1/8;
    elseif val==10
        p= -a3/1512-a2/504+7/90;
    elseif val==11
        p= 4*a3/945+2*a2/105+4*a/45+16/45;
    elseif val==12
        p= -a3/315+a2/210+a/15+2/15;
    elseif val==13
        p= 4*a3/135+34*a2/315+4*a/15+16/45;
    elseif val==14
        p= 11*a3/945+31*a2/840+7*a/90+7/90;
    end
end