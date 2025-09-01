function [unredModel, solVecs, results, sweep, nmode, xy, PO, Np, MESH] = ehdevDDforMOR_saar(mesh, sweep, flagout)

% get global variables
global BLOCK

% set constants
global c0 mu0 eps0 Z0
% c0   = 0.2998e9;   %[m/s]
% mu0  = pi*4e-7;    %[A/s]
% eps0 = 1 / (mu0 * c0^2);
% Z0  =   c0*mu0;     %[ohm]

%% initialize variables
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

nmode   =   1;      %number of modes to be used in expansion
nfreq   =   1;      %number of frequencies
freq    =   [];     %Frequencies [Hz]

cj = sqrt(-1);

%% read out variables
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

nfreq   =  sweep.frequency.N;
freq    =  [sweep.frequency.start];
if nfreq > 1
    freq    =   [sweep.frequency.start:(sweep.frequency.stop-sweep.frequency.start)/(nfreq-1):sweep.frequency.stop];
end


epsilon = [sweep.epsilon.start];
if sweep.epsilon.N > 1
    epsilon = [sweep.epsilon.start : (sweep.epsilon.stop - sweep.epsilon.start)./(sweep.epsilon.N-1) : sweep.epsilon.stop];
end
epsilon = epsilon - 0.01 * sqrt(-1);
mu = [sweep.mu.start];
if sweep.mu.N > 1
    mu = [sweep.mu.start : (sweep.mu.stop - sweep.mu.start)./(sweep.mu.N-1) : sweep.mu.stop];
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

% save layerShort2_fff_var MESH xy nlab iNODEc DOMAINS ND SDN ele elab elabDD eleDD; 
% load layerShort2_fff_var

% plot decomposed mesh
if (bitand(flagout,1))
    seeDD(eleDD,xy,MESH,ND);
end

% rescale to si
a   =   a*1e-3;            %from [mm] -> [m]
b   =   b*1e-3;            %from [mm] -> [m]
freq=   freq*1e9;          %from [GHz]-> [Hz]
xy  =  xy*1e-3;            %from [mm] -> [m]
sweep.frequency.freq = freq;

% checking simulation type
if(ndie > 1 & (plane=='e' | plane=='E'))
    disp('*********ERROR********** - E plane only homogeneus.');
    return;
end
if(plane=='e'),plane='E';,end
if(plane=='h'),plane='H';,end
if(plane~='E' & plane~='H')
    disp('**** ERROR **** Unrecognizable plane analisys');
end

% verify cut-off
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

%% SET the vector of the nodes on the ports
PO      =   ports(nlab,xy,Np,NNODE,dim,Lp);
fid     =   fopen(mesh.out,'w');

%% set material vectors
epsRel(1)       =   epsr;   %in waveguide-air
% vkt2(2:ndie+1)  =   Eps;    %in dielectrics  % why (ndie + 1) ?????????
sweep.epsilon.epsRel = epsilon;

nuRel(1)        =   1/mur;          %
%nuRel(2:ndie+1) =   1./Mu;    %in dielectrics  % why (ndie + 1) ?????????
sweep.nu.nuRel = 1./mu;


% vkt2(1)         =   k02*epsr*mur;   %in waveguide-air
% vcoeff(1)       =   1/mur;          %
% vkt2(2:ndie+1)  =   k02*Eps.*Mu;    %in dielectrics
% vcoeff(2:ndie+1)=   1./Mu;          %
% sweep.epsilon.vkt2 = k02*epsilon.*Mu(sweep.epsilon.mlabel);

%% Assembling
% get non-material domain block matrices
[BLOCK, CS, CT] = BuildFemDDM_saar(MESH,xy,nlab,iNODEc,PO,Np,LPEC,LPMC,ndie,material,plane, nuRel, epsRel, ND);

% get material domain block matrices
[CSd, CTd] = BuildFemDDM_epsilon_saar(MESH,xy,nlab,iNODEc,PO,Np,LPEC,LPMC,ndie,material,plane,nuRel,epsRel,ND, sweep);

% build portmodes
portModes = getPortModes(xy, PO, Np, nmode, plane, nord);

% build globla S and T matrices
[S, T, Sdiel, Tdiel] = getGlobalST(CS, CT, CSd, CTd) ;

% build compress matrix for restriction of port modes to basis functions
dimA = size(T, 1);
tfMat = getCompressMat(portModes, dimA, nmode, PO, Np);
compMatS = tfMat.' * S * tfMat;
compMatT = tfMat.' * T * tfMat;
compMatSdiel = tfMat.' * Sdiel * tfMat;
compMatTdiel = tfMat.' * Tdiel * tfMat;

% only for field visualization
unredModel.tfMat = tfMat;

% % store compressed system matrices for MOR
% unredModel.S = compMatS;
% unredModel.T = compMatT;
% unredModel.Sdiel = compMatSdiel;
% unredModel.Tdiel = compMatTdiel;

% adapt right hand side
dimCompMat = size(compMatT, 1);
rhs = buildRhs(dimCompMat, nmode, xy, PO, Np); %no freq dependency

% store rhs for MOR
unredModel.rhsVec = rhs;
unredModel.leftVec = rhs / norm(rhs);

% get subdomain blockss
[SaarBlock, CS_saar, CT_saar] = getSubDomMats(compMatS, compMatT, ND);

% adapt rhs for DD
rhs_saar = rhs((end - size(CS_saar, 1) + 1) : end, :);

% save layerShort2_fff_var;
% load layerShort2_fff_var;

for k=1:nfreq

    % print on screen
    disp(['Frequeny = ',num2str(freq(k)*1e-9),' GHz']);

%     % print on output file
%     fprintf(fid,'#Frequency = %i GHz\n',freq(k)*1e-9);

    % set the fequency dependent values
    k0=2*pi*freq(k)/c0;

    % calculate frequency depending scaling matrix for rhs
    freqScalMat = buildFreqScal(nmode, xy, PO, Np, k0);

%     % scale rhs
%     rhsFreq = rhs_saar * freqScalMat;

    % calculate shur complement for non material domains
    [SaarBlock, SC_saar] = ShurC_saar(SaarBlock, k0, ND);

    % get parameterized model of the last domain 
    [A0 Aeps Anu] = getParamModelLastDomOnly(SaarBlock, SC_saar, CS_saar, CT_saar, k0, ND);
    rhs_saarLastDom = rhs((end - size(A0, 1) + 1) : end, :) * freqScalMat;
    unredModel.A0 = A0;
    unredModel.Aeps = Aeps;
    unredModel.Anu = Anu;
    unredModel.rhsVec = rhs((end - size(A0, 1) + 1) : end, :);
    unredModel.leftVec = unredModel.rhsVec / norm(unredModel.rhsVec);
    
    for ik = 1:sweep.epsilon.N
        %Afem = S -  k0^2 * T + nuRel(sweep.epsilon.mlabel) * Sdiel - k0^2 * sweep.epsilon.epsRel(ik) * Tdiel;
        sysEps = A0 + sweep.epsilon.epsRel(ik) * Aeps;
        
        for muCnt = 1 : length(sweep.nu.nuRel)
%             % calculate shur complement of material domain (this is always the last domain)
%             [SaarBlock, SCdiel_saar] = ShurC_epsilon_saar(SaarBlock, SC_saar, CS_saar, CT_saar, k0, sweep.nu.nuRel(muCnt), ...
%                 sweep.epsilon.epsRel(ik), ND);
% 
%             % calculate solution
%             [sol_saar] = SolverDDM_saar(SaarBlock, SCdiel_saar, rhsFreq, ND);
% 
%             % store solution for MOR
%             solVecs{k, ik, muCnt} = sol_saar;
% 
%             % get impedance matrix
%             zMat = sol_saar(dimCompMat - (Np * nmode - 1) : end, :);
% 
%             % calculate s matrices and store them
%             results.sMat{ik, muCnt, k} = inv(zMat - eye(size(zMat, 1))) * (zMat + eye(size(zMat, 1)))
            
            % test purpose
            sysMat = sysEps + sweep.nu.nuRel(muCnt) * Anu;
            solVecs{k, ik, muCnt} = sysMat \ rhs_saarLastDom;
            zMatLastDom = solVecs{k, ik, muCnt}(end - (Np * nmode - 1) : end, :);
            results.sMat{ik, muCnt, k} = inv(zMatLastDom - eye(size(zMatLastDom, 1))) * (zMatLastDom + eye(size(zMatLastDom, 1)));
        end

    end

end

% fclose(fid);

% % % plot s11 parameters
% % figure;
% % for freqCnt = 1:nfreq
% %     for epsCnt = 1:sweep.epsilon.N
% %         stmp(freqCnt, epsCnt) = results.sMat{freqCnt, epsCnt}(1,1);
% %     end
% %     plot(sweep.epsilon.epsRel, abs(stmp(freqCnt, :)));
% %     xlabel('epsilon relative');
% %     ylabel('|S11|');
% %     hold all;
% % end

% % figure;
% % surf(sweep.epsilon.epsRel, freq / 1e9, abs(stmp));
% % xlabel('epsilon relative')
% % ylabel('frequency (GHz)')
% % zlabel('|S11|')

