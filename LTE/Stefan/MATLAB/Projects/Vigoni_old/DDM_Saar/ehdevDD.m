function [S,S11,S21,S12,S22,freq] = ehdevDD(fgeoname,fdomainsname,felename,foutname,flagout,sweep)
%**************************************************************************
%
%**************************************************************************
%DETERMINA LA SOLUZIONE DI UN SISTEMA LINEARE TRAMITE LA TECNICA DI
%DECOMPOSIZIONE DEL DOMINIO NOTA COME "DDM SHUR-COMPLEMENT METHOD" IN CUI
%LA SOLUZIONE DI UN SISTEMA LINEARE SPARSO, CHE DECOMPOSTO RISULTA DELLA
%FORMA:
%
%   |AC 0   0                    0  BC| |B |   |IC|
%   |0  M1  0                    0  E1| |X1|   |0 |
%   |0  0   M2                   0  E2| |X2|   |0 |
%   |:  :   :                    :  : |*|: | = |: |
%   |0  0   0                    Mn En| |Xn|   |0 |
%   |CD F1  F2                   Fn C | |Y |   |ID|
%
% VIENE RIDOTTO AD UN SISTEMA DELLA SEGUENTE FORMA:
%
%   [S]*[Y] = [G]
%
% DOVE 
%       [S] = [C]  - SUM([Fi]*[Mi]^-1*[Ei]) - [CD]*[AC]^-1*[BC]
%       [G] = [ID] - [CD]*[AC]^-1*[IC]
% lA SOLUZIONE DEL PROBLEMA RICHIEDE QUINDI LA SOLUZIONE DI "n" SISTEMI
% LINEARI SPARSI DI DIMENSIONI RIDOTTE INVECE  DELLA SOLUZIONE DI UN
% SISTEMA LINEARE DI TAGLIA IN GENERALE n VOLTE SUPERIORE ESSENDO "n" IL
% NUMERO DEI DOMINI IN CUI è STATO DECOMPOSTO IL DOMINIO ORIGINALE.
%**************************************************************************

%--------------------------------------------------------------------------
%Rectangular waveguide bend devices in:
%   E-plane homogeneus
%   H-plane in-homogeneus
%Using Shur-Complement Domain Decomposition Method 
%--------------------------------------------------------------------------


%--------------constants
c0  =   0.2998e9;   %[m/s]
mu0 =   pi*4e-7;    %[A/s]
Z0  =   c0*mu0;      %[ohm]
%--------------FEM mesh variables
ele     =   [];     %element matrix
xy   =      [];     %coordinate node matrix
nlab    =   [];     %node label vector
elab    =   [];     %element label vector
NNODE   =   0;      %number of nodes
NELE    =   0;      %number of elements
nord    =   1;      %Elemet order
NEL     =   0;      %elemets per port

%Lpec,Lpmc          %label of nodes on p.e.c. and p.m.c.
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

cj = sqrt(-1);

%----------------STARTUP 
disp('+---Reading electromagnetic file.');
fid     =   fopen(felename,'r');
Np      =   fscanf(fid,'%i',1); fgets(fid);
a       =   fscanf(fid,'%e',Np); fgets(fid);
b       =   fscanf(fid,'%e',Np); fgets(fid);
Lp      =   fscanf(fid,'%i',Np); fgets(fid);
LPEC    =   fscanf(fid,'%i',1); fgets(fid);
LPMC    =   fscanf(fid,'%i',1); fgets(fid);
nmode   =   fscanf(fid,'%i',1); fgets(fid);
plane   =   fscanf(fid,'%s',1); fgets(fid);
ndie    =   fscanf(fid,'%i',1); fgets(fid);
Eps     =   fscanf(fid,'%e',ndie); fgets(fid);
Mu      =   fscanf(fid,'%e',ndie); fgets(fid);
material=   zeros(1,ndie+1);
for i=2:ndie+1
material(1,i)    =   fscanf(fid,'%i',1); 
end
fgets(fid);
nfreq   =   fscanf(fid,'%e',1); fgets(fid);        %numero di punti in frequenza da calcolare
freq    =   fscanf(fid,'%e',2); fgets(fid);    %estremi delle frequenze
if freq>1
    freq    =   [freq(1):(freq(2)-freq(1))/(nfreq-1):freq(2)]; 
end    
fclose(fid);

disp('+---Reading mesh file.');
[xy,ele,spig,nlab,elab,edgelab,NNODE,NELE,NSPIG] = ReadMesh(fgeoname);
clear spig;
clear edgelab;
clear NSPIG;

disp('+---Reading domains file.');
[xyDD,eleDD,spigDD,nlabDD,elabDD,edgelabDD,NNODEDD,NELEDD,NSPIGDD] = ReadMesh(fdomainsname);
clear spigDD;
clear edgelabDD;
clear NSPIGDD;

disp('+---Decomposing geometry in sub-domains.');
[DOMAINS] = meshDD(xy,ele,xyDD,eleDD,elabDD);
[MESH,xy,nlab,iNODEc] = reordering(xy,xyDD,nlab,ele,elab,eleDD,DOMAINS,LPEC,Lp);

%DEBUG: PLOT DECOMPOSED MESH-----------------------------------------------
if (bitand(flagout,1))
    NDD = size(eleDD,2);
    color = ['r','m','y','g','b','c'];
    % Plotting della mesh
    figure;
    hold on;
    for id = 1:NDD
        elem = eleDD(2:4,id);
        for ie = 1:size(MESH{id}.ele,2)
             elem = MESH{id}.ele(2:4,ie);
             X = xy(1,elem);
             Y = xy(2,elem);
             patch(X,Y,color(mod(id,5)+1));
        end
        axis equal;
    end
    hold off;
end
%--------------------------------------------------------------------------

%------------------Rescale everything to MKS-unit system
a   =   a*1e-3;            %from [mm] -> [m]
b   =   b*1e-3;            %from [mm] -> [m]
freq=   freq*1e9;          %from [GHz]-> [Hz]
xy=  xy*1e-3;        %from [mm] -> [m]
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


% SET the vector of the nodes on the ports---------------------------------
PO      =   ports(nlab,xy,Np,NNODE,dim,Lp);
MAXPO   =   size(PO,1);
NNODE   =   size(xy,2);
fid     =   fopen(foutname,'w');

%MAIN MATERIAL LOOP--------------------------------------------------------
%for kk=1:sweep.epsilonN
    Eps(sweep.matlabel) = sweep.epsilon;
    
%MAIN FREQUENCY LOOP-------------------------------------------------------
for k=1:nfreq
    %print on screen
    disp(['Frequeny = ',num2str(freq(k)*1e-9),' GHz']);
    %print on output file
    fprintf(fid,'#Frequency = %i GHz\n',freq(k)*1e-9);
    %set the fequency dependent values
    k0=2*pi*freq(k)/c0;
    k02=k0*k0;
    if plane=='H'
        vkt2(1)         =   k02*epsr*mur;   %in waveguide-air
        vcoeff(1)       =   1/mur;          %
        vkt2(2:ndie+1)  =   k02*Eps.*Mu;    %in dielectrics
        vcoeff(2:ndie+1)=   1./Mu;          %
    else% E-plane
        vkt2(1)     =   k02*epsr*mur-(pi/a(1))*(pi/a(1));
        vcoeff(1)   =   1/epsr;
    end
    
    %-------known vector building
    if(ele(1,1)==3 | ele(1,1)==4)
        nord=1;
    else
        nord=2;
    end

    im = 1;
    %FEM, AC BC AND CD MATRIX BUILDING-------------------------------------
    %This matrices are independent by the feeding port
    T = cputime;
    [AC,Bi,RZ]  =   BuildAC(xy,PO,a,k0,Z0,Np,nmode,plane);
    [BC,CD]     =   BuildBCCDDDM(xy,Bi,RZ,PO,a,k0,Z0,Np,nmode,plane,nord,iNODEc);
    [BLOCK,C]   =   BuildFemDDM(MESH,xy,nlab,iNODEc,PO,Np,LPEC,LPMC,...
                                 ndie,material,plane,vcoeff,vkt2);
    Tbuild = cputime - T;
    Tsolve = cputime;
    [SC, IAC] = ShurC(AC,BC,CD,BLOCK,C);
    Tsolve = cputime - Tsolve;
    %----------------------------------------------------------------------
    %PORT EXCITATION LOOP
    for ip=1:Np  %ip is the feeding port
        
        disp(['+--- Exciting port ',num2str(ip),' with mode 1']);
        IC      =   zeros(1,nmode*Np);         %port excitation amplitude mode 
        ID      =   zeros(1,NNODE-iNODEc);     %port excitation fields 
        
        abp = dist(xy(1,PO(1,ip)),xy(2,PO(1,ip)),xy(1,PO(PO(MAXPO,ip),ip)),xy(2,PO(PO(MAXPO,ip),ip)));
        piabp = pi/abp;
        nel = (PO(MAXPO,ip)-1)/nord;  %number of elements per port
        i1 = (ip-1)*nmode;            %indice di base nel vettore dei modi di port
        if plane=='E'                 %plane 'E' analysis
            pia=pi/a;
            IC(i1+1)=RZ(1,ip)*abp;
            aux=cj*Bi(1,ip)*RZ(1,ip);
            for ie = 1:nel
                i1=(ie-1)*nord+1;
                i2=i1+nord;
                dx=dist(xy(1,PO(i1,ip)),xy(2,PO(i1,ip)),...
                        xy(1,PO(i2,ip)),xy(2,PO(i2,ip)));
                x1=dist(xy(1,PO( 1,ip)),xy(2,PO( 1,ip)),...
                        xy(1,PO(i1,ip)),xy(2,PO(i1,ip)));
                for j=1:nord+1
                    integ=dx*real(Pjnexpa(nord+1,j,0));
                    ID(PO(i1+j-1,ip)-iNODEc) = ID(PO(i1+j-1,ip)-iNODEc) - aux*integ;
                end
            end
        else            %plane 'H' analysis
            IC(i1+im) = -pi * RZ(im,ip)/2;
            aux = cj * piabp * im;
            aux1 = aux * Bi(im,ip) * RZ(im,ip);
            for ie=1:nel %indice di elemento sulla porta
                i1=(ie-1)*nord+1;
                i2=i1+nord;
                dx=dist(xy(1,PO(i1,ip)),xy(2,PO(i1,ip)),...
                        xy(1,PO(i2,ip)),xy(2,PO(i2,ip)));
                x1=dist(xy(1,PO( 1,ip)),xy(2,PO( 1,ip)),...
                        xy(1,PO(i1,ip)),xy(2,PO(i1,ip)));
                for j=1:nord+1
                    integ = dx*imag(exp(aux*x1)*Pjnexpa(nord+1,j,aux*dx));
                    iauxj = PO(i1+j-1,ip);
                    ID(iauxj-iNODEc) = ID(iauxj-iNODEc) + aux1*integ;
                end
            end
            if plane == 'H'
                for iport=1:Np
                    for jp=1:2
                        if (jp==1) 
                            iauxj = PO(1,iport);
                        end
                        if (jp==2) 
                            iauxj = PO(PO(MAXPO,iport),iport);
                        end
                        ID(iauxj-iNODEc) = 0;
                    end
                end
            end
        end
        
        %---------------Solution-------------------------------------------
        T = cputime;
        [B,Y] = SolverDDM(SC, IAC, BC,CD,IC,ID);
        Tsolve = cputime - T + Tsolve;
        
        %Storing results---------------------------------------------------
        disp('+----Storing results');
        for jp=1:Np
            for j=1:nmode
                s=j+(jp-1)*nmode;
                S(jp,ip,k,j) = B(s);
                fprintf(fid,'S%i%i mode %3i: %12.6e %12.6e %12.6e %12.6e\n',jp,ip,j,...
                    real(B(s)),...
                    imag(B(s)),...
                    abs(B(s)),...
                    atan2(imag(B(s)),real(B(s))));
                %---------DEBUG
                if(ip==1 & jp==1)
                    S11(k,j) = B(s);
                elseif(ip==1 & jp==2)
                    S21(k,j) = B(s);
                elseif(ip==2 & jp==1)
                    S12(k,j) = B(s);
                elseif(ip==2 & jp==2)
                    S22(k,j) = B(s);
                end
                %--------------
            end
        end
    end %port excitation loop
end %end main loop frequency
%end %end main loop material

fclose(fid);
fname = [fgeoname,'.stat'];
fid = fopen(fname,'w+');
fprintf(fid,'TIME STATS INFORMATION FILE\n\n');
fprintf(fid,'Domain Decomposition Method computational time\n');
fprintf(fid,'Matrix assembling time %6.3e\n', Tbuild);
fprintf(fid,'System solving time    %6.3e\n\n', Tsolve);
fclose(fid);

%DEBUG: PLOT DECOMPOSED MESH-----------------------------------------------


DEBUG = 1;
if DEBUG==1
    if flagout == 1 
        [Vtdir,xydir,Sdir,S11dir,S21dir,S12dir,S22dir,freq] = ehdev(fgeoname,felename,'debug.out',0);
        plot(freq,20*log10(abs(S11(:,1))),'b',freq,20*log10(abs(S11dir(:,1))),'r*');
        legend('DD-Method','Direct method');
        title('Comparison between S11dB parameter calculated by DD-Method and Direct method');
        xlabel('Frequency [Hz]');
        ylabel('S11 [dB]');
        for k = 1:nfreq
            err(k) = abs(S11(k,1)-S11dir(k,1))/abs(S11dir(k,1));
        end
        fid = fopen(fname,'a+');
        fprintf(fid,'\n\nMAXIMUM RELATIVE ERROR COMPARED WITH DIRECT METHOD\n\n');
        fprintf(fid,'e = %6.3e',max(err));
        fclose(fid);
    end
end
if (bitand(flagout,1))
    NDD = size(eleDD,2);
    color = ['r','m','y','g','b','c'];
    % Plotting della mesh
    figure;
    hold on;
    for id = 1:NDD
        elem = eleDD(2:4,id);
        for ie = 1:size(MESH{id}.ele,2)
             elem = MESH{id}.ele(2:4,ie);
             X = xy(1,elem);
             Y = xy(2,elem);
             patch(X,Y,color(mod(id,5)+1));
        end
        axis equal;
    end
    hold off;
end
%--------------------------------------------------------------------------
%------------------End of bend function------------------------------------%
%--------------------------------------------------------------------------
%%