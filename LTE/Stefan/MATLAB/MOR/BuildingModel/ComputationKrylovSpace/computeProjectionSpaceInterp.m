function K = computeProjectionSpaceInterp(numParams, order, sysMat, fact, sol, permutMat, useKrylovSpaces)


interpolPnts = calcInterpolPnts(numParams, order);
numVectorsTotal = 0;
for orderCnt = 0 : order
  numInterpolPntsOrder = nchoosek(orderCnt + numParams - 1, orderCnt);
  numVectorsTotal = numVectorsTotal + numInterpolPntsOrder;
end
numVectorsTotal = numVectorsTotal * length(useKrylovSpaces);
K = zeros(size(sysMat{1}, 1), numVectorsTotal);
normNewDirection = zeros(1, numVectorsTotal);
currentCol = 0;
for k = 1:length(useKrylovSpaces)
  if numParams == 1
    oneParamModel = createOneParamModel(sysMat, permutMat, interpolPnts{1});
    Q = wcaweImprvd(fact, oneParamModel, sol{useKrylovSpaces(k)+1}, order, [], []);
    if isempty(K)
      K = Q;
      currentCol = size(Q, 2);      
    else
      for colCnt = 1:size(Q, 2)
        % modified Gram Schmidt
        for kColCnt = 1:size(K, 2)
          proj = K(:, kColCnt)' * Q(:, colCnt);
          Q(:, colCnt) = Q(:, colCnt) - proj * K(:, kColCnt);
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
        oneParamModel = createOneParamModel(sysMat, permutMat, interpolPnts{orderCnt}(pntCnt,:));
        Q = wcawe(fact, oneParamModel, sol{useKrylovSpaces(k)+1}, order);
        if ~nnz(K)
          K(:, 1 : size(Q, 2)) = Q;
          currentCol = size(Q, 2);
        else
          for colCnt = 1:size(Q, 2)
            if colCnt >= orderCnt
              % modified Gram Schmidt
              for kColCnt = 1:size(K, 2)
                proj = K(:, kColCnt)' * Q(:, colCnt);
                Q(:, colCnt) = Q(:, colCnt) - proj * K(:, kColCnt);
              end
              normNewDirection(currentCol) = norm(Q(:, colCnt));
              currentCol = currentCol + 1;
              K(:, currentCol) = Q(:, colCnt) / norm(Q(:, colCnt));
            end
          end
        end
      end
    end
  end
end
