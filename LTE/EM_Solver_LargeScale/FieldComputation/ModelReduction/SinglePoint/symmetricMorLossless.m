function [Model, Rom] = symmetricMorLossless(Model)

% read system matrices and vectors
dirMarker = logical(readFullVector(strcat(Model.path, 'dirMarker.fvec')));
[SysMat, dof] = readSystemMatrices(Model.path, dirMarker);
Model.dof = dof;

[rhs, lhs] = readSystemVectors(Model.path, Model.nPorts, dirMarker);

[A0, A0Factor, X0] = computeShiftedSystem(Model, SysMat, rhs);

% find position of spd mass matrix in SysMat array
iMassMat = findMatrixIndex(SysMat, 'k^2 matrix');
Q = [];
R = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% iteration process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltaS = intmax;
normType = Model.ErrorCriterion.type;
order = 0;
Rom = cell(Model.maxRomOrder, 1);
OldRom = struct([]);
while deltaS > Model.ErrorCriterion.threshold ...
        && order <= Model.maxRomOrder  

    [Q, R, order] = incrementalBlockArnoldi(...
        Q, R, SysMat(iMassMat).val, X0, A0Factor, Model.Flag.doubleOrtho);
    
    if order > 1
        OldRom = Rom{order-1};
    end

    fprintf('\n\t\t+ Building reduced Model of order %d...', order);
%     Rom = buildReducedModel(Model, SysMat, Q, X0, rhs, lhs);
    Rom{order} = buildIncrementalReducedModel(...
        Model, SysMat, OldRom, Q, X0, rhs, lhs);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Solve ROM
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('\n\t\t+ Solving reduced model of order p = %d ...', order);
    [sMat, zMat, sol] = evaluateRom(Model, Rom{order}, Model.f);
    Rom{order}.zMat = zMat;
    Rom{order}.sMat = sMat;
    Rom{order}.sol = sol;
        
    % save network matrices
    sMatName = generateNetworkparamFilename('Srom', Model, order);
    zMatName = generateNetworkparamFilename('Zrom', Model, order);
    
    writeNetworkMatrixLteFormat(sMat, Model.f, sMatName);
    writeNetworkMatrixLteFormat(zMat, Model.f, zMatName);
    
    % convergence check
    if order > 1
        Rom{order}.Criterion = incrementalStoppingCriterion(...
            Rom{order - 1}.sMat, Rom{order}.sMat);
        deltaS = Rom{order}.Criterion.(normType);
        fprintf(1, '\n\t\t+ Error criterion in %s norm: %1.4e', ...
            normType, deltaS);
    end    
end

Model.iRomConverged = order;

% remove superfluous cells
Rom = Rom(1:Model.iRomConverged);
saveReducedModel(Model, Rom{Model.iRomConverged});

writeSinglepointStatistics(Model, 1);





