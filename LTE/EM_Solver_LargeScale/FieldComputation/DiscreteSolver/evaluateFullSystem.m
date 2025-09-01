% solve FE-System and return scattering parameters and solution
function [sMat, zMat, dof, sol, solveTime] = evaluateFullSystem(Model)

% read system matrices and vectors
dirMarker = logical(...
    readFullVector(strcat(Model.path, 'dirMarker.fvec')));
[SysMat, dof] = readSystemMatrices(Model.path, dirMarker);

[rhs, lhs] = readSystemVectors(Model.path, Model.nPorts, dirMarker);
    
nFreqs = length(Model.f);
zMat = cell(nFreqs, 1);
sMat = cell(nFreqs, 1);
if nargout == 4
    sol = cell(nFreqs, 1);
end

tic
for fCnt = 1:nFreqs
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % build FE matrix for current parameters
    k0 = 2 * pi * Model.f(fCnt) / Model.c0;
    Param = setParameters('k0', k0, 'fCutOff', Model.fCutOff, ...
        'f', Model.f(fCnt), 'fExp', Model.fExp);   
    M = buildFemMatrix(SysMat, Param);      
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % factorize FE matrix    
    fprintf('\nSolving FE-System for sample %d of %d samples...\n', ...
        fCnt, nFreqs);
    % 6 -> complex, symmetric
    % -2 -> real, symmetric, indefinite
    if isreal(M)
        mtype = -2;
    else
        mtype = 6;
    end
    % Fill-reduction analysis and symbolic factorization
    [iparm,pt,err,M_val,M_ia,M_ja,ncol] = pardisoReorderLTE(mtype, M);
            
    % Numerical factorization
    pardisoFactorLTE(mtype, iparm, pt, M_val, M_ia, M_ja, ncol);

    releaseMemory = true;
    [B, imfactor] = getScaledRhs(Model, rhs, Model.f(fCnt), mtype);
    X = pardisoSolveLTE(...
        mtype, iparm, pt, M_val, M_ia, M_ja, ncol, B, releaseMemory);
                   
    if nargout > 3
        sol{fCnt} = X;
    end
    
    if Model.Flag.impedanceFormulation
        zMat{fCnt} = imfactor * lhs.' * X;
        sMat{fCnt} = z2s(zMat{fCnt});
    else
        sMat{fCnt} = imfactor * lhs.' * X - eye(Model.nPorts);
        zMat{fCnt} = s2z(sMat{fCnt});
    end
end

solveTime = toc;

% save results
sMatName = networkParamFileName(Model.path, Model.f, 'S');
zMatName = networkParamFileName(Model.path, Model.f, 'Z');
writeNetworkMatrixLteFormat(sMat, Model.f, sMatName);
writeNetworkMatrixLteFormat(zMat, Model.f, zMatName);








