function [BC,CD]=BuildBCCDDD(xy,Bi,RZ,PO,a,k0,Zeta0,Np,nmode,plane,nord,iNODEc)
%--------------------------------------------------------------------------
%   
%--------------------------------------------------------------------------

NNODE=size(xy,2);
npnm=Np*nmode;
%initializations
BC=spalloc(npnm,NNODE,npnm);
CD=spalloc(NNODE,npnm,npnm);

%Elements are first order      
nord = 1;                 
MAXPO=size(PO,1);      
in = 0;
cj = sqrt(-1);   %imaginary unit
if (plane=='E')
    pia = pi / a;
    for ip=1:Np %port index
        abp = dist( xy(1,PO(1,ip)), xy(2,PO(1,ip)),xy(1,PO(PO(MAXPO,ip),ip)), xy(2,PO(PO(MAXPO,ip),ip)) );
        piabp = pi/abp;
        nel = (PO(MAXPO,ip) - 1)/nord;
        im = (ip-1)*nmode; %mode index
        for ie = 1:nel
            i1  = (ie-1) * nord + 1;
            i2  = i1 + nord;
            dx  = dist( xy(1,PO(i1,ip)), xy(2,PO(i1,ip)),xy(1,PO(i2,ip)), xy(2,PO(i2,ip)) );
            x1  = dist( xy(1,PO( 1,ip)), xy(2,PO( 1,ip)),xy(1,PO(i1,ip)), xy(2,PO(i1,ip)) );
            for j=1:nord+1
                %LSE10 mode
                integ = dx * real( Pjnexpa(nord+1,j,0) )
                BC(im+1,PO(i1+j-1,ip)) = BC(im+1,PO(i1+j-1,ip)) + integ;
                CD(PO(i1+j-1,ip),im+1) = CD(PO(i1+j-1,ip),im+1) - cj * Bi(1,ip) * RZ(1,ip) * integ;
                %LSE1m modes
                for m=1:nmode-1
                    aux = cj * m * piabp;
                    integ = dx * real( exp(aux*x1) * Pjnexpa(nord+1,j,aux*dx) );
                    BC(im+m+1,PO(i1+j-1,ip)) = BC(im+m+1,PO(i1+j-1,ip)) + integ;
                    CD(PO(i1+j-1,ip),im+m+1) = CD(PO(i1+j-1,ip),im+m+1) - cj * Bi(m+1,ip) * RZ(m+1,ip) * integ;
                end
            end
        end
    end
else
    for ip=1:Np
        abp = dist( xy(1,PO(1,ip)), xy(2,PO(1,ip)),...
                    xy(1,PO(PO(MAXPO,ip),ip)), xy(2,PO(PO(MAXPO,ip),ip)) );
        piabp = pi / abp;
        nel = (PO(MAXPO,ip) - 1) / nord;
        im = (ip-1)*nmode;          %indice base di modo
        for ie = 1:nel
            i1  = (ie-1) * nord + 1;
            i2  = i1 + nord;
            dx  = dist( xy(1,PO(i1,ip)), xy(2,PO(i1,ip)),...
                        xy(1,PO(i2,ip)), xy(2,PO(i2,ip)) );
            x1  = dist( xy(1,PO( 1,ip)), xy(2,PO( 1,ip)),...
                        xy(1,PO(i1,ip)), xy(2,PO(i1,ip)) );
            for j=1:nord+1;
                for m=1:nmode
                    aux = cj * m * piabp;
                    integ = dx * imag( exp(aux*x1) * Pjnexpa(nord+1,j,aux*dx) );
                    BC(im+m,PO(i1+j-1,ip)) = BC(im+m,PO(i1+j-1,ip)) + integ;
                    CD(PO(i1+j-1,ip),im+m) = CD(PO(i1+j-1,ip),im+m) + aux * Bi(m,ip) * RZ(m,ip) * integ;
                end
            end
        end
    end
end
%Stating dirichlet boundary condition on extreme port points in case of
%plane H.
%Giacomo ha commentato tutto da qui in poi.
  if plane == 'H'
     for ip=1:Np
         for jp=1:2
             if (jp==1) 
                 iauxj = PO(1,ip);
             end
            if (jp==2) 
                 iauxj = PO(PO(MAXPO,ip),ip);
             end
             CD(iauxj,:) = zeros(1,npnm);
         end
     end
 end
return