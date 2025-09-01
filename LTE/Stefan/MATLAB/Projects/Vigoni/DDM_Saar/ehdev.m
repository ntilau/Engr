function [Vt,xy,S11,S21,S12,S22,results,freq] = ehdev(fgeoname,felename,foutname,flagout)

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
xy   =   [];     %coordinate node matrix
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

if nargin == 3
    T_setup = cputime;
    flagout = foutname;
    sweep = felename;
    mesh = fgeoname;
    clear fgeoname;
    clear foutname;
    fgeoname = mesh.fine;
    foutname = mesh.out;
    Np = mesh.Np;
    a =  mesh.a      ;
    b = mesh.b      ;
    Lp = mesh.plab   ;
    Lpec = mesh.PEClab ;
    Lpmc = mesh.PMClab ;
    nmode = mesh.nmode  ;
    plane = mesh.plane ;
    ndie = mesh.ndie  ;
    Eps = mesh.Eps    ;
    Mu = mesh.Mu     ;
    material = [1,mesh.mlab]   ;
    
    freq = sweep.frequency.start ;
    nfreq = sweep.frequency.N;
    if nfreq>1
        freq    =   [sweep.frequency.start:(sweep.frequency.stop-sweep.frequency.start)/(sweep.frequency.N-1):sweep.frequency.stop]; 
    end   
    epsilon = [sweep.epsilon.start];
    if sweep.epsilon.N > 1
        epsilon = [sweep.epsilon.start : (sweep.epsilon.stop - sweep.epsilon.start)./(sweep.epsilon.N-1) : sweep.epsilon.stop];
    end
    
    
    [xy,ele,d1,nlab,elab,d2,NNODE,NELE,d3] = ReadMesh(fgeoname);
    T_setup = cputime - T_setup;
else
    %----------------STARTUP    
    disp('+---Reading mesh file.');
    [xy,ele,d1,nlab,elab,d2,NNODE,NELE,d3] = ReadMesh(fgeoname);
    clear d1;
    clear d2;
    clear d3;
    disp('+---Reading electromagnetic file.');
    fid     =   fopen(felename,'r');
    Np      =   fscanf(fid,'%i',1); fgets(fid);
    a       =   fscanf(fid,'%e',Np); fgets(fid);
    b       =   fscanf(fid,'%e',Np); fgets(fid);
    Lp      =   fscanf(fid,'%i',Np); fgets(fid);
    Lpec    =   fscanf(fid,'%i',1); fgets(fid);
    Lpmc    =   fscanf(fid,'%i',1); fgets(fid);
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
    if nfreq>1
        freq    =   [freq(1):(freq(2)-freq(1))/(nfreq-1):freq(2)]; 
    end    
    fclose(fid);
end
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

% SET the vector of the nodes on the ports
PO      =   ports(nlab,xy,Np,NNODE,dim,Lp);
MAXPO   =   size(PO,1);
%------------------opens the output file
fid=fopen(foutname,'w');

%MAIN FREQUENCY LOOP
% % sweep.epsilon.N = 1;
% % sweep.epsilon.mlabel = 1;
% % epsilon(1) = 1;
for idiele = 1:sweep.epsilon.N
    Eps(sweep.epsilon.mlabel) = epsilon(idiele);
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
            vkt2(1)     =   k02*epsr*mur-(pi/a(1))*(pi/a(1));
            vcoeff(1)   =   1/epsr;
        end
        
        %-------known vector building
        if(ele(1,1)==3 | ele(1,1)==4)
            nord=1;
        else
            nord=2;
        end
        %----------------------------------------------------------------------------------------------------------
        %PORT EXCITATION LOOP
        im = 1;
        %FEM, AC BC AND CD MATRIX BUILDING---------------------------------------------------------------------------------------
        %This matrices are indipendent by the feeding port
        Tbuild = cputime;
        [FEM]       =   BuildFem(ele,xy,nlab,elab,NELE,NNODE,PO,Np,Lpec,Lpmc,ndie,material,plane,vcoeff,vkt2);
        [AC,Bi,RZ]  =   BuildAC(xy,PO,a,k0,Z0,Np,nmode,plane);
        [BC,CD]     =   BuildBC_CD(xy,Bi,RZ,PO,a,k0,Z0,Np,nmode,plane,nord);
        Tbuild = cputime - Tbuild;
        
        for ip=1:Np  %ip is the feeding port
            
            
            disp(['+--- Exciting port ',num2str(ip),' with mode 1']);
            IC      =   zeros(1,nmode*Np);  %port excitation amplitude mode 
            ID      =   zeros(1,NNODE);     %port excitation fields 
            
            abp = dist(xy(1,PO(1,ip)),xy(2,PO(1,ip)),xy(1,PO(PO(MAXPO,ip),ip)),xy(2,PO(PO(MAXPO,ip),ip)));
            piabp = pi/abp;
            nel = (PO(MAXPO,ip)-1)/nord;  %number of elements per port
            i1 = (ip-1)*nmode;            %indice di base nel vettore dei modi di port
            if plane=='E'               %plane 'E' analysis
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
                        ID(PO(i1+j-1,ip)) = ID(PO(i1+j-1,ip)) - aux*integ;
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
                        ID(iauxj) = ID(iauxj) + aux1*integ;
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % da qui impongo le condizioni al contorno a modo mio
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if plane == 'H'
                    for iport=1:Np
                        for jp=1:2
                            if (jp==1) 
                                iauxj = PO(1,iport);
                            end
                            if (jp==2) 
                                iauxj = PO(PO(MAXPO,iport),iport);
                            end
                            ID(iauxj) = 0;
                        end
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%
                %qui riprende il listato originale di giacomo
                %%%%%%%%%%%%%%%%%%%%%%%%%
            end
            
            %---------------Solution
            %          [V1,V2]=BlockSolver(AC,BC,CD,FEM,IC,ID,flagout);
            M = [AC,BC;CD,FEM];
            I = [IC.';ID.'];
            Tsolve = cputime;
%             spparms('spumoni',1)
            V0 = M\I;
            Tsolve = cputime - Tsolve;
            V1= V0(1:length(IC));
            V2= V0(length(IC)+1:length(V0));
            Vt(:,ip,k)=V2;
            %Storing results
            disp('+----Storing results');
            for jp=1:Np
                for j=1:nmode
                    s=j+(jp-1)*nmode;
                    results.epsilon{idiele}.S(jp,ip,k,j) = V1(s);
                    fprintf(fid,'S%i%i mode %3i: %12.6e %12.6e %12.6e %12.6e\n',jp,ip,j,...
                        real(V1(s)),...
                        imag(V1(s)),...
                        abs(V1(s)),...
                        atan2(imag(V1(s)),real(V1(s))));
                    %---------DEBUG
                    if(ip==1 & jp==1)
                        S11(k,j) = V1(s);
                    elseif(ip==1 & jp==2)
                        S21(k,j) = V1(s);
                    elseif(ip==2 & jp==1)
                        S12(k,j) = V1(s);
                    elseif(ip==2 & jp==2)
                        S22(k,j) = V1(s);
                    end
                    %--------------
                end
                if flagout==1
                    writecres('fields.out',V2,NNODE,1,'M')  
                end
            end
        end %port excitation loop
    end %end main loop frequency
end
fclose(fid);
fname = [mesh.fine,'.stat'];
fid = fopen(fname,'a+');
fprintf(fid,'\n\n Direct FE Method computational time\n');
fprintf(fid,'Setup time %6.3e\n', T_setup);
fprintf(fid,'Matrix assembling time %6.3e Global iter assembling time %6.3e\n', [Tbuild,Tbuild*sweep.epsilon.N]);
fprintf(fid,'System solving time    %6.3e Global solving time %6.3e\n', [Tsolve,Tsolve*2*sweep.epsilon.N]);
fprintf(fid,'Global time %6.3e\n', T_setup+Tbuild*sweep.epsilon.N+Tsolve*2*sweep.epsilon.N);
fclose(fid);

%------------------End of bend function------------------------------------%
%--------------------------------------------------------------------------
%%