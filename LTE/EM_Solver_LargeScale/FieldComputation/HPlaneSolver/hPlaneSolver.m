% compute fields and network parameters of a H-plane structure. 
function [sMat, zMat] = hPlaneSolver(Model)

fprintf(1, '\nRead Mesh and build topology...');
Mesh = meshReader(strcat(Model.path, Model.name));
Mesh = reorderMeshComponents(Mesh);
Model.Mesh = setPolyObjectRelations(Mesh);
plotMesh(Model.Mesh);
[Model.Geo, Model.nPorts] = geometryReader(Model);

%% assemble stiffness and mass matrix
fprintf('\n\nSystem matrix assembly...');
Model.nDofsRaw = getNumberOfDofs(Model);

SysMatRaw = assembleSystemMatrices(Model);

% impose dirichlet boundary conditions in main equation system
tic
[SysMatRaw, dirMarker] = imposeDirichlet(Model, SysMatRaw);
toc

iMassMat = findMatrixIndex(SysMatRaw, 'k^2 matrix');
massMatDiag = diag(SysMatRaw(iMassMat).val(~dirMarker, ~dirMarker));
condScale = 2 / abs(max(massMatDiag) + min(massMatDiag));

% S-matrix
sMat = cell(Model.nFreqs, 1);
zMat = cell(Model.nFreqs, 1);
SysMat = SysMatRaw;
% count actual FE-matrices, discarding port-related ident matrices
nFeMatrices = length(SysMatRaw);
tic
for iFreq = 1:Model.nFreqs;
    
    % print status message on command line
    fprintf('\nFrequency step: %d of %d steps\n', iFreq, Model.nFreqs);
    
    k0 = f2k(Model.f(iFreq));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % port compression
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
    [C, Port] = createModeRestrictionOperator(Model, k0, condScale);  

    if iFreq == 1
        % plot port-solution
        figure(2);
        plot(Port(1).field(:,1), Port(1).field(:,2), 'x');
    end
    
    for k = 1:nFeMatrices
        SysMat(k).val = C' * SysMatRaw(k).val * C;
    end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % set up system of equations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % new size of compressed system matrices
    Model.nDofs = size(SysMat(1).val, 1);
    % index of port-related dofs
    Model.portDof = (Model.nDofs - Model.nPorts + 1):Model.nDofs;
        
    % set right-hand-side 
    rhsRaw = sparse(Model.portDof, 1:Model.nPorts, condScale^2,...
        Model.nDofs, Model.nPorts);
    if Model.Flag.impedanceFormulation
        rhs = 1j / Model.c0 * Model.mu0 * rhsRaw;        
    else
        rhs =  2j / Model.c0 * Model.mu0 * rhsRaw;
        % add excitation-coefficient-matrices to the system matrix        
        for iPort = 1:Model.nPorts
            iMatrix = nFeMatrices + iPort;
            iRow = Model.portDof(iPort);
            iCol = Model.portDof(iPort);
            value = 1j / Model.c0 / k0 * Model.mu0 * condScale^2;
            
            SysMat(iMatrix).name = sprintf('portIdent_%d', iPort - 1);
            SysMat(iMatrix).val = sparse(iRow, iCol, value, ...
                Model.nDofs, Model.nDofs);
            SysMat(iMatrix).paramList(1).param{1} = 'k0';
        end       
    end
    
    % build system matrix for working frequency
    Param = setParameters('k0', k0);
    mA = buildFemMatrix(SysMat, Param);
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % write system matrices to file
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    if Model.Flag.saveRawModel && iFreq == Model.iFExp
        dirMarkerComp = logical((dirMarker' * C)');  
        saveEFormulationModel(Model, SysMat, dirMarkerComp, rhsRaw, k0);
    end    
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % solve system for working frequency
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    solution = mA \ rhs;
    
    if Model.Flag.showMovie
        field = - 1i / k0 * Model.c0 * C * solution(:,1);
        
        phi = (0:30:330) * pi / 180;
        frame = plotFields(Model, field, phi);
        
        movie(frame, 5, 12);
        movieFile = sprintf('%smovie_f_%d', ...
            Model.resultPath, Model.f(iFreq));
        movie2avi(frame, movieFile, 'FPS', 8);
    end
    
    % calculate network matrix column
    if Model.Flag.impedanceFormulation
        networkMat = full(solution(Model.portDof,:));
    else         
        networkMat = full(solution(Model.portDof,:) - ...
            rhsRaw(Model.portDof,:) / condScale^2);
    end    
    
    if Model.Flag.impedanceFormulation
        sMat{iFreq} = z2s(networkMat);
        zMat{iFreq} = networkMat;
    else
        sMat{iFreq} = networkMat;
        zMat{iFreq} = s2z(sMat{iFreq});
    end    
end 
toc

% save results
sMatName = networkParamFileName(Model.path, Model.f, 'S');
zMatName = networkParamFileName(Model.path, Model.f, 'Z');
writeNetworkMatrixLteFormat(sMat, Model.f, sMatName);
writeNetworkMatrixLteFormat(zMat, Model.f, zMatName);

% % print cpu times on standard output
% printCalcData(Model, assemblingTime, solving_time);


