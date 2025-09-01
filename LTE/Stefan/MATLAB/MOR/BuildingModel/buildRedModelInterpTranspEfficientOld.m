function buildRedModelInterpEfficientOld(modelName, order, linFreqParamFlag, transposeFlag, orthoFlag)


%% load unreduced model
tic
disp(' ')
disp('Loading raw model...');
rawModel = loadRawModel(modelName);
toc


%% Build parameter dependend unreduced model
tic
disp(' ')
disp('Building parameter dependend unreduced model...');
unredModel = buildUnredModel(rawModel, linFreqParamFlag);
clear rawModel;
toc


%% Build reduced order model
tic
disp(' ')
disp('Building reduced order model...');

% system matrix in expansion point
% ABC are already included in sysMat{1} if present
[fact.L, fact.U, fact.P, fact.Q] = lu(unredModel.sysMat{1});

sol = cell(unredModel.numLeftVecs,1);
for k = 1:unredModel.numLeftVecs
    sol{k} = fact.Q*(fact.U\(fact.L\(fact.P*unredModel.rhs{k})));
end

interpolPnts = calcInterpolPnts(unredModel.numParams, order);
numVectorsTotal = 0;
for orderCnt = 0:order
    numInterpolPntsOrder = nchoosek(orderCnt+unredModel.numParams-1, orderCnt);
    numVectorsTotal = numVectorsTotal + numInterpolPntsOrder;
end
numVectorsTotal = numVectorsTotal * length(unredModel.useKrylovSpaces);
K = zeros(size(unredModel.sysMat{1},1), numVectorsTotal);
normNewDirection = zeros(1,numVectorsTotal);
solROM = cell(unredModel.numLeftVecs,1);
currentROM.sysMat = cell(length(unredModel.sysMat),1);
currentROM.rhs = cell(length(unredModel.rhs),1);
currentCol = 0;
for k = 1:length(unredModel.useKrylovSpaces)
    if unredModel.numParams == 1       % one single parameter
        oneParamModel = createOneParamModel(unredModel.sysMat, unredModel.permutMat, interpolPnts{1});
        [Q] = wcaweImprvd(fact, oneParamModel, sol{unredModel.useKrylovSpaces(k)+1}, order, [], [], orthoFlag);
        if isempty(K)
            K = Q;
            currentCol = size(Q,2);
        else
            for colCnt = 1:size(Q,2)
                % modified Gram Schmidt
                for kColCnt = 1:size(K,2)
                    proj = K(:,kColCnt)' * Q(:,colCnt);
                    Q(:,colCnt) = Q(:,colCnt) - proj*K(:,kColCnt);
                end
                if orthoFlag
                    % modified Gram Schmidt -> once again
                    for kColCnt = 1:size(K,2)
                        proj = K(:,kColCnt)' * Q(:,colCnt);
                        Q(:,colCnt) = Q(:,colCnt) - proj*K(:,kColCnt);
                    end
                end
                currentCol = currentCol+1;
                normNewDirection(currentCol) = norm(Q(:,colCnt));
                K(:,currentCol) = Q(:,colCnt) / norm(Q(:,colCnt));
            end
        end
        currentROM = computeCurrentROM(currentROM, unredModel.sysMat, unredModel.rhs, K, currentCol);
    else
        % several parameters
        thisOrder = 0;
        interpolPntsNow = calcInterpolPnts(unredModel.numParams, thisOrder);
        oneParamModel = createOneParamModel(unredModel.sysMat, unredModel.permutMat, interpolPntsNow{1}(1,:));
        [Q] = wcaweImprvd(fact, oneParamModel, sol{unredModel.useKrylovSpaces(k)+1}, thisOrder, ...
            [], [], orthoFlag);
        if ~nnz(K)
            currentCol = currentCol+1;
            K(:,1) = Q(:,1);
        else
            % modified Gram Schmidt
            for kColCnt = 1:currentCol
                proj = K(:,kColCnt)' * Q(:,1);
                Q(:,1) = Q(:,1) - proj*K(:,kColCnt);
            end
            if orthoFlag
                % modified Gram Schmidt -> once again
                for kColCnt = 1:currentCol
                    proj = K(:,kColCnt)' * Q(:,1);
                    Q(:,1) = Q(:,1) - proj*K(:,kColCnt);
                end
            end
            normNewDirection(currentCol) = norm(Q(:,1));
            currentCol = currentCol+1;
            K(:,currentCol) = Q(:,1) / norm(Q(:,1));
        end
        currentROM = computeCurrentROM(currentROM, unredModel.sysMat, unredModel.rhs, K, ...
            currentCol, transposeFlag);
        for thisOrder = 1:order
            interpolPntsNow = calcInterpolPnts(unredModel.numParams, thisOrder);
            for orderCnt = 0:thisOrder
                for pntCnt = 1:size(interpolPntsNow{orderCnt+1},1);
                    % linear dependent vectors: can be reconstructed from ROM
                    oneParamModel = createOneParamModel(currentROM.sysMat, ...
                        unredModel.permutMat, interpolPntsNow{orderCnt+1}(pntCnt,:));
                    [factROM.L factROM.U] = lu(currentROM.sysMat{1});
                    for rhsCnt = 1:unredModel.numLeftVecs
                        solROM{rhsCnt} = factROM.U \ (factROM.L \ currentROM.rhs{k});
                    end
                    [Q U] = wcaweImprvd(factROM, oneParamModel, solROM{unredModel.useKrylovSpaces(k)+1}, ...
                        thisOrder-1, [], [], orthoFlag);
                    % compute linear independent WCAWE vectors in full model
                    Qfull = K(:,1:size(currentROM.sysMat{1},1)) * Q;
                    oneParamModel = createOneParamModel(unredModel.sysMat, unredModel.permutMat, ...
                        interpolPntsNow{orderCnt+1}(pntCnt,:));
                    [Q] = wcaweImprvd(fact, oneParamModel, sol{unredModel.useKrylovSpaces(k)+1}, ...
                        thisOrder, Qfull, U, orthoFlag);
%                     [Qref Uref] = wcaweImprvd(fact, oneParamModel, sol{useKrylovSpaces(k)+1}, ...
%                         thisOrder, [], [], orthoFlag);
%                     disp(max(max(abs(Q-Qref))));
%                     Q = Qref;
                    % modified Gram Schmidt
                    for kColCnt = 1:currentCol
                        proj = K(:,kColCnt)' * Q(:,end);
                        Q(:,end) = Q(:,end) - proj*K(:,kColCnt);
                    end
                    if orthoFlag
                        % modified Gram Schmidt -> once again
                        for kColCnt = 1:currentCol
                            proj = K(:,kColCnt)' * Q(:,end);
                            Q(:,end) = Q(:,end) - proj*K(:,kColCnt);
                        end
                    end
                    normNewDirection(currentCol) = norm(Q(:,end));
                    currentCol = currentCol+1;
                    K(:,currentCol) = Q(:,end) / norm(Q(:,end));
                end
            end
            % compute new ROM
            currentROM = computeCurrentROM(currentROM, unredModel.sysMat, unredModel.rhs, K, ...
                currentCol, transposeFlag);
        end
    end
end

clear fact;
rom = projectUnredModel2(unredModel, K, transposeFlag, currentROM);
clear unredModel;
clear K;

toc


%% Save reduced model
tic
disp(' ')
disp('Saving reduced order model...');
saveROM(rom, modelName);
toc
