function [BLOCK, CS, CT] = BuildFemDDM_saar(MESH, xy, nlab, iNODEc, PO, Np, LPEC, LPMC, ndie, material, plane, nuRel, epsRel, ND)

% global BLOCK;

%NUMBER OF GLOBAL NODEs
NNODEg = size(xy,2);
%NUMBER OF INTERNAL NODEs
NNODEi = iNODEc;
%NUMBER OF BOUNDARY NODEs
NNODEb = NNODEg - iNODEc;

CS = spalloc(NNODEb,NNODEb,NNODEb);
CT = spalloc(NNODEb,NNODEb,NNODEb);

% SUB-DOMAIN CYCLE
for d = 1:(ND-1)

    NNODE= MESH{d}.NNODEi;        %Subdomain internal node number
    ele  = MESH{d}.ele;           %Subdomain internal element map
    elab = MESH{d}.elab;          %Element lables
    ibase= MESH{d}.BASE;          %Internal nodes base index in to the "xy" vector
    NELE = size(ele,2);           %Subdomain element number
    clear M;

    MS = spalloc(NNODE, NNODE, NNODE);   %Subdomain nodes interaction FEM-matrix
    ES = spalloc(NNODE, NNODEb,NNODE);   %Subdomain\Boundary nodes interaction FEM-matrix
    FS = spalloc(NNODEb,NNODE, NNODE);   %Boundary\Subdomain nodes interaction FEM-matrix
    
    MT = spalloc(NNODE, NNODE, NNODE);   %Subdomain nodes interaction FEM-matrix
    ET = spalloc(NNODE, NNODEb,NNODE);   %Subdomain\Boundary nodes interaction FEM-matrix
    FT = spalloc(NNODEb,NNODE, NNODE);   %Boundary\Subdomain nodes interaction FEM-matrix

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

                cauxS = nuRel(imat) * Se(j,k);
                cauxT = epsRel(imat) * Te(j,k);

                if not((iauxi==LPEC & plane == 'H') | (iauxi==LPMC & plane == 'E')) %% J: NOT PEC
                    if not((iauxw==LPEC & plane == 'H') | (iauxw==LPMC & plane == 'E')) %% J: NOT PEC -- K: NOT PEC

                        % M-matrix storage
                        if (iauxj<=NNODEi) & (iauxk<=NNODEi)
                            MS(iauxj-ibase,iauxk-ibase)  = MS(iauxj-ibase,iauxk-ibase) + cauxS;
                            MT(iauxj-ibase,iauxk-ibase)  = MT(iauxj-ibase,iauxk-ibase) + cauxT;
                            % E-matrix storage
                        elseif(iauxj<=NNODEi) & (iauxk>NNODEi)
                            ES(iauxj-ibase,iauxk-iNODEc) = ES(iauxj-ibase,iauxk-iNODEc) + cauxS;
                            ET(iauxj-ibase,iauxk-iNODEc) = ET(iauxj-ibase,iauxk-iNODEc) + cauxT;
                        elseif(iauxj>NNODEi)  & (iauxk<=NNODEi) %=> F-matrix storage
                            FS(iauxj-iNODEc,iauxk-ibase) = FS(iauxj-iNODEc,iauxk-ibase) + cauxS;
                            FT(iauxj-iNODEc,iauxk-ibase) = FT(iauxj-iNODEc,iauxk-ibase) + cauxT;
                        else %=> C-matrix storage
                            CS(iauxj-iNODEc,iauxk-iNODEc) = CS(iauxj-iNODEc,iauxk-iNODEc) + cauxS;
                            CT(iauxj-iNODEc,iauxk-iNODEc) = CT(iauxj-iNODEc,iauxk-iNODEc) + cauxT;
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

                    %impose BC
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

    BLOCK{d} = struct('MS',MS,'ES',ES,'FS',FS, 'MT',MT,'ET',ET,'FT',FT);

end % END OF CYCLE ON SUBDOMAINS
return
