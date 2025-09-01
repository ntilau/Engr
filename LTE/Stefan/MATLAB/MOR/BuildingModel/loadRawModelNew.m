function RawModel = loadRawModelNew(modelName, removeDirichletFlag)

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[RawModel.f0, RawModel.paramNames, RawModel.paramValInExp, ...
    RawModel.numLeftVecs, RawModel.abcFlag] = readModParaTxt(fNameModRedTxt);

RawModel.useKrylovSpaces = vectorReader([modelName, 'useKrylovSpaces.txt']);

RawModel.numParams = length(RawModel.paramNames)+1;

if removeDirichletFlag
    dMark = vectorReader([modelName, 'dirMarker.fvec']);
end

% read system matrices
[rhs, lVec] = readSystemVectors(modelName, nLeftVecs, dirMarker);
SysMat = readSystemMatrices(modelName, dirMarker);


RawModel.sys0 = mmread(strcat(modelName, 'system matrix.mm'));
RawModel.k2_mat = mmread(strcat(modelName, 'k^2 matrix.mm'));
if removeDirichletFlag
    RawModel.sys0 = RawModel.sys0(~dMark,~dMark);
    RawModel.k2_mat = RawModel.k2_mat(~dMark,~dMark);
end
RawModel.ident = cell(RawModel.numLeftVecs,1);
for k = 1:RawModel.numLeftVecs
    RawModel.ident{k} = mmread(strcat(modelName, 'ident_', num2str(k-1),'.mm'));
    if removeDirichletFlag
        RawModel.ident{k} = RawModel.ident{k}(~dMark,~dMark);
    end
end
RawModel.paramMat = cell(length(RawModel.paramNames),1);
for k = 1:length(RawModel.paramNames)
    % names of the material matrices are equal to the parameter names
    RawModel.paramMat{k} = mmread([modelName, RawModel.paramNames{k}, '.mm']);
    if removeDirichletFlag
        RawModel.paramMat{k} = RawModel.paramMat{k}(~dMark,~dMark);
    end
end

RawModel.rhs  = cell(RawModel.numLeftVecs,1);
RawModel.lVec = cell(RawModel.numLeftVecs,1);
for k = 1:RawModel.numLeftVecs
    RawModel.rhs{k}  = vectorReader([modelName, 'rhs_', num2str(k-1), '.fVec']);
    RawModel.lVec{k} = vectorReader([modelName, 'leftVec_', num2str(k-1), ...
        '.fVec']);
    if removeDirichletFlag
        RawModel.rhs{k} = RawModel.rhs{k}(~dMark);
        RawModel.lVec{k} = RawModel.lVec{k}(~dMark);
    end
end

if RawModel.abcFlag
    RawModel.abcMat = MatrixMarketReader(strcat(modelName, 'ABC.mm'));
    if removeDirichletFlag
        RawModel.abcMat = RawModel.abcMat(~dMark,~dMark);
    end
end

c0 = 299792.458e3;
RawModel.k0 = 2*pi*RawModel.f0/c0;
