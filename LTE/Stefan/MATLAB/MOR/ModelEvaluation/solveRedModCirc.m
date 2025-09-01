function fNameSpara = solveRedModCirc(modelName, linFreqParamFlag, ...
  saveMatlabFlag, muRel, kappaRel)


%% load model
tic
disp(' ');
disp('Loading model...');

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[f0, paramNames, paramValInExp, numLeftVecs, abcFlag] = ...
  readModParaTxt(fNameModRedTxt);

% numParams = length(paramNames)+1;
numParams = 1;  % ATTENTION: Only valid for Circulator example
c0 = 299792.458e3;
k0 = 2*pi*f0/c0;

% construct matrix with the ordering of the coefficients
permutMat=[];   % first column describes frequency dependence
if linFreqParamFlag
  maxOrder = 1;   % maximum order of parameter dependence
else
  error('Only linear frequency dependence possible with ciruclator!');
end
for k=0:maxOrder
  permutMat = rec(numParams, k, permutMat, 0, 1);
end

% read system matrices
sys0fName = strcat(modelName, 'system matrix red.fmat');
k2fName = strcat(modelName, 'k^2 matrix red.fmat');
sys0 = readMatFull(sys0fName);
k2_mat = readMatFull(k2fName);
paramMat = cell(length(paramNames),1);
for k = 1:length(paramNames)
  % names of the material matrices are equal to the parameter names
  fName = [modelName paramNames{k} '_red.fmat'];
  paramMat{k} = readMatFull(fName);
end
mMuRel    = paramMat{1};
mKappaRel = paramMat{2};
mMuZ_Rel  = paramMat{3};

rhs = zeros(size(sys0,1), numLeftVecs);
leftVecs = zeros(numLeftVecs, size(sys0,1));
for k = 1:numLeftVecs
  fNameRhs = [modelName 'redRhs_' num2str(k-1) '.fvec'];
  fNameLeftVecs = [modelName 'leftVecRed_' num2str(k-1) '.fvec'];
  rhs(:,k) = 1i * vectorReader(fNameRhs);
  leftVecs(k,:) = vectorReader(fNameLeftVecs);
end


toc


%% Build parameter dependend unreduced model
tic
disp(' ')
disp('Building parameter dependend model...');
sysMat{1} = sys0;

sysMat{2} = -k0^2 * k2_mat;
if abcFlag
  error('ABCs do not lead to linear parameter dependence!');
end

% clear temporary matrices
clear k2_mat;
for k = 1:length(paramNames)
  clear paramMat{k};
end


%% model evaluation

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[fExp, paramNames, paramValInExp, numLeftVecs, abcFlag] = ...
  readModParaTxt(fNameModRedTxt); %#ok<NASGU>

% read "modelFull.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam] = readModParVar(fNameModPvar);

% compute parameter steps of frequency parameter
freqParam.steps = calcK_SquareRelSteps(fExp, freqParam.fMin, ...
  freqParam.fMax, freqParam.numPnts);
scaleRHS = calcScaleRHS(fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff);

toc


%% solve model
disp(' ');
disp('Solving model ...');
tic

posFreq = 2; % system matrix with frequency dependence

sMat = cell(freqParam.numPnts, 1);
% redRhsScaled = cell(numLeftVecs,1);
for kStepCnt = 1:freqParam.numPnts
  fMat = sysMat{1} + freqParam.steps(kStepCnt) * sysMat{posFreq};
  P = eye(numLeftVecs);
  for k = 1:numLeftVecs
    P(k,k) = sqrt(scaleRHS{k}(kStepCnt)); % frequency dependent normalization
  end
  for muCnt = 1:length(muRel)
    for kappaCnt = 1:length(kappaRel)
      mCurr = fMat + (muRel(muCnt)^2-kappaRel(kappaCnt)^2)^-1 * ...
        (muRel(muCnt)*mMuRel + 1j*kappaRel(kappaCnt)*mKappaRel + mMuZ_Rel);
      sol = mCurr \ rhs;  % solve system
      mZ = P * (leftVecs*sol) * P;  % impedance matrix
      sMat{kStepCnt,muCnt,kappaCnt} = (mZ - eye(numLeftVecs)) ...
        \ (mZ + eye(numLeftVecs));  % Z -> S
    end
  end
end

toc

%% Save results
disp(' ');
disp('Saving results ...');
tic

fNameSpara = strcat(modelName, 'S_f_', num2str(freqParam.fMin,'%14.14g'), ...
  '_', num2str(freqParam.fMax,'%14.14g'), '_', ...
  num2str(freqParam.numPnts,'%14.14g'));
if length(muRel) == 1
  fNameSpara = strcat(fNameSpara, '_MU_REL_', num2str(muRel,'%14.14g'));
else
  fNameSpara = strcat(fNameSpara, '_MU_REL_', num2str(muRel(1),'%14.14g'), ...
    '_', num2str(muRel(end),'%14.14g'));
end
if length(kappaRel) == 1
  fNameSpara = strcat(fNameSpara, '_KAPPA_REL_', num2str(kappaRel,'%14.14g'));
else
  fNameSpara = strcat(fNameSpara, '_KAPPA_REL_', num2str(kappaRel(1), ...
    '%14.14g'), '_', num2str(kappaRel(end),'%14.14g'));
end
  
materialParams = [];
paramSpace = [];
paramNames = []; 
if saveMatlabFlag
  fNameSpara = [fNameSpara, '.mat'];
  save(fNameSpara, 'sMat', 'freqParam', 'materialParams', 'numLeftVecs', ...
    'paramSpace', 'paramNames', 'muRel', 'kappaRel');
else
  fNameSpara = [fNameSpara, '.txt'];
  saveSmatrix(sMat, freqParam, materialParams, fNameSpara, numLeftVecs, ...
    paramSpace, paramNames);
end

toc
