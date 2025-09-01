function buildRedModelInterpEfficientOld(modelName, order, linFreqParamFlag, ...
    transposeFlag, orthoFlag, transparentFlag, realProjMatFlag, ...
    removeDirichletFlag, pardisoFlag)


%% load unreduced model
tic
disp(' ')
disp('Loading raw model...');
RawModel = loadRawModel(modelName, removeDirichletFlag);
toc


%% Build parameter dependend unreduced model
tic
disp(' ')
disp('Building parameter dependend unreduced model...');
UnredModel = buildUnredModel(RawModel, linFreqParamFlag, transparentFlag);
clear RawModel;
toc


%% Build reduced order model
tic
disp(' ')
disp('Building reduced order model...');

sol = cell(UnredModel.numLeftVecs,1);
% Factorize system matrix in expansion point
if pardisoFlag
    % determine matrix type
    if nnz(imag(UnredModel.sysMat{1}))
        Fact.mtype = 6;  % complex symmetric indefinite matrix
    else
        Fact.mtype = -2;  % real symmetric indefinite matrix
    end
    % Fill-reduction analysis and symbolic factorization
    [Fact.iparm Fact.pt Fact.err Fact.A_val Fact.A_ia Fact.A_ja Fact.ncol] = ...
        pardisoReorderLTE(Fact.mtype, UnredModel.sysMat{1}); 
    % Numerical factorization
    err = pardisoFactorLTE(Fact.mtype, Fact.iparm, Fact.pt, Fact.A_val, ...
        Fact.A_ia, Fact.A_ja, Fact.ncol);
    if err ~= 0
        error(['Pardiso error during factorization: ' err]);
    end
    for k = 1:UnredModel.numLeftVecs
        % Forward and Backward solve
        [sol{k} err] = pardisoSolveLTE(Fact.mtype, Fact.iparm, Fact.pt, ...
            Fact.A_val, Fact.A_ia, Fact.A_ja, Fact.ncol, UnredModel.rhs{k}, 0);
        if err ~= 0
            error(['Pardiso error during solving: ' err]);
        end
    end
else
    [Fact.L, Fact.U, Fact.P, Fact.Q] = lu(UnredModel.sysMat{1});
    for k = 1:UnredModel.numLeftVecs
        sol{k} = Fact.Q*(Fact.U\(Fact.L\(Fact.P*UnredModel.rhs{k})));
    end
end

interpolPnts = calcInterpolPnts(UnredModel.numParams, order);
numVectorsTotal = 0;
for orderCnt = 0:order
    numInterpolPntsOrder = nchoosek(orderCnt+UnredModel.numParams-1, orderCnt);
    numVectorsTotal = numVectorsTotal + numInterpolPntsOrder;
end
numVectorsTotal = numVectorsTotal * length(UnredModel.useKrylovSpaces);
K = zeros(size(UnredModel.sysMat{1},1), numVectorsTotal);
normNewDirection = zeros(1,numVectorsTotal);
solROM = cell(UnredModel.numLeftVecs,1);
CurrentROM.sysMat = cell(length(UnredModel.sysMat),1);
CurrentROM.rhs = cell(length(UnredModel.rhs),1);
currentCol = 0;
for k = 1:length(UnredModel.useKrylovSpaces)
    if UnredModel.numParams == 1
        oneParamModel = createOneParamModel(UnredModel.sysMat, ...
            UnredModel.permutMat, interpolPnts{1});
        [Q] = wcaweImprvd(Fact, oneParamModel, ...
            sol{UnredModel.useKrylovSpaces(k)+1}, order, [], [], orthoFlag, ...
            pardisoFlag);
        if ~nnz(K)
            K = Q;
            currentCol = size(Q,2);
        else
            for colCnt = 1:size(Q,2)
                v = Q(:,colCnt);
                [v projCoeffs] = orthoAgainstSpace(v, K, currentCol, orthoFlag);
                currentCol = currentCol + 1;
                normNewDirection(currentCol) = projCoeffs(currentCol);
                K(:,currentCol) = v;
            end
        end
    else
        % several parameters
        orderCnt = 1;
        if ~nnz(K)
            oneParamModel = createOneParamModel(UnredModel.sysMat, ...
                UnredModel.permutMat, interpolPnts{orderCnt}(1,:));
            [Q] = wcaweImprvd(Fact, oneParamModel, ...
                sol{UnredModel.useKrylovSpaces(k)+1}, order, [], [], ...
                orthoFlag, pardisoFlag);
            K = Q;
            currentCol = size(Q,2);
        else
            oneParamModel = createOneParamModel(UnredModel.sysMat, ...
                UnredModel.permutMat, interpolPnts{orderCnt}(1,:));
            [Q] = wcaweImprvd(Fact, oneParamModel, ...
                sol{UnredModel.useKrylovSpaces(k) + 1}, order, [], [], ...
                orthoFlag, pardisoFlag);
            for colCnt = 1:size(Q,2)
                if colCnt >= orderCnt
                    v = Q(:,colCnt);
                    [v projCoeffs] = orthoAgainstSpace(v, K, ...
                        currentCol, orthoFlag);
                    currentCol = currentCol + 1;
                    normNewDirection(currentCol)=projCoeffs(currentCol);
                    K(:,currentCol) = v;
                end
            end
        end
        CurrentROM = computeCurrentROM(CurrentROM, UnredModel.sysMat, ...
            UnredModel.rhs, K, size(K,2), transposeFlag);
        for orderCnt = 2:length(interpolPnts)
            for pntCnt = 1:size(interpolPnts{orderCnt},1);
                % compute linear dependent WCAWE vectors in ROM
                oneParamModel = createOneParamModel(CurrentROM.sysMat, ...
                    UnredModel.permutMat, interpolPnts{orderCnt}(pntCnt,:));
                [FactROM.L FactROM.U] = lu(CurrentROM.sysMat{1});
                for rhsCnt = 1:UnredModel.numLeftVecs
                    solROM{rhsCnt} = FactROM.U \ (FactROM.L\CurrentROM.rhs{k});
                end
                [Q U] = wcaweImprvd(FactROM, oneParamModel, ...
                    solROM{UnredModel.useKrylovSpaces(k)+1}, orderCnt-2, [], ...
                    [], orthoFlag, false);
                % compute linear independent WCAWE vectors in full model
                Qfull = K(:,1:size(CurrentROM.sysMat{1},1)) * Q;
                oneParamModel = createOneParamModel(UnredModel.sysMat, ...
                    UnredModel.permutMat, interpolPnts{orderCnt}(pntCnt,:));
                [Q] = wcaweImprvd(Fact, oneParamModel, ...
                    sol{UnredModel.useKrylovSpaces(k)+1}, order, Qfull, U, ...
                    orthoFlag, pardisoFlag);
%                 [Qref Uref] = wcaweImprvd(Fact, oneParamModel, ...
%                     sol{useKrylovSpaces(k)+1}, order, [], [], orthoFlag, ...
%                     pardisoFlag);
%                 disp(max(max(abs(Q-Qref))));
%                 Q = Qref;
                for colCnt = 1:size(Q,2)
                    if colCnt >= orderCnt
                        v = Q(:,colCnt);
                        [v projCoeffs] = orthoAgainstSpace(v, K, ...
                            currentCol, orthoFlag);
                        currentCol = currentCol + 1;
                        normNewDirection(currentCol)=projCoeffs(currentCol);
                        K(:,currentCol) = v;
                    end
                end
            end
            % compute new ROM
            CurrentROM = computeCurrentROM(CurrentROM, UnredModel.sysMat, ...
                UnredModel.rhs, K, size(K,2), transposeFlag);
        end
    end
end

if pardisoFlag    
    err = pardisoReleaseMemory(Fact.mtype, Fact.iparm, Fact.pt, Fact.A_val, ...
        Fact.A_ia, Fact.A_ja, Fact.ncol);
    if err ~= 0
        error(['Pardiso error during memory release: ' err]);
    end
end
clear Fact;
if UnredModel.numParams == 1
    rom = projectUnredModel(UnredModel, K, transposeFlag, realProjMatFlag);    
else
    rom = projectUnredModel2(UnredModel, K, transposeFlag, CurrentROM, ...
        realProjMatFlag);
end
clear UnredModel;
clear K;

toc


%% Save reduced model
tic
disp(' ')
disp('Saving reduced order model...');
saveROM(rom, modelName);
toc
