close all;
clear;

addpath(genpath('C:\Work\Matlab'));
set(0,'DefaultFigureWindowStyle','docked');
fontsize = 24;
linewidth = 2.5;

c0 = 299792.458e3;


%% read raw model
modelName = 'C:\work\examples\permittivity_measurement\wg_perm_sym\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(5,0)_50\';
sys0 = mmread([modelName 'system matrix.mm']);
k2_mat = mmread([modelName 'k^2 matrix.mm']);
mMat = mmread([modelName 'MU_RELATIVE_sample.mm']);
dMark = vectorReader([modelName, 'dirMarker.fvec']);
rhs0 = vectorReader([modelName, 'rhs_0.fvec']);
rhs1 = vectorReader([modelName, 'rhs_1.fvec']);
lVec0 = vectorReader([modelName, 'leftVec_0.fvec']);
lVec1 = vectorReader([modelName, 'leftVec_1.fvec']);
fExpRhs = 12e9;




%% build unreduced multiparameter model
% construct matrix with the ordering of the coefficients
permutMat = [];   % first column describes frequency dependence
% maxOrder = 1;
maxOrder = 1;
for k = 0:maxOrder
  permutMat = rec(2, k, permutMat, 0, 1);
end

% build unreduced model with expansion point zero
sysMat = cell(size(permutMat,1),1);
sysMat{1} = sys0(~dMark,~dMark) + (2*pi*fExpRhs/c0)^2*k2_mat(~dMark,~dMark);
sysMat{2} = (2*pi*fExpRhs/c0)^2*k2_mat(~dMark,~dMark);
sysMat{3} = mMat(~dMark,~dMark);

Model.A = sysMat;
B = zeros(size(sysMat{1},1),2);
B(:,1) = 1j*rhs0(~dMark);
B(:,2) = 1j*rhs1(~dMark);
Model.B = cell(size(permutMat,1),1);
Model.B{1} = B;
Model.C = cell(size(permutMat,1),1);
C = zeros(2,size(sysMat{1},1));
C(1,:) = lVec0(~dMark);
C(2,:) = lVec1(~dMark);
Model.C{1} = C;
Model.permutMat = permutMat;


%% create multiparameter ROM
order = 8;
orthoFlag = true;
pardisoFlag = false;
expPnt = [((2*pi*13e9/c0).^2 ./ (2*pi*fExpRhs/c0).^2 - 1) 0];

ModelShifted = shiftExpPntABCD(Model, expPnt);  % shift expansion point
[Fact.L, Fact.U, Fact.P, Fact.Q] = lu(ModelShifted.A{1});
K = compInputKrySpaceABCD(ModelShifted, Fact, order, orthoFlag, pardisoFlag);
clear Fact;
RedModel = projModelABCD(Model, K.', K);


%% solve multiparameter reduced model

fCutOff = 7.4948113728104897e+009;
f = linspace(8e9, 17e9, 51);
parPnts = zeros(length(f),2);
parPnts(:,1) = (2*pi*f/c0).^2 ./ (2*pi*fExpRhs/c0).^2 - 1;

tmFlag = true;
scaleRHS = calcScaleRHS(fExpRhs, f(1), f(end), length(f), fCutOff, tmFlag);

res = solvePolyModel(RedModel, parPnts);
resRed = zeros(length(res),1);
for iPnt = 1:length(res)
  P = eye(2,2);
  for k = 1:2
    P(k,k) = sqrt(scaleRHS{1}(iPnt)); % frequency dependent normalization
  end
  mZ = P * res{iPnt} * P;
  sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
  resRed(iPnt) = sMat(1,1);
end
figure;
plot(f, abs(resRed));

fNameSpara = 'C:\work\examples\permittivity_measurement\wg_perm_sym\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(5,0)_50_old\S_f_8000000000_17000000000_51_MU_RELATIVE_sample_5_5_1_full.mat';
ResultsFull = load(fNameSpara);
sVal11Full = zeros(ResultsFull.freqParam.numPnts,1);
for k = 1:ResultsFull.freqParam.numPnts
  sVal11Full(k) = ResultsFull.sMat{k}(1,1);
end
figure;
semilogy(f, abs(sVal11Full-resRed));










%% build unreduced multiparameter model
% construct matrix with the ordering of the coefficients
permutMat = [];   % first column describes frequency dependence
% maxOrder = 1;
maxOrder = 1;
for k = 0:maxOrder
  permutMat = rec(2, k, permutMat, 0, 1);
end

% build unreduced model with expansion point zero
sysMat = cell(size(permutMat,1),1);
sysMat{1} = sys0(~dMark,~dMark);
sysMat{2} = k2_mat(~dMark,~dMark);
sysMat{3} = mMat(~dMark,~dMark);

Model.A = sysMat;
B = zeros(size(sysMat{1},1),2);
B(:,1) = 1j*rhs0(~dMark);
B(:,2) = 1j*rhs1(~dMark);
Model.B = cell(size(permutMat,1),1);
Model.B{1} = B;
Model.C = cell(size(permutMat,1),1);
C = zeros(2,size(sysMat{1},1));
C(1,:) = lVec0(~dMark);
C(2,:) = lVec1(~dMark);
Model.C{1} = C;
Model.permutMat = permutMat;


%% create multiparameter ROM
order = 8;
fExp = 12e9;
expPnt = [(2*pi*fExp/c0)^2 0];
orthoFlag = true;
pardisoFlag = false;

ModelShifted = shiftExpPntABCD(Model, expPnt);  % shift expansion point
[Fact.L, Fact.U, Fact.P, Fact.Q] = lu(ModelShifted.A{1});
K = compInputKrySpaceABCD(ModelShifted, Fact, order, orthoFlag, pardisoFlag);
clear Fact;
RedModel = projModelABCD(Model, K.', K);


%% solve multiparameter reduced model

fCutOff = 7.4948113728104897e+009;
f = linspace(8e9, 17e9, 51);
parPnts = zeros(length(f),2);
parPnts(:,1) = (2*pi*f/c0).^2;

tmFlag = true;
scaleRHS = calcScaleRHS(fExpRhs, f(1), f(end), length(f), fCutOff, tmFlag);

res = solvePolyModel(RedModel, parPnts);
resRed = zeros(length(res),1);
for iPnt = 1:length(res)
  P = eye(2,2);
  for k = 1:2
    P(k,k) = sqrt(scaleRHS{1}(iPnt)); % frequency dependent normalization
  end
  mZ = P * res{iPnt} * P;
  sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
  resRed(iPnt) = sMat(1,1);
end
figure;
plot(f, abs(resRed));

fNameSpara = 'C:\work\examples\permittivity_measurement\wg_perm_sym\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(5,0)_50_old\S_f_8000000000_17000000000_51_MU_RELATIVE_sample_5_5_1_full.mat';
ResultsFull = load(fNameSpara);
sVal11Full = zeros(ResultsFull.freqParam.numPnts,1);
for k = 1:ResultsFull.freqParam.numPnts
  sVal11Full(k) = ResultsFull.sMat{k}(1,1);
end
figure;
semilogy(f, abs(sVal11Full-resRed));



%% 

oneParamModelsOld = cell(18,1);
oneParamModelsNew = cell(18,1);
for k = 1:18
  fName = ['oneParamModelOld_' num2str(k) '.mat'];
  oneParamModelsOld{k} = load(fName);
  fName = ['oneParamModelNew_' num2str(k) '.mat'];
  oneParamModelsNew{k} = load(fName);
end

for k = 1:18
  for iMat = 1:length(oneParamModelsOld{k}.oneParamModel)
    display(nnz(oneParamModelsOld{k}.oneParamModel{iMat} - ...
      oneParamModelsNew{k}.oneParamModel{iMat}));
  end
end



UnredModelNew = load('UnredModelNew.mat');
UnredModelOld = load('UnredModelOld.mat');
for iMat = 1:length(UnredModelNew.Model.A)
  display(nnz(UnredModelNew.Model.A{iMat} - UnredModelOld.UnredModel.sysMat{iMat}));
end



%% build unreduced model -> single parameter frequency

% construct matrix with the ordering of the coefficients
permutMat = [];   % first column describes frequency dependence
% maxOrder = 1;
maxOrder = 1;
for k = 0:maxOrder
  permutMat = rec(1, k, permutMat, 0, 1);
end

% build unreduced model with expansion point zero
sysMat = cell(size(permutMat,1),1);
sysMat{1} = sys0(~dMark,~dMark);
sysMat{2} = k2_mat(~dMark,~dMark);

Model.A = sysMat;
B = zeros(size(sysMat{1},1),2);
B(:,1) = 1j*rhs0(~dMark);
B(:,2) = 1j*rhs1(~dMark);
Model.B = cell(size(permutMat,1),1);
Model.B{1} = B;
Model.C = cell(size(permutMat,1),1);
C = zeros(2,size(sysMat{1},1));
C(1,:) = lVec0(~dMark);
C(2,:) = lVec1(~dMark);
Model.C{1} = C;
Model.permutMat = permutMat;


%% solve unreduced model -> single parameter frequency

fCutOff = 7.4948113728104897e+009;
f = linspace(8e9, 17e9, 51);
parPnts = zeros(length(f),1);
parPnts(:,1) = (2*pi*f/c0).^2;

tmFlag = true;
scaleRHS = calcScaleRHS(fExpRhs, f(1), f(end), length(f), fCutOff, tmFlag);

res = solvePolyModel(Model, parPnts);
resFull = zeros(length(res),1);
for iPnt = 1:length(res)
  P = eye(2,2);
  for k = 1:2
    P(k,k) = sqrt(scaleRHS{1}(iPnt)); % frequency dependent normalization
  end
  mZ = P * res{iPnt} * P;
  sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
  resFull(iPnt) = sMat(1,1);
end
figure;
plot(f, abs(resFull));


%% create single parameter ROM -> frequency parameter
order = 20;
fExp = 12e9;
expPnt = (2*pi*fExp/c0)^2;
orthoFlag = true;
pardisoFlag = false;

ModelShifted = shiftExpPntABCD(Model, expPnt);  % shift expansion point
[Fact.L, Fact.U, Fact.P, Fact.Q] = lu(ModelShifted.A{1});
K = compInputKrySpaceABCD(ModelShifted, Fact, order, orthoFlag, pardisoFlag);
clear Fact;
RedModel = projModelABCD(Model, K.', K);


%% solve single parameter reduced model

fCutOff = 7.4948113728104897e+009;
f = linspace(8e9, 17e9, 51);
parPnts = zeros(length(f),1);
parPnts(:,1) = (2*pi*f/c0).^2;

tmFlag = true;
scaleRHS = calcScaleRHS(fExpRhs, f(1), f(end), length(f), fCutOff, tmFlag);

res = solvePolyModel(RedModel, parPnts);
resRed = zeros(length(res),1);
for iPnt = 1:length(res)
  P = eye(2,2);
  for k = 1:2
    P(k,k) = sqrt(scaleRHS{1}(iPnt)); % frequency dependent normalization
  end
  mZ = P * res{iPnt} * P;
  sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
  resRed(iPnt) = sMat(1,1);
end
figure;
plot(f, abs(resRed));

figure;
semilogy(f, abs(resFull-resRed));


