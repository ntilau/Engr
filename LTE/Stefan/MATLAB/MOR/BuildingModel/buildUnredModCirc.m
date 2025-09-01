function UnredModel = buildUnredModCirc(RawModel, linFreqParamFlag, ...
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
mM  = RawModel.sys0;
mT  = RawModel.k2_mat;
mS1 = RawModel.paramMat{1};
mS2 = RawModel.paramMat{2};
mS3 = RawModel.paramMat{3};
k0  = RawModel.k0;
mS  = RawModel.mS;

% UnredModel.sysMat = cell(size(permutMat,1),1);
% UnredModel.sysMat{1} = (muRelExp^2-kappaRelExp^2)*mM + muRelExp*mS1 + ...
%   1j*kappaRelExp*mS2 + mS3;

% UnredModel.sysMat{2} = (-muRelExp^2+kappaRelExp^2)*mT;
% UnredModel.sysMat{3} = 2*muRelExp*mM + mS1;
% %%%%%%%%%%%%%%%%%
% % three parameter: quadratic frequency parameter
% %%%%%%%%%%%%%%%%%
% % UnredModel.sysMat{4} = -2*kappaRelExp*mM + 1j*mS2;
% % rowNum = findRowInMat([1 1 0], permutMat);
% % UnredModel.sysMat{rowNum} = -2*muRelExp*mT;
% % rowNum = findRowInMat([1 0 1], permutMat);
% % UnredModel.sysMat{rowNum} = 2*kappaRelExp*mT;
% % rowNum = findRowInMat([0 2 0], permutMat);
% % UnredModel.sysMat{rowNum} = mM;
% % rowNum = findRowInMat([0 0 2], permutMat);
% % UnredModel.sysMat{rowNum} = -mM;
% % rowNum = findRowInMat([1 2 0], permutMat);
% % UnredModel.sysMat{rowNum} = -mT;
% % rowNum = findRowInMat([1 0 2], permutMat);
% % UnredModel.sysMat{rowNum} = mT;


% %%%%%%%%%%%%%%%%%
% % three parameter: linear frequency parameter
% %%%%%%%%%%%%%%%%%
% UnredModel.sysMat = cell(size(permutMat,1),1);
% UnredModel.sysMat{1} = (muRelExp^2-kappaRelExp^2)*mM + muRelExp*mS1 + ...
%   1j*kappaRelExp*mS2 + mS3;
% UnredModel.sysMat{2} = (-2*k0*muRelExp^2+2*k0*kappaRelExp^2)*mT;
% UnredModel.sysMat{3} = -2*k0^2*muRelExp*mT + 2*muRelExp*mS + mS1;
% UnredModel.sysMat{4} = 2*k0^2*kappaRelExp*mT - 2*kappaRelExp*mS + 1j*mS2;
% rowNum = findRowInMat([2 0 0], permutMat);
% UnredModel.sysMat{rowNum} = -(muRelExp^2-kappaRelExp^2)*mT;
% rowNum = findRowInMat([1 1 0], permutMat);
% UnredModel.sysMat{rowNum} = -4*k0*muRelExp*mT;
% rowNum = findRowInMat([1 0 1], permutMat);
% UnredModel.sysMat{rowNum} = 4*k0*kappaRelExp*mT;
% rowNum = findRowInMat([0 2 0], permutMat);
% UnredModel.sysMat{rowNum} = mM;
% rowNum = findRowInMat([0 0 2], permutMat);
% UnredModel.sysMat{rowNum} = -mM;
% rowNum = findRowInMat([2 1 0], permutMat);
% UnredModel.sysMat{rowNum} = -2*muRelExp*mT;
% rowNum = findRowInMat([2 0 1], permutMat);
% UnredModel.sysMat{rowNum} = 2*kappaRelExp*mT;
% rowNum = findRowInMat([1 2 0], permutMat);
% UnredModel.sysMat{rowNum} = -2*k0*mT;
% rowNum = findRowInMat([1 0 2], permutMat);
% UnredModel.sysMat{rowNum} = 2*k0*mT;
% rowNum = findRowInMat([2 2 0], permutMat);
% UnredModel.sysMat{rowNum} = -mT;
% rowNum = findRowInMat([2 0 2], permutMat);
% UnredModel.sysMat{rowNum} = mT;


% % scaling factors for rhs -> not necessary
% UnredModel.rhsScal{1} = k0*(muRelExp^2-kappaRelExp^2);
% rowNum = findRowInMat([1 0 0], permutMat);
% UnredModel.rhsScal{rowNum} = (muRelExp^2-kappaRelExp^2);
% rowNum = findRowInMat([0 1 0], permutMat);
% UnredModel.rhsScal{rowNum} = 2*k0*muRelExp;
% rowNum = findRowInMat([0 0 1], permutMat);
% UnredModel.rhsScal{rowNum} = -2*k0*kappaRelExp;
% rowNum = findRowInMat([0 2 0], permutMat);
% UnredModel.rhsScal{rowNum} = k0;
% rowNum = findRowInMat([0 0 2], permutMat);
% UnredModel.rhsScal{rowNum} = -k0;
% rowNum = findRowInMat([1 1 0], permutMat);
% UnredModel.rhsScal{rowNum} = 2*muRelExp;
% rowNum = findRowInMat([1 0 1], permutMat);
% UnredModel.rhsScal{rowNum} = -2*kappaRelExp;
% rowNum = findRowInMat([1 2 0], permutMat);
% UnredModel.rhsScal{rowNum} = 1;
% rowNum = findRowInMat([1 0 2], permutMat);
% UnredModel.rhsScal{rowNum} = -1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% three parameter: linear frequency parameter -> automatic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
UnredModel.sysMat = shiftExpPoint(sysMat, permutMat, shift);

% sysMat = cell(size(permutMat,1),1);
% shift = [k0 muRelExp kappaRelExp];
% degree = [0 2 0];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, mS);
% degree = [0 0 2];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, -mS);
% degree = [0 1 0];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, mS1);
% degree = [0 0 1];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, 1j*mS2);
% sysMat{1} = sysMat{1} + mS3;
% degree = [2 2 0];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, -mT);
% degree = [2 0 2];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, mT);
% UnredModel.sysMat = sysMat;


% for k = 1:length(UnredModel.sysMat)
%   if ~isempty(UnredModel2.sysMat{k})
%     display(k);
%     display(max(max(abs(UnredModel2.sysMat{k}-UnredModel.sysMat{k}))));
%   end
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % three parameter: quadratic frequency parameter -> automatic
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sysMat = cell(size(permutMat,1),1);
% shift = [k0^2 muRelExp kappaRelExp];
% degree = [0 2 0];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, mS);
% degree = [0 0 2];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, -mS);
% degree = [0 1 0];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, mS1);
% degree = [0 0 1];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, 1j*mS2);
% sysMat{1} = sysMat{1} + mS3;
% degree = [1 2 0];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, -mT);
% degree = [1 0 2];
% [v mPowers] = getShiftedMultivariatePolynom(degree, shift);
% sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, mT);
% UnredModel.sysMat = sysMat;


% %%%%%%%%%%%%%%%%%
% % two parameters: frequency + mu
% %%%%%%%%%%%%%%%%%

% rowNum = findRowInMat([1 1], permutMat);
% UnredModel.sysMat{rowNum} = -2*muRelExp*mT;
% rowNum = findRowInMat([0 2], permutMat);
% UnredModel.sysMat{rowNum} = mM;
% rowNum = findRowInMat([1 2], permutMat);
% UnredModel.sysMat{rowNum} = -mT;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% two parameters: mu + kappa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UnredModel.sysMat{2} = 2*muRelExp*mM + mS1;
% UnredModel.sysMat{3} = -2*kappaRelExp*mM + 1j*mS2;
% rowNum = findRowInMat([2 0], permutMat);
% UnredModel.sysMat{rowNum} = mM;
% rowNum = findRowInMat([0 2], permutMat);
% UnredModel.sysMat{rowNum} = -mM;


% %%%%%%%%%%%%%%%%%%%%%%
% % mu is only parameter
% %%%%%%%%%%%%%%%%%%%%%%
% UnredModel.sysMat{2} = 2*muRelExp*mM + mS1;
% UnredModel.sysMat{3} = mM;

if RawModel.abcFlag
  error('ABCs do not lead to linear parameter dependence!');
end

UnredModel.permutMat       = permutMat;
UnredModel.paramNames      = RawModel.paramNames;
UnredModel.paramValInExp   = RawModel.paramValInExp;
UnredModel.numLeftVecs     = RawModel.numLeftVecs;
UnredModel.useKrylovSpaces = RawModel.useKrylovSpaces;
UnredModel.numParams       = 3;
UnredModel.ident           = RawModel.ident;
UnredModel.lVec            = RawModel.lVec;
UnredModel.k0              = RawModel.k0;
UnredModel.rhs             = RawModel.rhs;


function sysMat = add2SysMatCell(sysMat, permutMat, v, mPowers, A)

for iCoeff = 1:length(v)
  rowNum = findRowInMat(mPowers(iCoeff,:), permutMat);
  if isempty(sysMat{rowNum})
    sysMat{rowNum} = v(iCoeff)*A;
  else
    sysMat{rowNum} = sysMat{rowNum} + v(iCoeff)*A;
  end
end
