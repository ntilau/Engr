function fNameSpara = compareRed2UnredModel(modelName, impedanceFlag, ...
  linFreqParamFlag)

%% load unreduced model

tic
disp(' ');
disp('Loading model...');
c0 = 299792.458e3;
linearFlag = linFreqParamFlag;

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[f0, paramNames, paramValInExp, numLeftVecs, abcFlag] = ...
  readModParaTxt(fNameModRedTxt);

useKrylovSpaces = vectorReader(strcat(modelName, 'useKrylovSpaces.txt'));

numParams = length(paramNames)+1;
c0 = 299792.458e3;
mu0 = 4e-7*pi;
k0 = 2*pi*f0/c0;

% construct matrix with the ordering of the coefficients
permutMat=[];   % first column describes frequency dependence
if linFreqParamFlag
  maxOrder = 1;   % maximum order of parameter dependence
else
  maxOrder = 3;   % maximum order of parameter dependence
end
for k=0:maxOrder
  permutMat = rec(numParams, k, permutMat, 0, 1);
end

% read system matrices
sys0 = MatrixMarketReader(strcat(modelName, 'system matrix'));
k2_mat = MatrixMarketReader(strcat(modelName, 'k^2 matrix'));
for k = 1:numLeftVecs
  ident{k} = MatrixMarketReader(strcat(modelName, 'ident', num2str(k-1)));
end
for k = 1:length(paramNames)
  % names of the material matrices are equal to the parameter names
  paramMat{k} = MatrixMarketReader(strcat(modelName, paramNames{k}));
end
toc


%% load reduced model
tic
disp(' ');
disp('Loading model...');

% read names of the reduced system matrices, indicating their polynomial
% parameter dependence
fName = strcat(modelName, 'sysMatRedNames');
sysMatRedNames = readSysMatRedNames(fName);
orderParamDependence = sum(sysMatRedNames(end,:));
linearFlag = false;
if orderParamDependence == 1
  % System matrix of ROM only shows linear parameter dependence
  linearFlag = true;
end
[r c] = size(sysMatRedNames);

% read reduced system matrices
for k = 1:r
  fName = strcat(modelName, strcat('sysMatRed_', ...
    num2str(sysMatRedNames(k,1))));
  for m = 2:c
    fName = strcat(fName, '_', num2str(sysMatRedNames(k,m)));
  end
  sysRed{k} = readMatFull(fName);
end

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[fExp, paramNames, paramValInExp, numLeftVecs, abcFlag] = ...
  readModParaTxt(fNameModRedTxt);

for k = 1:numLeftVecs
  % read leftVecs
  fNameLeftVecs = strcat(modelName, 'leftVecsRed', num2str(k-1));
  leftVecsRed(k,:) = vectorReader(fNameLeftVecs).';
  % read RHSs
  fNameRHS = strcat(modelName, 'redRhs', num2str(k-1));
  rhsRed{k} = vectorReader(fNameRHS);
  % read identRed
  fNameIdent = strcat(modelName, 'identRed', num2str(k-1));
  identRed{k} = readMatFull(fNameIdent);
end

% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);

% compute parameter steps of material parameters
for k = 1:length(materialParams)
  if strcmp(materialParams(k).name, 'MU_RELATIVE')
    materialParams(k).steps = calcMuSteps(paramValInExp(k), ...
      materialParams(k).min, materialParams(k).max, ...
      materialParams(k).numPnts);
  elseif strfind(paramNames{k}, 'EPSILON_RELATIVE')
    if linearFlag
      error('EPSILON_RELATIVE does not lead to linear parameter dependence!');
    else
      materialParams(k).steps = calcEpsSteps(paramValInExp(k), ...
        materialParams(k).min, materialParams(k).max, ...
        materialParams(k).numPnts);
    end
  else
    error('Unknown material parameter!');
  end
end

% compute parameter steps of frequency parameter
if linearFlag
  freqParam.steps = calcK_SquareRelSteps(fExp, freqParam.fMin, ...
    freqParam.fMax, freqParam.numPnts);
else
  freqParam.steps = calcRelWaveNumberSteps(fExp, freqParam.fMin, ...
    freqParam.fMax, freqParam.numPnts);
end
scaleRHS = calcScaleRHS(fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff);
scaleIdent = calcScaleIdent(fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff);

% warning off all;
warning off;

pos = 1;
currentStepVals = zeros(length(materialParams), 1);
currentParamVals = zeros(length(materialParams), 1);
if isempty(materialParams)
  stepSpace = [];
  paramSpace = [];
else
  [stepSpace paramSpace] = buildStepSpace(materialParams, pos, [], [], ...
    currentStepVals, currentParamVals);
end

toc


%% Build parameter dependend unreduced model
tic
disp(' ')
disp('Building parameter dependend unreduced model...');
% sysMat{1} = [];
sysMat{1} = sys0;

if linFreqParamFlag
  sysMat{2} = -k0^2 * k2_mat;
  % linear material parameter dependences
  for k = 1:length(paramNames)
    row = zeros(1, numParams);  % row describing parameter dependence
    row(k+1) = 1;               % linear parameter dependence
    rowPos = findRowInMat(row,permutMat);
    if strfind(paramNames{k}, 'EPSILON_RELATIVE')
      error('EPSILON_RELATIVE does not lead to linear parameter dependence!');
    elseif strfind(paramNames{k}, 'MU_RELATIVE')
      sysMat{rowPos} = paramMat{k};
    else
      error('Unknown material parameter!');
    end
  end
  if abcFlag
    error('ABCs do not lead to linear parameter dependence!');
  end
else
  % linear material parameter dependences
  for k = 1:length(paramNames)
    row = zeros(1, numParams);  % row describing parameter dependence
    row(k+1) = 1;               % linear parameter dependence
    rowPos = findRowInMat(row,permutMat);
    if strfind(paramNames{k}, 'EPSILON_RELATIVE')
      sysMat{rowPos} = -k0^2 * paramMat{k};
    elseif strfind(paramNames{k}, 'MU_RELATIVE')
      sysMat{rowPos} = paramMat{k};
    else
      error('Unknown material parameter!');
    end
  end

  sysMat{2} = -2 * k0^2 * k2_mat;   % linear k dependence

  if abcFlag
    abcMat = MatrixMarketReader(strcat(modelName, 'ABC'));
    sysMat{2} = sysMat{2} + abcMat;
  end

  % second order dependence:
  sysMat{numParams + 2} = -k0^2 * k2_mat;  % k^2 dependence is -k^2*T
  for k = 1:length(paramNames)
    row = zeros(1, numParams);  % row describing parameter dependence
    row(1) = 1;                 % linear frequency dependence
    row(k+1) = 1;               % linear parameter dependence
    rowPos = findRowInMat(row,permutMat);
    if strfind(paramNames{k}, 'EPSILON_RELATIVE')
      sysMat{rowPos} = -2 * k0^2 * paramMat{k};
    end
  end

  % third order dependence:
  for k = 1:length(paramNames)
    row = zeros(1, numParams);  % row describing parameter dependence
    row(1) = 2;                 % square frequency dependence
    row(k+1) = 1;               % linear parameter dependence
    rowPos = findRowInMat(row,permutMat);
    if strfind(paramNames{k}, 'EPSILON_RELATIVE')
      sysMat{rowPos} = -k0^2 * paramMat{k};
    end
  end
end

rhs = cell(numLeftVecs, 1);
leftVecs = cell(numLeftVecs, 1);
for k = 1:numLeftVecs
  rhs{k} = -2 * j * vectorReader(strcat(modelName, 'rhs', num2str(k - 1)));
  leftVecs{k} = vectorReader(strcat(modelName, 'leftVec', num2str(k-1)));
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
  readModParaTxt(fNameModRedTxt);

% read "model.pvar"
fNameModPvar = strcat(modelName, 'modelFull.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);

% compute parameter steps of material parameters
for k = 1:length(materialParams)
  if strcmp(materialParams(k).name, 'MU_RELATIVE')
    materialParams(k).steps = calcMuSteps(paramValInExp(k), ...
      materialParams(k).min, materialParams(k).max, ...
      materialParams(k).numPnts);
  elseif strfind(paramNames{k}, 'EPSILON_RELATIVE')
    if linearFlag
      error('EPSILON_RELATIVE does not lead to linear parameter dependence!');
    else
      materialParams(k).steps = calcEpsSteps(paramValInExp(k), ...
        materialParams(k).min, materialParams(k).max, ...
        materialParams(k).numPnts);
    end
  else
    error('Unknown material parameter!');
  end
end

% compute parameter steps of frequency parameter
if linearFlag
  freqParam.steps = calcK_SquareRelSteps(fExp, freqParam.fMin, ...
    freqParam.fMax, freqParam.numPnts);
else
  freqParam.steps = calcRelWaveNumberSteps(fExp, freqParam.fMin, ...
    freqParam.fMax, freqParam.numPnts);
end
scaleRHS = calcScaleRHS(fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff);
scaleIdent = calcScaleIdent(fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff);

% warning off all;
warning off;

pos = 1;
currentStepVals = zeros(length(materialParams), 1);
currentParamVals = zeros(length(materialParams), 1);
if isempty(materialParams)
  stepSpace = [];
  paramSpace = [];
else
  [stepSpace paramSpace] = buildStepSpace(materialParams, pos, [], [], ...
    currentStepVals, currentParamVals);
end
fName = strcat(modelName, 'sysMatRedNames');
sysMatRedNames = readSysMatRedNames(fName);
[r c] = size(sysMatRedNames);

% delete empty matrices from cell array sysMat
nnNonEmpty = 0;
for matCnt = 1 : length(sysMat)
  if ~isempty(sysMat{matCnt})
    nnNonEmpty = nnNonEmpty + 1;
  end
end
sysMatNew = cell(1, nnNonEmpty);
foundNotEmpty = 1;
for matCnt = 1 : length(sysMat)
  if ~isempty(sysMat{matCnt})
    sysMatNew{foundNotEmpty} = sysMat{matCnt};
    foundNotEmpty = foundNotEmpty + 1;
  end
end
clear sysMat;
sysMat = sysMatNew;   % can be made more memory efficient
clear sysMatNew;

toc

%% solve model
disp(' ');
disp('Solving model ...');
tic

[rSpace cSpace] = size(stepSpace);
row = zeros(1, c);
row(1, 1) = 1;
if linearFlag
  % find system matrix with frequency dependence
  posFreq = findRowInMat(row, sysMatRedNames);
else
  % find system matrix with linear k dependence
  posLinK = findRowInMat(row, sysMatRedNames);
  row(1, 1) = 2;
  % find system matrix with square k dependence
  posSquK = findRowInMat(row, sysMatRedNames);
end

load Q;

sMat = cell(freqParam.numPnts, 1);
sMatRed = cell(freqParam.numPnts, 1);
resSol = [];
resSolRed = [];
for kStepCnt = 1:freqParam.numPnts
  if linearFlag
    fMat = sysMat{1} + freqParam.steps(kStepCnt) * sysMat{posFreq};
    fMatRed = sysRed{1} + freqParam.steps(kStepCnt) * sysRed{posFreq};
  else
    fMat = sysMat{1} + freqParam.steps(kStepCnt)*sysMat{posLinK} + ...
      freqParam.steps(kStepCnt)^2*sysMat{posSquK};
    fMatRed = sysRed{1} + freqParam.steps(kStepCnt) * sysRed{posLinK} + ...
      freqParam.steps(kStepCnt) ^ 2 * sysRed{posSquK};
  end
  if ~impedanceFlag
    for excitationCnt = 1:numLeftVecs
      fMat = fMat + scaleIdent{excitationCnt}(kStepCnt) ...
        * ident{excitationCnt};
      fMatRed = fMatRed + scaleIdent{excitationCnt}(kStepCnt) ...
        * identRed{excitationCnt};
    end
  end
  for k = 1:numLeftVecs
    % rhs is only frequency dependent
    if impedanceFlag
      rhsScaled{k} = -0.5*scaleRHS{k}(kStepCnt)*rhs{k};
      redRhsScaled{k} = -0.5 * scaleRHS{k}(kStepCnt) * rhsRed{k};
    else
      rhsScaled{k} = scaleRHS{k}(kStepCnt)*rhs{k};
      redRhsScaled{k} = scaleRHS{k}(kStepCnt) * rhsRed{k};
    end
  end
  if cSpace
    for pntCnt = 1:cSpace
      currentMat = fMat;
      currentMatRed = fMatRed;
      for sysMatCnt = 1:length(sysMat)
        if sysMatRedNames(sysMatCnt, 2:end) == ...
            zeros(1, length(materialParams))
          % do nothing, only pure frequency dependence,
          % which is already considered
        else
          scale = 1;
          % frequency dependence
          scale = scale * ...
            (freqParam.steps(kStepCnt))^sysMatRedNames(sysMatCnt,1);
          % material dependence
          if length(sysMatRedNames(sysMatCnt,:)) > 1
            for pCnt = 2:length(sysMatRedNames(sysMatCnt,:))
              scale = scale * ...
                stepSpace(pCnt-1, pntCnt)^sysMatRedNames(sysMatCnt, pCnt);
            end
          end
          % add matrices to build system matrix
          % in current point in parameter space
          currentMat = currentMat + scale * sysMat{sysMatCnt};
          currentMatRed = currentMatRed + scale * sysRed{sysMatCnt};
        end
      end
      [L, U, P, V] = lu(currentMat);
      [Lr Ur Pr] = lu(currentMatRed);
      for rhsCnt = 1:length(redRhsScaled)
        %         sol = currentMat\redRhsScaled{rhsCnt};    % solve equation system
        sol = V * (U \ (L \ (P * rhsScaled{rhsCnt})));
        solRed = Ur \ (Lr \ (Pr * redRhsScaled{rhsCnt}));
        % residual check
        solRedExt = Q * solRed;
        resSol = [resSol; norm(rhsScaled{rhsCnt} - currentMat * sol) / norm(rhsScaled{rhsCnt})];
        resSolRed = [resSolRed; norm(rhsScaled{rhsCnt} - currentMat * solRedExt) / norm(rhsScaled{rhsCnt})];

        for lVecCnt = 1:numLeftVecs
          %           sMat{(kStepCnt-1)*cSpace + pntCnt}(lVecCnt, rhsCnt) = ...
          %             leftVecs(lVecCnt,:)*sol;
          sMat{(kStepCnt-1)*cSpace + pntCnt}(lVecCnt, rhsCnt) = ...
            leftVecs{lVecCnt}.' * sol;
          sMatRed{(kStepCnt-1)*cSpace + pntCnt}(lVecCnt, rhsCnt) = ...
            leftVecsRed{lVecCnt}.' * solRed;
        end
      end
    end
  else  % no material dependence, only pure frequency dependence
    [L, U, P, V] = lu(fMat);
    [Lr, Ur, Pr] = lu(fMatRed);
    for rhsCnt = 1:length(redRhsScaled)
      %       sol = fMat\redRhsScaled{rhsCnt};      % solve equation system
      sol = V * (U \ (L \ (P * rhsScaled{rhsCnt})));
      solRed = Ur \ (Lr \ (Pr * redRhsScaled{rhsCnt}));
      % residual check
      solRedExt = Q * solRed;
      resSol = [resSol; norm(rhsScaled{rhsCnt} - fMat * sol) / norm(rhsScaled{rhsCnt})];
      resSolRed = [resSolRed; norm(rhsScaled{rhsCnt} - fMat * solRedExt) / norm(rhsScaled{rhsCnt})];
      for lVecCnt = 1:numLeftVecs
        %         sMat{kStepCnt}(lVecCnt, rhsCnt) = leftVecs(lVecCnt,:)*sol;
        sMat{kStepCnt}(lVecCnt, rhsCnt) = leftVecs{lVecCnt}.' * sol;
        sMatRed{kStepCnt}(lVecCnt, rhsCnt) = leftVecsRed(lVecCnt, :) * solRed;
      end
    end
  end
end

if impedanceFlag
  % sMat is really an impedance matrix
  % compute scattering matrix from the impedance matrix
  for sMatCnt = 1:length(sMat)
    %     sMat{sMatCnt}(1, 2) = sMat{sMatCnt}(2, 1);
    %     sMat{sMatCnt}(2, 2) = sMat{sMatCnt}(1, 1);
    %     sMat{sMatCnt} = inv(sMat{sMatCnt} + eye(numLeftVecs))...
    %       * (sMat{sMatCnt} - eye(numLeftVecs));
    sMat{sMatCnt} = inv(sMat{sMatCnt} - eye(numLeftVecs))...
      * (sMat{sMatCnt} + eye(numLeftVecs));
    sMatRed{sMatCnt} = inv(sMatRed{sMatCnt} - eye(numLeftVecs))...
      * (sMatRed{sMatCnt} + eye(numLeftVecs));
  end
else
  % subtract excitation
  for k = 1:length(sMat)
    [r c] = size(sMat{k});
    sMat{k} = sMat{k} - eye(r, c);
    sMatRed{k} = sMatRed{k} - eye(r, c);
  end
end

toc

%% Save results
disp(' ');
disp('Saving results ...');
tic

fNameSpara = strcat(modelName, 'S_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
  num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));
for k = 1:length(paramNames)
  fNameSpara = strcat(fNameSpara, '_', paramNames{k}, '_', num2str(materialParams(k).min,'%14.14g'), '_', ...
    num2str(materialParams(k).max,'%14.14g'), '_', num2str(materialParams(k).numPnts,'%14.14g'));
end
fNameSparaRed = strcat(fNameSpara, '.txt');
fNameSpara = strcat(fNameSpara, '_full.txt');

saveSmatrix(sMat, freqParam, materialParams, fNameSpara, numLeftVecs, paramSpace, paramNames);
saveSmatrix(sMatRed, freqParam, materialParams, fNameSparaRed, numLeftVecs, paramSpace, paramNames);

display(resSol);
display(resSolRed);

save residuals resSol resSolRed;

toc
