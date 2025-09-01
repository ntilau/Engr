function buildRedModInterpCirc(modelName, order, linFreqParamFlag, ...
  orthoFlag, transparentFlag, realProjMatFlag, removeDirichletFlag, ...
  pardisoFlag, muRelExp, kappaRelExp)


if pardisoFlag
  error('Using Pardiso is not possible for circulator!');
end

%% load unreduced model
tic
disp(' ')
disp('Loading raw model...');
RawModel = loadRawModelCirc(modelName, removeDirichletFlag);
toc


%% Build parameter dependend unreduced model
tic
disp(' ')
disp('Building parameter dependend unreduced model...');
UnredModel = buildUnredModCirc(RawModel, linFreqParamFlag, transparentFlag, ...
  muRelExp, kappaRelExp);
% clear RawModel;
toc


%% Build reduced order model
tic
disp(' ')
disp('Building reduced order model...');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute input Krylov space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% factorize system matrix in expansion point
[Fact.L, Fact.U, Fact.P, Fact.Q] = lu(UnredModel.sysMat{1});
% sol = cell(UnredModel.numLeftVecs,1);
% for k = 1:UnredModel.numLeftVecs
%   sol{k} = Fact.Q*(Fact.U\(Fact.L\(Fact.P*UnredModel.rhs{k})));
% end

% % build parameter dependend rhs -> not necessary
% for k = 1:length(UnredModel.rhsScal)
%   if ~isempty(UnredModel.rhsScal{k})
%     for iVec = 1:length(sol)
%       UnredModel.rhsPar{iVec}{k} = UnredModel.rhsScal{k}*sol{iVec};
%     end
%   end
% end

interpolPnts = calcInterpolPnts(UnredModel.numParams, order);
numVectorsTotal = 0;
for orderCnt = 0:order
  numInterpolPntsOrder = nchoosek(orderCnt+UnredModel.numParams-1, orderCnt);
  numVectorsTotal = numVectorsTotal + numInterpolPntsOrder;
end
numVectorsTotal = numVectorsTotal * length(UnredModel.useKrylovSpaces);
% compute input Krylov space
K = zeros(size(UnredModel.sysMat{1}, 1), numVectorsTotal);
normNewDirection = zeros(1, numVectorsTotal);
currentCol = 0;
rhs = cell(1,1);  % only valid for nonparameter dependent rhs
for k = 1:length(UnredModel.useKrylovSpaces)
  for orderCnt = 1:length(interpolPnts)
    for pntCnt = 1:size(interpolPnts{orderCnt}, 1);
%       OneParamModel = createOneParamModelCirc(UnredModel.sysMat, ...
%         UnredModel.permutMat, interpolPnts{orderCnt}(pntCnt,:), ...
%         UnredModel.rhsPar{k});
%       [Q] = wcaweImprvdCirc(Fact, OneParamModel.sysMat, ...
%         sol{UnredModel.useKrylovSpaces(k)+1}, order, [], [], ...
%         orthoFlag, pardisoFlag, OneParamModel.rhs);
      oneParamModel = createOneParamModel(UnredModel.sysMat, ...
        UnredModel.permutMat, interpolPnts{orderCnt}(pntCnt,:));
%       [Q] = wcaweImprvd(Fact, oneParamModel, ...
%         sol{UnredModel.useKrylovSpaces(k)+1}, order, [], [], ...
%         orthoFlag, pardisoFlag);
      rhs{1} = UnredModel.rhs{UnredModel.useKrylovSpaces(k)+1};
      Q = zeros(length(rhs{1}), order+1);
      [Q] = wcaweImprvdCirc(Fact, oneParamModel, order, Q, [], orthoFlag, ...
        pardisoFlag, rhs);
      if ~nnz(K)
        K(:,1:size(Q,2)) = Q;
        currentCol = size(Q,2);
      else
        for colCnt = 1:size(Q,2)
          if colCnt >= orderCnt
            v = Q(:,colCnt);
            [v projCoeffs] = orthoAgainstSpace(v, K, currentCol, orthoFlag);
            currentCol = currentCol + 1;
            normNewDirection(currentCol) = projCoeffs(currentCol);
            K(:,currentCol) = v;
          end
        end
      end
    end
  end
end
mKryInput = K;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute output Krylov space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % reuse factorization
% FactInput = Fact;
% Fact.L = FactInput.U.';
% Fact.U = FactInput.L.';
% Fact.P = FactInput.Q.';
% Fact.Q = FactInput.P.';
% clear FactInput;
% for k = 1:UnredModel.numLeftVecs
%   sol{k} = Fact.Q*(Fact.U\(Fact.L\(Fact.P*UnredModel.lVec{k})));
% end
% % transpose system matrices
% for k = 1:length(UnredModel.sysMat)
%   if ~isempty(UnredModel.sysMat{k})
%     UnredModel.sysMat{k} = UnredModel.sysMat{k}.';
%   end
% end
% K = zeros(size(UnredModel.sysMat{1}, 1), numVectorsTotal);
% normNewDirection = zeros(1, numVectorsTotal);
% currentCol = 0;
% for k = 1:length(UnredModel.useKrylovSpaces)
%   for orderCnt = 1:length(interpolPnts)
%     for pntCnt = 1:size(interpolPnts{orderCnt}, 1);
%       oneParamModel = createOneParamModel(UnredModel.sysMat, ...
%         UnredModel.permutMat, interpolPnts{orderCnt}(pntCnt,:));
%       [Q] = wcaweImprvd(Fact, oneParamModel, ...
%         sol{UnredModel.useKrylovSpaces(k)+1}, order, [], [], ...
%         orthoFlag, pardisoFlag);
%       if ~nnz(K)
%         K(:,1:size(Q,2)) = Q;
%         currentCol = size(Q,2);
%       else
%         for colCnt = 1:size(Q,2)
%           if colCnt >= orderCnt
%             v = Q(:,colCnt);
%             [v projCoeffs] = orthoAgainstSpace(v, K, currentCol, orthoFlag);
%             currentCol = currentCol + 1;
%             normNewDirection(currentCol) = projCoeffs(currentCol);
%             K(:,currentCol) = v;
%           end
%         end
%       end
%     end
%   end
% end

% K = conj(mKryInput);
K = mKryInput;
clear Fact;
clear UnredModel;

rom = projectModelCirc(RawModel, mKryInput, K, realProjMatFlag);
clear K;
clear mKryInput;
toc


%% Save reduced model
tic
disp(' ')
disp('Saving reduced order model...');
saveROM_Circ(rom, modelName);
toc


function rom = projectModelCirc(RawModel, mKryIn, mKryOut, realProjMatFlag)

if realProjMatFlag
  if ~isreal(mKryIn)
    mKryIn = [real(mKryIn) imag(mKryIn)];
  end
  if ~isreal(mKryOut)
    mKryOut = [real(mKryOut) imag(mKryOut)];
  end
end

% compute projections onto Krylov spaces
rom.sys0 = mKryOut.' * RawModel.sys0 * mKryIn;
rom.k2_mat = mKryOut.' * RawModel.k2_mat * mKryIn;
rom.paramMat = cell(length(RawModel.paramMat),1);
for k = 1:length(RawModel.paramMat)
  rom.paramMat{k} = mKryOut.' * RawModel.paramMat{k} * mKryIn;
end

rom.lVec = cell(RawModel.numLeftVecs,1);
rom.rhs = cell(RawModel.numLeftVecs,1);
for k = 1:RawModel.numLeftVecs
  rom.lVec{k} = RawModel.lVec{k}.' * mKryIn;
  rom.rhs{k} = mKryOut.' * RawModel.rhs{k};
end

rom.paramNames      = RawModel.paramNames;
rom.paramValInExp   = RawModel.paramValInExp;
rom.numLeftVecs     = RawModel.numLeftVecs;
rom.useKrylovSpaces = RawModel.useKrylovSpaces;
rom.numParams       = RawModel.numParams;
rom.k0              = RawModel.k0;


function saveROM_Circ(rom, modelName)

writeMatFull(rom.sys0, [modelName 'system matrix red.fmat']);
writeMatFull(rom.k2_mat, [modelName 'k^2 matrix red.fmat']);
for k = 1:length(rom.paramMat)
  writeMatFull(rom.paramMat{k}, [modelName rom.paramNames{k} '_red.fmat']);
end

for k = 1:rom.numLeftVecs
  writeVector(rom.lVec{k}, [modelName, 'leftVecRed_', num2str(k-1), '.fvec']);
  writeVector(rom.rhs{k}, [modelName, 'redRhs_', num2str(k-1), '.fvec']);
end

