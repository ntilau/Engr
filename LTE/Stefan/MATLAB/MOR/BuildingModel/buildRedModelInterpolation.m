function buildRedModelInterpolation(modelName, order, linFreqParamFlag, ...
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
% factorize system matrix in expansion point
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
for orderCnt = 0 : order
  numInterpolPntsOrder = nchoosek(orderCnt+UnredModel.numParams-1, orderCnt);
  numVectorsTotal = numVectorsTotal + numInterpolPntsOrder;
end
numVectorsTotal = numVectorsTotal * length(UnredModel.useKrylovSpaces);
K = zeros(size(UnredModel.sysMat{1}, 1), numVectorsTotal);
normNewDirection = zeros(1, numVectorsTotal);
currentCol = 0;

iOneParamModel = 0;
save('UnredModelOld.mat', 'UnredModel');

for k = 1:length(UnredModel.useKrylovSpaces)
  if UnredModel.numParams == 1
    oneParamModel = createOneParamModel(UnredModel.sysMat, ...
      UnredModel.permutMat, interpolPnts{1});
    [Q] = wcaweImprvd(Fact, oneParamModel, ...
      sol{UnredModel.useKrylovSpaces(k)+1}, order, [], [], orthoFlag, ...
      pardisoFlag);
    if isempty(K)
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
    for orderCnt = 1:length(interpolPnts)
      for pntCnt = 1:size(interpolPnts{orderCnt}, 1);
        oneParamModel = createOneParamModel(UnredModel.sysMat, ...
          UnredModel.permutMat, interpolPnts{orderCnt}(pntCnt,:));
        iOneParamModel = iOneParamModel + 1;
        fName = ['oneParamModelOld_' num2str(iOneParamModel) '.mat'];
        save(fName, 'oneParamModel');
        [Q] = wcaweImprvd(Fact, oneParamModel, ...
          sol{UnredModel.useKrylovSpaces(k)+1}, order, [], [], ...
          orthoFlag, pardisoFlag);
        if ~nnz(K)
          K(:,1:size(Q,2)) = Q;
          currentCol = size(Q,2);
        else
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
      end
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

rom = projectUnredModel(UnredModel, K, transposeFlag, realProjMatFlag);
clear UnredModel;
clear K;

toc


%% Save reduced model
tic
disp(' ')
disp('Saving reduced order model...');
saveROM(rom, modelName);
toc
