function [CS, CT] = BuildFemDDM_epsilon_saarMulEpsMulDom(MESH,xy,nlab,iNODEc,PO,Np,LPEC,LPMC,ndie,material,plane,nuRel,epsRel,ND, sweep, nrOfMatDom)

% get global variable
global BLOCK;

%NUMBER OF GLOBAL NODEs
NNODEg = size(xy,2);
%NUMBER OF INTERNAL NODEs
NNODEi = iNODEc;
%NUMBER OF BOUNDARY NODEs
NNODEb = NNODEg - iNODEc;

CS = spalloc(NNODEb,NNODEb,NNODEb);
CT = spalloc(NNODEb,NNODEb,NNODEb);

% read out material labels
matLab = zeros(length(sweep.epsilon), 1) ;
for epsCnt = 1 : length(sweep.epsilon)
  matLab(epsCnt) = sweep.epsilon{epsCnt}.mlabel ;
end


% SUB-DOMAIN CYCLE
for d = (ND-nrOfMatDom+1):ND

    NNODE= MESH{d}.NNODEi;        %Subdomain internal node number
    ele  = MESH{d}.ele;           %Subdomain internal element map
    elab = MESH{d}.elab;          %Element lables
    ibase= MESH{d}.BASE;          %Internal nodes base index in to the "xy" vector
    NELE = size(ele,2);           %Subdomain element number
    clear M;
    
%     for epsCnt = 1 : length(sweep.epsilon)
      MSmtr = spalloc(NNODE, NNODE, NNODE);   %Subdomain nodes interaction FEM-matrix
      MTmtr = spalloc(NNODE, NNODE, NNODE);   %Subdomain nodes interaction FEM-matrix
%     end
    
    MS = spalloc(NNODE, NNODE, NNODE);   %Subdomain nodes interaction FEM-matrix
    ES = spalloc(NNODE, NNODEb,NNODE);   %Subdomain\Boundary nodes interaction FEM-matrix
    FS = spalloc(NNODEb,NNODE, NNODE);   %Boundary\Subdomain nodes interaction FEM-matrix
    
    MT = spalloc(NNODE, NNODE, NNODE);   %Subdomain nodes interaction FEM-matrix
    ET = spalloc(NNODE, NNODEb,NNODE);   %Subdomain\Boundary nodes interaction FEM-matrix
    FT = spalloc(NNODEb,NNODE, NNODE);   %Boundary\Subdomain nodes interaction FEM-matrix
    
    cauxSmtr = 0;
    cauxTmtr = 0;
    cauxSd = 0;
    cauxTd = 0;

    %main loop on elements
    for ie =1:NELE
        %Set the material of the element to build up
        imat=1;
        if plane =='H'
            for i=1:ndie
                if (elab(ie)==material(i))
                    imat = i; %material identification
                end
            end
        end
        %------------Builds the element matrices
        lds =   ele(1,ie);      %element type and order
        [Se,Te] =   elenmat(xy,ele,ie,lds,lds);
        if (nnz(Se.' - Se) ~= 0)
            aa = 1;
        end
        if (nnz(Te.' - Te) ~= 0)
            bb = 1;
        end
        %------------Builds the global subdomain matrix
        for j=1:ele(1,ie)
            iauxj  =   ele(j+1,ie);    %global index
            iauxi  =   nlab(iauxj);    %global index label
            for k = 1:ele(1,ie)
                iauxk = ele(k+1,ie);
                iauxw = nlab(iauxk);    %global index label
                
                
                if ~isempty(find(imat == matLab, 1))
                     cauxSmtr = Se(j,k);
                     cauxTmtr = Te(j,k);
                     mtrFlag = 1;
                else
                     cauxSd = nuRel(imat) * Se(j,k);
                     cauxTd = epsRel(imat) * Te(j,k);
                     mtrFlag = 0;
                end

                if not((iauxi==LPEC & plane == 'H') | (iauxi==LPMC & plane == 'E')) %% J: NOT PEC
                    if not((iauxw==LPEC & plane == 'H') | (iauxw==LPMC & plane == 'E')) %% J: NOT PEC -- K: NOT PEC

                        % M-matrix storage
                        if (iauxj<=NNODEi) & (iauxk<=NNODEi)
                            if mtrFlag
                                MSmtr(iauxj-ibase,iauxk-ibase)  = MSmtr(iauxj-ibase,iauxk-ibase) + cauxSmtr;
                                MTmtr(iauxj-ibase,iauxk-ibase)  = MTmtr(iauxj-ibase,iauxk-ibase) + cauxTmtr;
                            else
                                MS(iauxj-ibase,iauxk-ibase)  = MS(iauxj-ibase,iauxk-ibase) + cauxSd;
                                MT(iauxj-ibase,iauxk-ibase)  = MT(iauxj-ibase,iauxk-ibase) + cauxTd;
                            end
                            % E-matrix storage
                        elseif(iauxj<=NNODEi) & (iauxk>NNODEi)
%                             ESmtr(iauxj-ibase,iauxk-iNODEc) = ESmtr(iauxj-ibase,iauxk-iNODEc) + cauxSmtr;
%                             ETmtr(iauxj-ibase,iauxk-iNODEc) = ETmtr(iauxj-ibase,iauxk-iNODEc) + cauxTmtr;
                            ES(iauxj-ibase,iauxk-iNODEc) = ES(iauxj-ibase,iauxk-iNODEc) + cauxSd;
                            ET(iauxj-ibase,iauxk-iNODEc) = ET(iauxj-ibase,iauxk-iNODEc) + cauxTd;
                        elseif(iauxj>NNODEi)  & (iauxk<=NNODEi) %=> F-matrix storage
%                             FSmtr(iauxj-iNODEc,iauxk-ibase) = FSmtr(iauxj-iNODEc,iauxk-ibase) + cauxSmtr;
%                             FTmtr(iauxj-iNODEc,iauxk-ibase) = FTmtr(iauxj-iNODEc,iauxk-ibase) + cauxTmtr;
                            FS(iauxj-iNODEc,iauxk-ibase) = FS(iauxj-iNODEc,iauxk-ibase) + cauxSd;
                            FT(iauxj-iNODEc,iauxk-ibase) = FT(iauxj-iNODEc,iauxk-ibase) + cauxTd;
                        else %=> C-matrix storage
%                             CSmtr(iauxj-iNODEc,iauxk-iNODEc) = CSmtr(iauxj-iNODEc,iauxk-iNODEc) + cauxSmtr;
%                             CTmtr(iauxj-iNODEc,iauxk-iNODEc) = CTmtr(iauxj-iNODEc,iauxk-iNODEc) + cauxTmtr;
                            CS(iauxj-iNODEc,iauxk-iNODEc) = CS(iauxj-iNODEc,iauxk-iNODEc) + cauxSd;
                            CT(iauxj-iNODEc,iauxk-iNODEc) = CT(iauxj-iNODEc,iauxk-iNODEc) + cauxTd;
                        end

                    else %% J: NOT PEC -- K: PEC
                        
                        CS(iauxk-iNODEc,:)=0;
                        CS(:,iauxk-iNODEc)=0;
                        CS(iauxk-iNODEc,iauxk-iNODEc) = 1;
                        
                        CT(iauxk-iNODEc,:)=0;
                        CT(:,iauxk-iNODEc)=0;
                        CT(iauxk-iNODEc,iauxk-iNODEc) = 0;
                        
                    end

                elseif not((iauxw==LPEC & plane == 'H') | (iauxw==LPMC & plane == 'E')) %% J: PEC -- K: NOT PEC

                    %impose BC
                    
                    CS(iauxj-iNODEc,:)=0;
                    CS(:,iauxj-iNODEc)=0;
                    CS(iauxj-iNODEc,iauxj-iNODEc) = 1;
                    
                    CT(iauxj-iNODEc,:)=0;
                    CT(:,iauxj-iNODEc)=0;
                    CT(iauxj-iNODEc,iauxj-iNODEc) = 0;

                else %% J: PEC -- K: PEC
                    
                    CS(iauxk-iNODEc,:)=0;
                    CS(:,iauxk-iNODEc)=0;
                    CS(iauxk-iNODEc,iauxk-iNODEc) = 1;
                    CS(iauxj-iNODEc,:)=0;
                    CS(:,iauxj-iNODEc)=0;
                    CS(iauxj-iNODEc,iauxj-iNODEc) = 1;
                    
                    CT(iauxk-iNODEc,:)=0;
                    CT(:,iauxk-iNODEc)=0;
                    CT(iauxk-iNODEc,iauxk-iNODEc) = 0;
                    CT(iauxj-iNODEc,:)=0;
                    CT(:,iauxj-iNODEc)=0;
                    CT(iauxj-iNODEc,iauxj-iNODEc) = 0;

                end
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
                
                ES(:,iauxj-iNODEc) = zeros(1,NNODE);
                FS(iauxj-iNODEc,:) = zeros(1,NNODE);
                CS(iauxj-iNODEc,:) = zeros(1,NNODEb);
                CS(:,iauxj-iNODEc) = zeros(1,NNODEb);
                CS(iauxj-iNODEc,iauxj-iNODEc) = 1;
                
                ET(:,iauxj-iNODEc) = zeros(1,NNODE);
                FT(iauxj-iNODEc,:) = zeros(1,NNODE);
                CT(iauxj-iNODEc,:) = zeros(1,NNODEb);
                CT(:,iauxj-iNODEc) = zeros(1,NNODEb);
                CT(iauxj-iNODEc,iauxj-iNODEc) = 0;
            end
        end
    end

%     BLOCK{d} = struct('MSmtr',MSmtr, 'MTmtr',MTmtr,'MS',MS,'ES',ES,'FS',FS, 'MT',MT,'ET',ET,'FT',FT);
    BLOCK{d}.MSmtr = MSmtr;
    BLOCK{d}.MTmtr = MTmtr;
    BLOCK{d}.MS = MS;
    BLOCK{d}.ES = ES;
    BLOCK{d}.FS = FS;
    BLOCK{d}.MT = MT;    
    BLOCK{d}.ET = ET;
    BLOCK{d}.FT = FT;

    
    

end % END OF CYCLE ON SUBDOMAINS
return