function rom = projectUnredModel(UnredModel, Q, transposeFlag, realProjMatFlag)

if realProjMatFlag
    if ~isreal(Q)
        Q = [real(Q) imag(Q)];
    end
end

% compute projections onto space Q
rom.sysMat = cell(length(UnredModel.sysMat),1);
for k = 1:length(UnredModel.sysMat)
    if ~isempty(UnredModel.sysMat{k})
        if transposeFlag
            rom.sysMat{k} = Q.'*UnredModel.sysMat{k}*Q;
        else
            rom.sysMat{k} = Q'*UnredModel.sysMat{k}*Q;
        end
    end
end

rom.ident = cell(length(UnredModel.ident),1);
for k = 1:length(UnredModel.ident)
    if transposeFlag
        rom.ident{k} = Q.'*UnredModel.ident{k}*Q;
    else
        rom.ident{k} = Q'*UnredModel.ident{k}*Q;
    end
end

rom.lVec = cell(UnredModel.numLeftVecs,1);
for k = 1:UnredModel.numLeftVecs
    rom.lVec{k} = UnredModel.lVec{k}.'*Q;
    % computation of Krylov space is done in real arithmetic
    if transposeFlag
        rom.rhs{k} = -2*1i*(Q.'*UnredModel.rhs{k});
    else
        rom.rhs{k} = -2*1i*(Q'*UnredModel.rhs{k});
    end
end

rom.permutMat       = UnredModel.permutMat;
rom.paramNames      = UnredModel.paramNames;
rom.paramValInExp   = UnredModel.paramValInExp;
rom.numLeftVecs     = UnredModel.numLeftVecs;
rom.useKrylovSpaces = UnredModel.useKrylovSpaces;
rom.numParams       = UnredModel.numParams;
rom.k0              = UnredModel.k0;

