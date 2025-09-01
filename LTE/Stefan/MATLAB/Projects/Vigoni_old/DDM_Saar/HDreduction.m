function [BC,CD,FEM,fdeg,vpec]=HDreduction(BC,CD,FEM,ele,nlab,Lpec,Lpmc,PO)                           
%
%   This function provide the reduction of matrices 
%   caused by dirichlet boundary condition on pec
%
%Note: BC,CD,FEM are sparse matrices

[MAXPO,Np]=size(PO);
vlbl    =   nlab;
%On port boundary condition
for ib=1:Np                
    i1=PO(1,ib);
    i2=PO(MAXPO-1,ib);
    vlbl(i1)=-1;
    vlbl(i2)=-1;    
end
%On pec boundary condition
vpec = find(vlbl~=Lpec & vlbl~=-1);

FEM=FEM(vpec,vpec);
CD=CD(vpec,:);
BC=BC(:,vpec);
fdeg=length(vpec);


