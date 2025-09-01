function [FEM] = BuildFem(ele,xy,nlab,elab,NELE,NNODE,PO,Np,LPEC,LPMC,Ndie,material,plane,vcoeff,vkt2)
%
%   Build the global fem matrix for both E-plane and H-plane analysis
%

FEM=spalloc(NNODE,NNODE,NNODE);
%main loop on elements
for ie =1:NELE
    %Set the material of the element to build up
    imat=1;
    if plane =='H'
        for i=2:Ndie+1
            if (elab(ie)==material(i))
                imat = i; %material identification
            end    
        end
    end
    %------------Builds the element matrices
    lds =   ele(1,ie);      %element type and order
    [Se,Te] =   elenmat(xy,ele,ie,lds,lds);
    %------------Builds the global matrix
    for j=1:ele(1,ie)
        iauxj  =   ele(j+1,ie);    %global index
        iauxi  =   nlab(iauxj);    %global index label
        if not( (iauxi==LPEC & plane == 'H') | (iauxi==LPMC & plane == 'E') )
            for k = 1:ele(1,ie)
                iauxk = ele(k+1,ie);
                caux  = vcoeff(imat)*( - Se(j,k) + vkt2(imat)*Te(j,k));
                FEM(iauxj,iauxk) = FEM( iauxj , iauxk ) +  caux;
            end
        else     
            %Imposes the BC
            FEM(iauxj,iauxj) = 1;
        end
    end
end 

% Adds the pec conditions at the port sides for H plane
MAXPO = size(PO,1);
if (plane == 'H')
    for ip=1:Np
        for j=1:2
            if (j==1) 
                iauxj = PO(1,ip);
            end
            if (j==2) 
                iauxj = PO(PO(MAXPO,ip),ip);
            end
            FEM(iauxj,:) = zeros(1,NNODE);
            FEM(iauxj,iauxj) = 1;
        end
    end
end
return