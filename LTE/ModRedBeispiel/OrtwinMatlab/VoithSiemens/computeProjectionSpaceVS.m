function K = computeProjectionSpaceVS(modelInExpPnt, fact, numParams, order)

% Attention: only works for models with one rhs

interpolPnts = calcInterpolPnts(numParams, order);

% compute dimension of projection space
dimProjSpace = 0;
for orderCnt = 0 : order
  dimProjSpace = dimProjSpace + nchoosek(orderCnt + numParams - 1, orderCnt);
end

K = zeros(size(modelInExpPnt.sysMat{1}, 1), dimProjSpace);

% compute projection space
currentPos = 1;
normNewDirection = zeros(1, dimProjSpace);
for orderCnt = 1 : length(interpolPnts)
  for pntCnt = 1 : size(interpolPnts{orderCnt}, 1);
    oneParamModel = createOneParamModelVS(modelInExpPnt, modelInExpPnt.coeffSequence, interpolPnts{orderCnt}(pntCnt, :));
    Q = wcaweVS(fact, oneParamModel, order);
    if ~nnz(K)
      K(:, currentPos : (currentPos + size(Q, 2) - 1)) = Q;
      currentPos = currentPos + size(Q, 2);
    else
      for colCnt = 1 : size(Q, 2)
        if colCnt >= orderCnt
          % modified Gram Schmidt
          for kColCnt = 1:size(K, 2)
            proj = K(:, kColCnt)' * Q(:, colCnt);
            Q(:, colCnt) = Q(:, colCnt) - proj * K(:, kColCnt);
          end
          normNewDirection(currentPos) = norm(Q(:, colCnt));
          K(:, currentPos) = Q(:, colCnt) / norm(Q(:, colCnt));
          currentPos = currentPos + 1;
        end
      end
    end
  end
end

