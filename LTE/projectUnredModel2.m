function rom = projectUnredModel2(unredModel, Q, transposeFlag, currentROM)


% compute projections onto space Q
rom.sysMat = currentROM.sysMat;

rom.ident = cell(length(unredModel.ident),1);
for k = 1:length(unredModel.ident)
    if transposeFlag
        rom.ident{k} = Q.'*unredModel.ident{k}*Q;
    else
        rom.ident{k} = Q'*unredModel.ident{k}*Q;
    end
end

rom.lVec = cell(unredModel.numLeftVecs,1);
rom.rhs  = cell(unredModel.numLeftVecs,1);
for k = 1:unredModel.numLeftVecs
    rom.lVec{k} = unredModel.lVec{k}.'*Q;
    % computation of Krylov space is done in real arithmetic
    rom.rhs{k} = -2*j*currentROM.rhs{k};
end

rom.permutMat       = unredModel.permutMat;
rom.paramNames      = unredModel.paramNames;
rom.paramValInExp   = unredModel.paramValInExp;
rom.numLeftVecs     = unredModel.numLeftVecs;
rom.useKrylovSpaces = unredModel.useKrylovSpaces;
rom.numParams       = unredModel.numParams;
rom.k0              = unredModel.k0;

