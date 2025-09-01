function fNameSpara = modelEvaluation(modelName, impedanceFlag, ...
  newFileEndingFlag, saveMatlabFlag, transparentFlag, tmFlag)


%% load model

tic
disp(' ');
disp('Loading model...');

% read names of the reduced system matrices, indicating their polynomial
% parameter dependence
fName = strcat(modelName, 'sysMatRedNames');
if newFileEndingFlag
  fName = strcat(fName, '.txt');
end
sysMatRedNames = readSysMatRedNames(fName);
orderParamDependence = sum(sysMatRedNames(end,:));
linearFlag = false;
if orderParamDependence == 1
  % System matrix of ROM only shows linear parameter dependence
  linearFlag = true;
end

% read reduced system matrices
[r c] = size(sysMatRedNames);
sys = cell(r, 1);
for k = 1 : r
  fName = strcat(modelName, strcat('sysMatRed_', num2str(sysMatRedNames(k,1))));
  for m = 2 : c
    fName = strcat(fName, '_', num2str(sysMatRedNames(k,m)));
  end
  if newFileEndingFlag
    fName = strcat(fName, '.fmat');
  end
  sys{k} = readMatFull(fName);
end

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[fExp, paramNames, paramValInExp, numLeftVecs] = readModParaTxt(fNameModRedTxt);

leftVecs = zeros(numLeftVecs, size(sys{1}, 1));
rhs = cell(numLeftVecs, 1);
ident = cell(numLeftVecs, 1);
for k = 1 : numLeftVecs
  % read leftVecs
  fNameLeftVecs = strcat(modelName, 'leftVecsRed_', num2str(k-1));
  if newFileEndingFlag
    fNameLeftVecs = strcat(fNameLeftVecs, '.fvec');
  end
  leftVecs(k,:) = vectorReader(fNameLeftVecs).';
  % read RHSs
  fNameRHS = strcat(modelName, 'redRhs_', num2str(k-1));
  if newFileEndingFlag
    fNameRHS = strcat(fNameRHS, '.fvec');
  end
  rhs{k} = vectorReader(fNameRHS);
  % read identRed
  fNameIdent = strcat(modelName, 'identRed_', num2str(k-1));
  if newFileEndingFlag
    fNameIdent = strcat(fNameIdent, '.fmat');
  end
  ident{k} = readMatFull(fNameIdent);
end

% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);

% compute parameter steps of material parameters
for k = 1 : length(materialParams)
  if strcmp(materialParams(k).name, 'MU_RELATIVE')
    materialParams(k).steps = calcMuSteps(paramValInExp(k), materialParams(k).min, materialParams(k).max, ...
      materialParams(k).numPnts);
  elseif strfind(paramNames{k}, 'EPSILON_RELATIVE')
    if linearFlag
      error('EPSILON_RELATIVE does not lead to linear parameter dependence!');
    else
      materialParams(k).steps = calcEpsSteps(paramValInExp(k), materialParams(k).min, materialParams(k).max, ...
        materialParams(k).numPnts);
    end
  else
    error('Unknown material parameter!');
  end
end

% compute parameter steps of frequency parameter
if linearFlag
  freqParam.steps = calcK_SquareRelSteps(fExp, freqParam.fMin, freqParam.fMax, freqParam.numPnts);
else
  freqParam.steps = calcRelWaveNumberSteps(fExp, freqParam.fMin, freqParam.fMax, freqParam.numPnts);
end
scaleRHS = calcScaleRHS(fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff, tmFlag);
scaleIdent = calcScaleIdent(fExp, freqParam.fMin, freqParam.fMax, freqParam.numPnts, freqParam.fCutOff);

pos = 1;
currentStepVals = zeros(length(materialParams), 1);
currentParamVals = zeros(length(materialParams), 1);
if isempty(materialParams)
  stepSpace = [];
  paramSpace = [];
else
  [stepSpace paramSpace] = buildStepSpace(materialParams, pos, [], [], currentStepVals, currentParamVals);
end

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
if isempty(materialParams)
  sMat = cell(freqParam.numPnts, 1);
else
  sMat = cell(freqParam.numPnts * cSpace, 1);
end

rhsMatrix = zeros(length(rhs{1}), numLeftVecs);
for k = 1:numLeftVecs
  if impedanceFlag
    rhsMatrix(:,k) = -0.5 * rhs{k};
  else
    rhsMatrix(:,k) = rhs{k};
  end
end

for kStepCnt = 1 : freqParam.numPnts
  if linearFlag
    fMat = sys{1} + freqParam.steps(kStepCnt) * sys{posFreq};
  else
    fMat = sys{1} + freqParam.steps(kStepCnt) * sys{posLinK} + freqParam.steps(kStepCnt)^2 * sys{posSquK};
  end
  if ~impedanceFlag && ~transparentFlag
    for excitationCnt = 1:numLeftVecs
      fMat = fMat + scaleIdent{excitationCnt}(kStepCnt) * ident{excitationCnt};
    end
  end
  P = eye(numLeftVecs);
  for k = 1 : numLeftVecs
    % frequency dependent normalization
    P(k,k) = sqrt(scaleRHS{k}(kStepCnt));
  end
  if cSpace
    for pntCnt = 1 : cSpace
      currentMat = fMat;
      for sysMatCnt = 1 : length(sys)
        if sysMatRedNames(sysMatCnt, 2 : end) == zeros(1, length(materialParams))
          % do nothing, only pure frequency dependence,
          % which is already considered
        else
          scale = 1;
          % frequency dependence
          scale = scale * (freqParam.steps(kStepCnt))^sysMatRedNames(sysMatCnt,1);
          % material dependence
          if length(sysMatRedNames(sysMatCnt,:)) > 1
            for pCnt = 2 : length(sysMatRedNames(sysMatCnt, :))
              scale = scale * stepSpace(pCnt-1,pntCnt)^sysMatRedNames(sysMatCnt,pCnt);
            end
          end
          % add matrices to build system matrix
          % in current point in parameter space
          currentMat = currentMat + scale * sys{sysMatCnt};
        end
      end
      [L U] = lu(currentMat);
      sol = U \ (L \ rhsMatrix);
      sMat{(kStepCnt - 1) * cSpace + pntCnt} = P * (leftVecs*sol) * P;
    end
  else  % no material dependence, only pure frequency dependence
    [L U] = lu(fMat);
    sol = U \ (L \ rhsMatrix);
    sMat{kStepCnt} = P * (leftVecs*sol) * P;
  end
end

if impedanceFlag
  % sMat is really an impedance matrix
  % compute scattering matrix from the impedance matrix
  for sMatCnt = 1 : length(sMat)
    sMat{sMatCnt} = (sMat{sMatCnt} - eye(numLeftVecs)) ...
      \ (sMat{sMatCnt} + eye(numLeftVecs));
  end
else
  % subtract excitation
  for k = 1 : length(sMat)
    [r c] = size(sMat{k});
    sMat{k} = sMat{k} - eye(r, c);
  end
end

toc


%% Save results
disp(' ');
disp('Saving results ...');
tic

fNameSpara = strcat(modelName,'S_f_',num2str(freqParam.fMin,'%14.14g'), '_', ...
  num2str(freqParam.fMax,'%14.14g'),'_',num2str(freqParam.numPnts,'%14.14g'));
for k = 1 : length(paramNames)
  fNameSpara = strcat(fNameSpara, '_', paramNames{k}, '_', ...
    num2str(materialParams(k).min,'%14.14g'), '_', ...
    num2str(materialParams(k).max,'%14.14g'), '_', ...
    num2str(materialParams(k).numPnts,'%14.14g'));
end

if saveMatlabFlag
  fNameSpara = [fNameSpara, '.mat'];
  save(fNameSpara, 'sMat', 'freqParam', 'materialParams', 'numLeftVecs', ...
    'paramSpace', 'paramNames');
else
  fNameSpara = strcat(fNameSpara, '.txt');
  saveSmatrix(sMat, freqParam, materialParams, fNameSpara, numLeftVecs, ...
    paramSpace, paramNames);
end

toc
