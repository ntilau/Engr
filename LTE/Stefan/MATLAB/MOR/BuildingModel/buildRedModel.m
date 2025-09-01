function buildRedModel(modelName, order, linFreqParamFlag, transposeFlag, ...
    orthoFlag, transparentFlag, realProjMatFlag, removeDirichletFlag, ...
    pardisoFlag)


%% load unreduced model
tic
disp(' ')
disp('Loading raw model...');
rawModel = loadRawModel(modelName, removeDirichletFlag);
toc


%% Build parameter dependend unreduced model
tic
disp(' ')
disp('Building parameter dependend unreduced model...');
UnredModel = buildUnredModel(rawModel, linFreqParamFlag, transparentFlag);
clear rawModel;
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

K = [];
for k = 1:length(UnredModel.useKrylovSpaces)
    K = [K, compGenKrySpaceNparamPoly(UnredModel.sysMat, Fact, ...
        sol{UnredModel.useKrylovSpaces(k)+1}, order, UnredModel.numParams, ...
        pardisoFlag)];
end

if orthoFlag
    [K R] = qr(K,0); %#ok<NASGU>
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