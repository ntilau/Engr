function I=PnExpa(n,a,x,dxp,dxm)
%   n   =   polynomial order
%   a   =   exponential argument
%   x   =   minimum boundary
%   dxp =   integration rigth interval length
%   dxm =   integration left interval length

%at the present moment only the simple case of degree n = 1 is implemented
if n==1
    bm=a*dxm;
        ibm2=1/(bm*bm);
    bp=-a*dxp;
        ibp2=1/(bp*bp);
    xm=x-dxm;
    xp=x+dxp;
    Im=dxm*exp(a*xm)*(exp(bm)*(1/bm-ibm2)+ibm2);
    Ip=dxp*exp(a*xp)*(exp(bp)*(1/bp-ibp2)+ibp2);
    I=Im+Ip;
end
