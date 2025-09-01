function buildRedModInterpCircABCD(modelName, order, linFreqParamFlag, ...
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
UnredModel = buildUnredModCircABCD(RawModel, linFreqParamFlag, transparentFlag, ...
  muRelExp, kappaRelExp);
% clear RawModel;
toc


%% Build reduced order model
tic
disp(' ')
disp('Building reduced order model...');

% factorize system matrix in expansion point
[Fact.L, Fact.U, Fact.P, Fact.Q] = lu(UnredModel.A{1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute input Krylov space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mKryIn = compInputKrySpaceABCD(UnredModel, Fact, order, orthoFlag, pardisoFlag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute output Krylov space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% reuse factorization
% FactInput = Fact;
% Fact.L = FactInput.U.';
% Fact.U = FactInput.L.';
% Fact.P = FactInput.Q.';
% Fact.Q = FactInput.P.';
% clear FactInput;

% build transposed system
UnredModel.A = transposeCellArr(UnredModel.A);
Bt = transposeCellArr(UnredModel.B);
UnredModel.B = transposeCellArr(UnredModel.C);
UnredModel.C = Bt;
clear Bt;
[Fact.L, Fact.U, Fact.P, Fact.Q] = lu(UnredModel.A{1});
mKryOut = compInputKrySpaceABCD(UnredModel, Fact, order, orthoFlag, pardisoFlag);

% mKryOut = conj(mKryIn);
clear Fact;
clear UnredModel;

rom = projectModelCirc(RawModel, mKryIn, mKryOut, realProjMatFlag);
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


function cellArr = transposeCellArr(cellArr)

for k = 1:length(cellArr)
  if ~isempty(cellArr{k})
    cellArr{k} = cellArr{k}.';
  end
end



