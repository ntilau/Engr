function UnredModel = buildUnredModCircABCD(RawModel, linFreqParamFlag, ...
  transparentFlag, muRelExp, kappaRelExp)


if transparentFlag && linFreqParamFlag
  error(['Transparent BCs (TranspFlag = true) do not lead to ' ...
    'linear parameter dependence!']);
end

% construct matrix with the ordering of the coefficients
permutMat = [];   % first column describes frequency dependence
maxOrder = 4;     % maximum order of parameter dependence
for k = 0:maxOrder
  permutMat = rec(3, k, permutMat, 0, 1);
end

% intruduce shortcuts
mT  = RawModel.k2_mat;
mS1 = RawModel.paramMat{1};
mS2 = RawModel.paramMat{2};
mS3 = RawModel.paramMat{3};
k0  = RawModel.k0;
mS  = RawModel.mS;

% build unreduced model with expansion point [0 0 0]
sysMat = cell(size(permutMat,1),1);
rowNum = findRowInMat([0 2 0], permutMat);
sysMat{rowNum} = mS;
rowNum = findRowInMat([0 0 2], permutMat);
sysMat{rowNum} = -mS;
rowNum = findRowInMat([0 1 0], permutMat);
sysMat{rowNum} = mS1;
rowNum = findRowInMat([0 0 1], permutMat);
sysMat{rowNum} = 1j*mS2;
rowNum = findRowInMat([0 0 0], permutMat);
sysMat{rowNum} = mS3;
rowNum = findRowInMat([2 2 0], permutMat);
sysMat{rowNum} = -mT;
rowNum = findRowInMat([2 0 2], permutMat);
sysMat{rowNum} = mT;

% shift expansion point
shift = [k0 muRelExp kappaRelExp];
UnredModel.A = shiftExpPoint(sysMat, permutMat, shift);

UnredModel.B{1} = zeros(length(RawModel.rhs{1}),length(RawModel.rhs));
for iCol = 1:length(RawModel.rhs)
  UnredModel.B{1}(:,iCol) = RawModel.rhs{iCol};
end

UnredModel.C{1} = zeros(length(RawModel.lVec),length(RawModel.lVec{1}));
for iRow = 1:length(RawModel.lVec)
  UnredModel.C{1}(iRow,:) = RawModel.lVec{iRow}.';
end

if RawModel.abcFlag
  error('ABCs do not lead to linear parameter dependence!');
end

UnredModel.permutMat     = permutMat;
UnredModel.paramNames    = RawModel.paramNames;
UnredModel.paramValInExp = RawModel.paramValInExp;
UnredModel.k0            = RawModel.k0;


