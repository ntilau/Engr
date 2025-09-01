function [AC,Bi,RZ]=BuildAC(xy,PO,a,k0,Zeta0,Np,Nm,plane)
%--------------------------------------------------------------------------
%   FUNCTION TO BUILD THE MATRIX [AC] OF THE PORT MODE EIGENFUNCTION 
%   INTERACTION.    
%--------------------------------------------------------------------------
    
k02   = k0*k0;
MAXPO = size(PO,1);
NPNM  = Np*Nm;
AC    = spalloc(NPNM,NPNM,NPNM);
cj    = sqrt(-1);

for ip=1:Np
    abp = dist(xy(1,PO(1,ip)),xy(2,PO(1,ip)),...
               xy(1,PO(PO(MAXPO,ip),ip)), xy(2,PO(PO(MAXPO,ip),ip)));
    i1 = (ip-1)*Nm;       
    if (plane=='E')
    %-----LSE10 (or TE10) mode
        Bi(1,ip) = naimsqrt(k02-(pi/a(ip))*(pi/a(ip)));
        RZ(1,ip) = exp(-cj*pi/4) * sqrt( k0*Zeta0*a(ip)/(2*pi) ) * Bi(1,ip) * Bi(1,ip);
        AC(i1+1,i1+1) = - RZ(1,ip) * abp;
    %-----LSE1m modes
        for m=1:Nm-1
            Bi(m+1,ip) = naimsqrt(k02 - (pi/a(ip))*(pi/a(ip)) - (m*pi/abp)*(m*pi/abp));
            RZ(m+1,ip) = RZ(1,ip);
            AC(i1+m+1,i1+m+1) =  AC(i1+1,i1+1) / 2.
        end
    else
        for m=1:Nm
            Bi (m,ip)  = naimsqrt(k02 -(m*pi/abp)*(m*pi/abp));
            RZ (m,ip)  = preasqrt(k0 * Zeta0 / Bi(m,ip));
            AC(i1+m,i1+m) = m * (pi/2) * RZ(m,ip);
        end
    end
end
return 