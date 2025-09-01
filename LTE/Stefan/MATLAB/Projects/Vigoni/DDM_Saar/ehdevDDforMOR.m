function [results,freq] = ehdevDD(mesh,sweep,flagout)
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

global BLOCK
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
Np      =   mesh.Np;
a       =   mesh.a;
b       =   mesh.b;
Lp      =   mesh.plab;
LPEC    =   mesh.PEClab;
LPMC    =   mesh.PMClab;
nmode   =   mesh.nmode;
plane   =   mesh.plane;
ndie    =   mesh.ndie;
Eps     =   mesh.Eps;
Mu      =   mesh.Mu;
material=   mesh.mlab;

nfreq   =  sweep.frequency.N;                                %numero di punti in frequenza da calcolare
freq    =  [sweep.frequency.start];    %estremi delle frequenze
if nfreq > 1
    freq    =   [sweep.frequency.start:(sweep.frequency.stop-sweep.frequency.start)/(nfreq-1):sweep.frequency.stop]; 
end  

epsilon = [sweep.epsilon.start];
if sweep.epsilon.N > 1
    epsilon = [sweep.epsilon.start : (sweep.epsilon.stop - sweep.epsilon.start)./(sweep.epsilon.N-1) : sweep.epsilon.stop];
end
T_setup = cputime;
disp('+---Reading mesh file.');
[xy,ele,spig,nlab,elab,edgelab,NNODE,NELE,NSPIG] = ReadMesh(mesh.fine);
clear spig;
clear edgelab;
clear NSPIG;

disp('+---Reading domains file.');
[xyDD,eleDD,spigDD,nlabDD,elabDD,edgelabDD,NNODEDD,NELEDD,NSPIGDD] = ReadMesh(mesh.dd);
clear spigDD;
clear edgelabDD;
clear NSPIGDD;

disp('+---Decomposing geometry in sub-domains.');
[DOMAINS,ND,SDN] = meshDD(xy,ele,xyDD,eleDD,elabDD);
[MESH,xy,nlab,iNODEc] = reordering(xy,xyDD,nlab,ele,elab,eleDD,DOMAINS,ND,SDN,LPEC,Lp);

%--------------- saar code ------------------
% globalPos = getGlobalElemIdOfDomain(3, MESH, ele)
%--------------- saar code end --------------

T_setup = cputime - T_setup;
%DEBUG: PLOT DECOMPOSED MESH-----------------------------------------------
if (bitand(flagout,1))
    seeDD(eleDD,xy,MESH,ND);
end
%--------------------------------------------------------------------------

%------------------Rescale everything to MKS-unit system
a   =   a*1e-3;            %from [mm] -> [m]
b   =   b*1e-3;            %from [mm] -> [m]
freq=   freq*1e9;          %from [GHz]-> [Hz]
xy  =  xy*1e-3;            %from [mm] -> [m]
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
%mesh.out = 'empty_out.out';
fid     =   fopen(mesh.out,'w');
    
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
        sweep.epsilon.vkt2 = k02*epsilon.*Mu(sweep.epsilon.mlabel);
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
    Tbuild = cputime;
    [AC,Bi,RZ]  =   BuildAC(xy,PO,a,k0,Z0,Np,nmode,plane);
    [BC,CD]     =   BuildBCCDDDM(xy,Bi,RZ,PO,a,k0,Z0,Np,nmode,plane,nord,iNODEc);
    [BLOCK,C]   =   BuildFemDDM(MESH,xy,nlab,iNODEc,PO,Np,LPEC,LPMC,...
                                 ndie,material,plane,vcoeff,vkt2,sweep,ND);
                             
    %----------------------------------------------------------------------
    
    Tbuild = cputime - Tbuild;
    Tsolve = cputime;
    [SC, IAC] = ShurC(AC,BC,CD,sweep,C);
    Tsolve = cputime - Tsolve;
    
    %-------------saar code------------------------------------------------
    
    
    
    %-------------saar code end--------------------------------------------
    
    % LA MARTICE M DEL BLOCCO IN CUI VARIA IL DIELETTRICO VA RIASSEMBLATA
    % CICLO PER CICLO
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
        
        for ik = 1:sweep.epsilon.N
            Tsolveiter = cputime;
            [Cdiel]   =   BuildFemDDM_epsilon(MESH,xy,nlab,iNODEc,PO,Np,LPEC,LPMC,...
                ndie,material,plane,vcoeff,vkt2,sweep,ND,C,ik);
            [SCdiel] = ShurC_epsilon(AC,BC,CD,sweep,SC,Cdiel);
                     
            [B,Y,E] = SolverDDM(SCdiel, IAC,BC,CD,IC,ID,sweep,ND,ik);
            results.epsilon{ik}.Y{k} = Y;
            results.epsilon{ik}.E{k} = E;
            results.epsilon{ik}.C{k} = Cdiel;
            results.epsilon{ik}.SC{k} = SCdiel;
            results.AC{k} = AC;
            results.BC{k} = BC;
            results.CD{k} = CD;
            Tsolveiter = cputime - Tsolveiter;
            
            % ----build global system (saar)--------
            [Asys, Afem, rhs] = buildGlobalSystem(AC, BC, CD, Cdiel, IC, ID, MESH, xy, nlab, iNODEc) ;
            saar_result.A{k} = Asys;
            saar_result.rhs{k} = rhs;
            saar_result.x{k} = Asys\rhs;
            saar_result.b{k} = saar_result.x{k}(1:size(BC,1));
            dimM = size(Asys,1)-size(BC,1)-size(Cdiel, 1) ;
            saar_result.e{k} = saar_result.x{k}((size(BC,1)+1):(size(BC,1)+dimM)) ;
            saar_result.y{k} = saar_result.x{k}((size(BC,1)+dimM+1):end) ;
            
            B = saar_result.b{k};
            
            % get port modes
            portModes = getPortModes(xy, PO, Np, nmode, plane, nord);
            
            % get compressed matrix
            [compMat, tfMat] = getCompMat(portModes, Afem, nmode, PO, Np);
            
            % adapt right hand side
            dimCompMat = size(compMat, 1);
            [rhs] = buildRhs(dimCompMat, nmode, xy, PO, Np, k0, Z0);
            
            % get subdomain blockss
            [SaarBlock, C_saar] = getSubDomMats(compMat, tfMat, Np, nmode, ND);
            rhs_saar = rhs((end - size(C_saar, 1) + 1) : end, :);
            
            % Solve with DD
            [SaarBlock, SC_saar] = ShurC_saar(SaarBlock, ND); % should be done out of material loop
            [SaarBlock, SCdiel_saar] = ShurC_epsilon_saar(SaarBlock, SC_saar, C_saar, ND);
            [sol_saar] = SolverDDM_saar(SaarBlock, SCdiel_saar, rhs_saar, ND);
            % Solve with DD end
            
            % solve system
            sol = compMat \ rhs;
            maxError = max(max(abs(sol - sol_saar)));
            disp(sprintf('maxErr = %e', maxError));
            zMat = sol(dimCompMat - (Np * nmode - 1) : end, :);
            res.sMat{ik} = inv(zMat + eye(size(zMat, 1))) * (zMat - eye(size(zMat, 1)));
            
            mySuperS{k}.sMat{ik} = res.sMat{ik};
            
            figure(2);
            solFull.sol{ik} = tfMat * sol;
            scatter(xy(1,:), xy(2,:), 5, imag(solFull.sol{ik}(:, 1)));
            
            
% %             % get number of nodes on port
% %             lenPO = [PO(MAXPO, 1), PO(MAXPO, 2)];
% %             
% %             % plot modes on port
% %             xtemp = zeros(length(saar_result.x{k}), 1);
% %             
% %             % offset
% %             offset = size(AC, 1);
% %             
% %             for ii = 1:nmode
% %                 figure(ii+1);
% %                 xtemp(offset+PO(1:lenPO(2),2)) = portModes(ii, 1:lenPO(2));
% % %                 btemp = xtemp(1:size(BC,1));
% %                 dimM = size(Asys,1)-size(BC,1)-size(Cdiel, 1);
% %                 etemp = xtemp((size(BC,1)+1):(size(BC,1)+dimM));
% %                 ytemp = xtemp((size(BC,1)+dimM+1):end);
% %                 
% %                 scatter(xy(1,:), xy(2,:), 5, real([etemp', ytemp']));
% %             end
            % plot solution
%             figure(ik);
%             scatter(xy(1,:), xy(2,:), 5, real(results.epsilon{ik}.E{k}));
%             scatter(xy(1,:), xy(2,:), 5, real([saar_result.e{k};
%             saar_result.y{k}]));
            
            % ----end build global system (saar)---- 
            
            %Storing results---------------------------------------------------
            disp('+----Storing results');
            
            
            
            for jp=1:Np
                for j=1:nmode
                    s=j+(jp-1)*nmode;
                    results.epsilon{ik}.S(jp,ip,k,j) = B(s);
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
        end
    end %port excitation loop
end %end main loop frequency
%end %end main loop material

fclose(fid);
fname = [mesh.fine,'.stat'];
fid = fopen(fname,'w+');
fprintf(fid,'TIME STATS INFORMATION FILE\n\n');
fprintf(fid,'Domain Decomposition Method computational time\n');
fprintf(fid,'Setup time %6.3e\n', T_setup);
fprintf(fid,'Matrix assembling time %6.3e\n', Tbuild);
fprintf(fid,'Not changing system solving time    %6.3e\n', Tsolve);
fprintf(fid,'Iterative system solving time    %6.3e   Global system solving time  %6.3e \n', [Tsolveiter, Tsolveiter*2*sweep.epsilon.N]);
fprintf(fid,'Global time %6.3e\n', T_setup+Tbuild+Tsolve+Tsolveiter*2*sweep.epsilon.N);
fclose(fid);

%DEBUG: PLOT DECOMPOSED MESH-----------------------------------------------


DEBUG = 1;
if DEBUG==1
    if flagout == 1 
        [Vtdir,xydir,S11dir,S21dir,S12dir,S22dir,resultsdir,freq] = ehdev(mesh,sweep,1);
        clear S11
        clear S11dir
%         for i = 1:sweep.epsilon.N
%             figure;
%             for k = 1:length(freq)
%                 S11(k) = results.epsilon{i}.S(1,1,k,1);
%                 S11dir(k) = resultsdir.epsilon{i}.S(1,1,k,1);
%             end
%             plot(freq,20*log10(abs(S11)),'b',freq,20*log10(abs(S11dir)),'r*');
%             legend('DD-Method','Direct method');
%             str = ['Comparison between S11dB parameter calculated by DD-Method and Direct method. Epsilon = ',num2str(epsilon(i))];
%             title(str);
%             xlabel('Frequency [Hz]');
%             ylabel('S11 [dB]');
%        
% %             for k = 1:nfreq
% %                 err(k) = abs(S11(k,1)-S11dir(k,1))/abs(S11dir(k,1));
% %             end
% %             fid = fopen(fname,'a+');
% %             fprintf(fid,'\n\nMAXIMUM RELATIVE ERROR COMPARED WITH DIRECT METHOD\n\n');
% %             fprintf(fid,'e = %6.3e',max(err));
% %             fclose(fid);
%         end
        for k = 1:length(freq)
            figure;
            for i = 1:sweep.epsilon.N
                S11(i) = results.epsilon{i}.S(1,1,k,1);
                S11dir(i) = resultsdir.epsilon{i}.S(1,1,k,1);
            end
            plot(epsilon,20*log10(abs(S11)),'b',epsilon,20*log10(abs(S11dir)),'r*');
            legend('DD-Method','Direct method');
            str = ['Comparison between S11dB parameter calculated by DD-Method and Direct method. Frequency = ',num2str(freq(k))];
            title(str);
            xlabel('Relative Permittivity');
            ylabel('S11 [dB]');
        end
    end
end

%-------------------saar---------------------------
for epsCnt = 1:sweep.epsilon.N
    stmp(epsCnt) = res.sMat{epsCnt}(1,1);
    sFlorenz(epsCnt) = results.epsilon{epsCnt}.S(1,1,1,1);
    errS11(epsCnt) = abs(stmp(epsCnt) - sFlorenz(epsCnt));
    xtmp(epsCnt) = resultsdir.epsilon{i}.S(1,1,1,1);
end

for freqCnt = 1:nfreq
    for epsCnt = 1:sweep.epsilon.N
        mySuperS11(freqCnt, epsCnt) = mySuperS{freqCnt}.sMat{epsCnt}(1,1);
    end
end
figure;
% plot(20*log10(abs(sFlorenz)), '--rs');
plot((abs(sFlorenz)), '--r*');
hold on;
% plot(20*log10(abs((stmp))));
plot((abs((stmp))));
legend('Florenz','Saar');
figure;
plot(errS11);
title('error of S11');
figure;
plot(real(stmp), imag(stmp), '*b');
hold on;
plot(real(sFlorenz), imag(sFlorenz), '*r');
legend('Saar','Florenz');
%-------------------end saar-----------------------

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