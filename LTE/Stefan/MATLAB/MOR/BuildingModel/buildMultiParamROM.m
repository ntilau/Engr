function buildMultiParamROM(modelName, order, transposeFlag, orthoFlag, ...
    transparentFlag, realProjMatFlag, removeDirichletFlag)


%% load unreduced model
tic
disp(' ')
disp('Loading raw model...');
rawModel = loadRawModelNew(modelName, removeDirichletFlag);
toc


%% Build parameter dependend unreduced model
tic
disp(' ')
disp('Building parameter dependend unreduced model...');
unredModel = buildUnredModel(rawModel, linFreqParamFlag, transparentFlag);
clear rawModel;
toc


%% Build reduced order model
tic
disp(' ')
disp('Building reduced order model...');

% system matrix in expansion point
% ABC are already included in sys0 if present
% [fact.L, fact.U, fact.P, fact.Q] = lu(sys0);
[fact.L, fact.U, fact.P, fact.Q] = lu(unredModel.sysMat{1});

sol = cell(unredModel.numLeftVecs,1);
for k = 1:unredModel.numLeftVecs
    sol{k} = fact.Q*(fact.U\(fact.L\(fact.P*unredModel.rhs{k})));
end

interpolPnts = calcInterpolPnts(unredModel.numParams, order);
numVectorsTotal = 0;
for orderCnt = 0 : order
    numInterpolPntsOrder = nchoosek(orderCnt+unredModel.numParams-1, orderCnt);
    numVectorsTotal = numVectorsTotal + numInterpolPntsOrder;
end
numVectorsTotal = numVectorsTotal * length(unredModel.useKrylovSpaces);
K = zeros(size(unredModel.sysMat{1}, 1), numVectorsTotal);
normNewDirection = zeros(1, numVectorsTotal);
currentCol = 0;
for k = 1:length(unredModel.useKrylovSpaces)
    if unredModel.numParams == 1
        oneParamModel = createOneParamModel(unredModel.sysMat, unredModel.permutMat, interpolPnts{1});
        [Q] = wcaweImprvd(fact, oneParamModel, sol{unredModel.useKrylovSpaces(k)+1}, order, [], [], orthoFlag);
        if isempty(K)
            K = Q;
            currentCol = size(Q,2);
        else
            for colCnt = 1:size(Q,2)
                % modified Gram Schmidt
                for kColCnt = 1:size(K, 2)
                    proj = K(:, kColCnt)' * Q(:, colCnt);
                    Q(:, colCnt) = Q(:, colCnt) - proj * K(:, kColCnt);
                end
                if orthoFlag
                    % modified Gram Schmidt -> once again
                    for kColCnt = 1:size(K, 2)
                        proj = K(:, kColCnt)' * Q(:, colCnt);
                        Q(:, colCnt) = Q(:, colCnt) - proj * K(:, kColCnt);
                    end
                end
                currentCol = currentCol + 1;
                normNewDirection(currentCol) = norm(Q(:, colCnt));
                K(:, currentCol) = Q(:, colCnt) / norm(Q(:, colCnt));
            end
        end
    else
        % several parameters
        for orderCnt = 1:length(interpolPnts)
            for pntCnt = 1:size(interpolPnts{orderCnt}, 1);
                oneParamModel = createOneParamModel(unredModel.sysMat, unredModel.permutMat, ...
                    interpolPnts{orderCnt}(pntCnt,:));
                [Q] = wcaweImprvd(fact, oneParamModel, sol{unredModel.useKrylovSpaces(k)+1}, ...
                    order, [], [], orthoFlag);
                if ~nnz(K)
                    K(:,1:size(Q,2)) = Q;
                    currentCol = size(Q, 2);
                else
                    for colCnt = 1:size(Q, 2)
                        if colCnt >= orderCnt
                            % modified Gram Schmidt
                            for kColCnt = 1:size(K, 2)
                                proj = K(:,kColCnt)' * Q(:,colCnt);
                                Q(:,colCnt) = Q(:,colCnt) - proj * K(:,kColCnt);
                            end
                            if orthoFlag
                                % modified Gram Schmidt -> once again
                                for kColCnt = 1:size(K,2)
                                    proj = K(:,kColCnt)' * Q(:,colCnt);
                                    Q(:,colCnt) = Q(:,colCnt) - proj * K(:,kColCnt);
                                end
                            end
                            normNewDirection(currentCol) = norm(Q(:,colCnt));
                            currentCol = currentCol + 1;
                            K(:,currentCol) = Q(:,colCnt) / norm(Q(:,colCnt));
                        end
                    end
                end
            end
        end
    end
end

clear fact;
rom = projectUnredModel(unredModel, K, transposeFlag, realProjMatFlag);
clear unredModel;
clear K;

toc


%% Save reduced model
tic
disp(' ')
disp('Saving reduced order model...');
saveROM(rom, modelName);
toc
