function [S,S11,S21,S12,S22,freq]=RWGjunction(fgeoname,felename,foutname,flagout)
%-------------------------------------------------
%Rectangular waveguide bend devices in:
%   E-plane homogeneus
%   H-plane in-homogeneus
%-------------------------------------------------
%--------------constants
c0  =   0.2998e9;   %[m/s]
mu0 =   pi*4e-7;    %[A/s]
Z0  =   c0*mu0;      %[ohm]
%--------------FEM mesh variables
ele     =   [];     %element matrix
point   =   [];     %coordinate node matrix
nlab    =   [];     %node label vector
elab    =   [];     %element label vector
NNODE   =   0;      %number of nodes
NELE    =   0;      %number of elements
NORD    =   1;      %Elemet order
NEL     =   0;      %elemets per port

%Lpec,Lpmc           %label of nodes on p.e.c. and p.m.c.
Lp      =   [];     %label on nodes on ports
Nport   =   [];     %all nodes on all ports
plane   =   'H';    % 'H' or 'E'

ndie    =   0;      %Number of dielectrics
material=   [];     %material labels
Eps     =   [];     %permettivities
Mu      =   [];     %permeabilities

PO      =   [];     %indexes to nodes on ports
Np      =   2;      %number of ports of the junction

%-----------------EM variables
nmode   =   1;      %number of modes to be used in expansion
nfreq   =   1;      %number of frequencies
freq    =   [];     %Frequencies [Hz]

I=i;

%----------------STARTUP    
disp('+---Reading mesh file.');
[point,ele,d1,nlab,elab,d2,NNODE,NELE,d3]=ReadMesh(fgeoname);
clear d1;
clear d2;
clear d3;
disp('+---Reading electromagnetic file.');
fid     =   fopen(felename,'r');

Np      =   fscanf(fid,'%i',1);
a       =   fscanf(fid,'%e',Np);
b       =   fscanf(fid,'%e',Np);
Lp      =   fscanf(fid,'%i',Np);
Lpec    =   fscanf(fid,'%i',1);
Lpmc    =   fscanf(fid,'%i',1);
nmode   =   fscanf(fid,'%i',1);
plane   =   fscanf(fid,'%s',1);
ndie    =   fscanf(fid,'%i',1);
Eps     =   fscanf(fid,'%e',ndie);
Mu      =   fscanf(fid,'%e',ndie);
material=   zeros(1,ndie+1);
material(1,2:ndie+1)    =   fscanf(fid,'%i',ndie);
nfreq   =   fscanf(fid,'%e',1);
freq    =   fscanf(fid,'%e',nfreq);

fclose(fid);
%------------------Rescale everything to MKS-unit system
a   =   a*1e-3;            %from [mm] -> [m]
b   =   b*1e-3;            %from [mm] -> [m]
freq=   freq*1e9;          %from [GHz]-> [Hz]
point=  point*1e-3;        %from [mm] -> [m]
%------------------Checkings Simulation type
if(ndie > 1 & (plane=='e' | plane=='E'))
    disp('*********ERROR********** - E plane only homogeneus.');
    return;
end
if(plane=='e'),plane='E';,end 
if(plane=='h'),plane='H';,end
if(plane~='E' & plane~='H')
    disp('**** ERROR **** Unrecognizable plane analisys');
end

%------------------Verifies cut-off
epsr    =   1;
mur     =   1;
for ip=1:Np
    ft10    =   c0/(2*a(ip));
    if(b<=a(ip)/2)
        ft20    =   2*ft10;
    else
        ft20    =   c0/(2*b(ip));
    end
    ifl1=0;
    ifl2=0;
    if(freq(1)<ft10)
        disp(['WARNING: the minimum frequency is below first cut-off frequency on port ',num2str(ip)]);
    end
    if(freq(nfreq)>ft20)
        disp(['WARNING: the maximum frequency is over second cut-off frequency on port ',num2str(ip)]);
    end
end

dim=a;
if(plane=='E')
    dim=b;
end

% SET the vector of the nodes on the ports
PO      =   ports(nlab,point,Np,NNODE,dim,Lp);
MAXPO   =   size(PO,1);
%------------------opens the output file
fid=fopen(foutname,'w');

%MAIN FREQUENCY LOOP
for k=1:nfreq
    %print on output file
    fprintf(fid,'Frequeny = %12.6e GHz\n',freq(k)*1e-9);
    %print on screen
    disp(['Frequeny = ',num2str(freq(k)*1e-9),' GHz']);
    %set the fequency dependent values
    k0=2*pi*freq(k)/c0;
    k02=k0*k0;
    if plane=='H'
        vkt2(1)         =   k02*epsr*mur;   %in waveguide-air
        vcoeff(1)       =   1/mur;          %
        vkt2(2:ndie+1)  =   k02*Eps.*Mu;    %in dielectrics
        vcoeff(2:ndie+1)=   1./Mu;          %
    else% E-plane
        vkt2(1)     =   k02*epsr*mur-(pi/a)^2;
        vcoeff(1)   =   1/epsr;
    end
    
    %-------known vector building
    if(ele(1,1)==3 | ele(1,1)==4)
        NORD=1;
    else
        NORD=2;
    end
    
    %the resolvant sistem is
    %
    %   |AC | BC||V1|   |I1|
    %   |---|---||  |=  |  |
    %   |DC |FEM||V2|   |I2|
    %
    %
    %INIZIALIZATIONS
    %FEM is a sparse (NNODE;NNODE)          matrix  
    %AC  is a sparse (nmode*NP;nmode*NP)    matrix
    %BC  is a sparse (nmode*NP;NNODE)       matrix
    %CD  is a sparse (NNODE;nmode*NP)       matrix
    
    %FEM, AC BC AND CD MATRIX BUILDING---------------------------------------------------------------------------------------
    %This matrices are indipendent by the feeding port
    [FEM]       =   BuildFem(ele,point,nlab,elab,NELE,NNODE,PO,Np,ndie,material,plane,vcoeff,vkt2);
    [AC,RZ,Bi]  =   BuildAC(Np,nmode,PO,plane,a,b,k0,k02,Z0,point);
    [BC,CD]     =   BuildBC_CD(Np,nmode,NNODE,PO,plane,a,b,point,Bi,RZ,NORD);
    
    
    %----------------DEBUG--------------
    %pf=fopen('debug.m','w');
    %fprintf(pf,'FEM matrix:\n');
    %for i=1:size(FEM,1)
    %    for j=1:size(FEM,2)
    %        fprintf(pf,'(%+e,%+e) ',real(FEM(i,j)),imag(FEM(i,j)));
    %    end
    %    fprintf(pf,'\n');
    %end
    %fprintf(pf,'CD matrix:\n');
    %for i=1:size(CD,1)
    %    for j=1:size(CD,2)
    %        fprintf(pf,'(%+e,%+e) ',real(CD(i,j)),imag(CD(i,j)));
    %    end
    %    fprintf(pf,'\n');    
    %end
    %fprintf(pf,'BC matrix:\n');
    %for i=1:size(BC,1)
    %    for j=1:size(BC,2)
    %        fprintf(pf,'(%+e,%+e) ',real(BC(i,j)),imag(BC(i,j)));
    %    end
    %    fprintf(pf,'\n');
    %end

    %-----------------------------------
    %matrices must be reducted with homogeneus dirichlet boundary conditions
    %REMEMBER THAT THE EXTREMAL PORT NODES ARE ON P.E.C. !!!!!!!!
    [BC,CD,FEM,fdeg,vpec]=HDreduction(BC,CD,FEM,ele,nlab,Lpec,Lpmc,PO);
    
    %-----------------------DEBUG--------------------------------------
    %fprintf(pf,'\n\nFEM matrix:\n');    
    %for i=1:size(FEM,1)
    %    for j=1:size(FEM,2)
    %        fprintf(pf,'(%+e,%+e) ',real(FEM(i,j)),imag(FEM(i,j)));
    %    end
    %    fprintf(pf,'\n');
    %end
    %fprintf(pf,'CD matrix:\n');
    %for i=1:size(CD,1)
    %    for j=1:size(CD,2)
    %        fprintf(pf,'(%+e,%+e) ',real(CD(i,j)),imag(CD(i,j)));
    %    end
    %    fprintf(pf,'\n');    
    %end
    %fprintf(pf,'BC matrix:\n');
    %for i=1:size(BC,1)
    %    for j=1:size(BC,2)
    %        fprintf(pf,'(%+e,%+e) ',real(BC(i,j)),imag(BC(i,j)));
    %    end
    %    fprintf(pf,'\n');
    %end
    %fclose(pf);
    %-------------------------------------------------------------------
    
    %----------------------------------------------------------------------------------------------------------
    %PORT EXCITATION LOOP
    for ip=1:Np  %ip is the feeding port
        
        disp(['+--- Exciting port ',num2str(ip),' with mode 1']);
        IC      =   zeros(1,nmode*Np);  %port excitation amplitude mode 
        ID      =   zeros(1,NNODE);     %port excitation fields 
        %port node number
        pnn = PO(MAXPO,ip);
        %port element number
        NEL = (pnn-1)/NORD;
        
        %----------------------source definition
        %is the port base mode index
        i1 = (ip-1)*nmode;
        if plane=='E'      
            % !!!!!!!!!!!!!!!!!!!!DA FARE!!!!!!!!!!!!!!!!!!!!!!!!
        else %plane 'H' 
            piabp = pi/a(ip);
            IC(i1+1)=-sqrt(a(ip)/b(ip))*RZ(1,ip);
            %IC(i1+1)=-pi/2*RZ(1,ip);
            for in=2:(pnn-1)
                %computing integral------------------
                i0=(in-1)*NORD+1; 
                i0p=i0+NORD;
                i0m=i0-NORD;
                dxp     =   dist(point(1,PO(i0p,ip)),point(1,PO(i0,ip)) ,point(2,PO(i0p,ip)),point(2,PO(i0,ip)));%
                dxm     =   dist(point(1,PO(i0,ip)) ,point(1,PO(i0m,ip)),point(2,PO(i0,ip)) ,point(2,PO(i0m,ip)));%
                x       =   dist(point(1,PO( 1,ip)) ,point(1,PO(i0 ,ip)),point(2,PO( 1,ip)) ,point(2,PO(i0 ,ip)));%
                alpha   =   piabp*I;
                integ   =   imag(PnExpa(1,alpha,x,dxm,dxp)); %rivedere come mai è sempre zero
                %-------------------------------------
                ID(PO(i0,ip))  =   -I*Bi(1,ip)*2/sqrt(a(ip)*b(ip))*RZ(1,ip)*integ; 
                %ID(PO(i0,ip))   =   I*Bi(1,ip)*piabp*RZ(1,ip)*integ;
            end            
        end
        %reduction cycle due to boundary condition
        ID=ID(vpec);            
  
        %-----------------DEBUG-----------------------------
        %pf=fopen('debsource.txt','a');
        %fprintf(pf,'port %i\n',ip);
        %fprintf(pf,'IC: ');
        %for i=1:length(IC)
        %    fprintf(pf,'(%+e,%+e) ',real(IC(i)),imag(IC(i)));
        %end
        %fprintf(pf,'\n');
        %fprintf(pf,'ID: ');
        %for i=1:length(ID)
        %    fprintf(pf,'(%+e,%+e) ',real(ID(i)),imag(ID(i)));
        %end
        %fprintf(pf,'\n');
        %fclose(pf);
        %---------------------------------------------------
        
        %---------------Solution
        M=full([AC,BC;CD,FEM]);
        ICD=[IC';ID'];
        %N1=length(IC);
        %N2=length(ID);
        %V=M\ICD;
        %V1=V(1:N1);
        %V2=V(N1+1:N1+N2);
        
        [V1,V2]=BlockSolver(AC,BC,CD,FEM,IC,ID,flagout);
        
        %Store results
        disp('+----Storing results');
        for jp=1:Np
            for j=1:nmode
                s=j+(jp-1)*nmode;
                S(jp,ip,k,j)=V1(s);
                fprintf(fid,'S%i%i mode %3i: %12.6e %12.6e %12.6e %12.6e\n',jp,ip,j,...
                    real(V1(s)),...
                    imag(V1(s)),...
                    abs(V1(s)),...
                    atan2(imag(V1(s)),real(V1(s))));
                %---------DEBUG
                if(ip==1 & jp==1)
                    S11(k,j)=abs(V1(s));
                elseif(ip==1 & jp==2)
                    S21(k,j)=abs(V1(s));
                elseif(ip==2 & jp==1)
                    S12(k,j)=abs(V1(s));
                elseif(ip==2 & jp==2)
                    S22(k,j)=abs(V1(s));
                end
                %--------------
            end
            if flagout==1
                writecres('fields.out',V2,fdeg,1,'M')  
            end
        end
    end %port excitation loop
end %end main loop frequency
fclose(fid);
%------------------End of bend function------------------------------------%
%--------------------------------------------------------------------------%

%------------------Auxiliary functions-------------------------------------%
%------------------dist()
function d=dist(x1,x2,y1,y2)
d=((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))^.5;
%------------------end dist()