function fNameSpara = modelEvaluationFast(modelName, impedanceFlag, order, newFileEndingFlag)

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
  fNameLeftVecs = strcat(modelName, 'leftVecsRed', num2str(k-1));
  if newFileEndingFlag
    fNameLeftVecs = strcat(fNameLeftVecs, '.fvec');
  end
  leftVecs(k,:) = vectorReader(fNameLeftVecs).';
  % read RHSs
  fNameRHS = strcat(modelName, 'redRhs', num2str(k-1));
  if newFileEndingFlag
    fNameRHS = strcat(fNameRHS, '.fvec');
  end
  rhs{k} = vectorReader(fNameRHS);
  % read identRed
  fNameIdent = strcat(modelName, 'identRed', num2str(k-1));
  if newFileEndingFlag
    fNameIdent = strcat(fNameIdent, '.fmat');
  end
  ident{k} = readMatFull(fNameIdent);
end

% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);

% compute parameter steps of material parameters
for k = 1:length(materialParams)
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
scaleRHS = calcScaleRHS(fExp, freqParam.fMin, freqParam.fMax, freqParam.numPnts, freqParam.fCutOff);

pos = 1;
currentStepVals = zeros(length(materialParams), 1);
currentParamVals = zeros(length(materialParams), 1);
if isempty(materialParams)
  stepSpace = [];
  paramSpace = [];
else
  [stepSpace paramSpace] = buildStepSpace(materialParams, pos, [], [], currentStepVals, currentParamVals);
end

% load patchTest;

toc


%% solve model
disp(' ');
disp('Solving model ...');
tic

profile on;

[rSpace cSpace] = size(stepSpace);
redRhsScaled = zeros((order + 1) * numLeftVecs, numLeftVecs);
if isempty(materialParams)
  sMat = cell(freqParam.numPnts, 1);
else
  sMat = cell(freqParam.numPnts * cSpace, 1);
end

% factorize system matrix in expansion point
[fact.L fact.U] = lu(sys{1});
sol = cell(numLeftVecs, 1);
for k = 1 : numLeftVecs
  sol{k} = fact.U \ (fact.L \ rhs{k});
end

for kStepCnt = 1 : freqParam.numPnts
  if cSpace
    for pntCnt = 1 : cSpace
      Q = zeros(size(sys{1}, 1), (order + 1) * numLeftVecs);
      paramPnt = [freqParam.steps(kStepCnt); stepSpace(:, pntCnt)];
      oneParamModel = contractROM(sys, sysMatRedNames, paramPnt);
      for rhsCnt = 1 : numLeftVecs
        Q(:, (1 : (order + 1)) + (rhsCnt - 1) * numLeftVecs) = ...
          wcaweImprvd(fact, oneParamModel, sol{rhsCnt}, order, [], []);
      end
      [U S V] = svd(Q, 0);
      Q = U;
      currentMat = zeros(size(sys{1}, 1));
      for matCnt = 1 : length(oneParamModel)
        currentMat = currentMat + oneParamModel{matCnt};
      end
      % project currentMat
      currentMatRed = Q.' * currentMat * Q;
%       % project oneParamModel
%       oneParamModelRed = cell(length(oneParamModel), 1);
%       for matCnt = 1 : length(oneParamModel)
%         oneParamModelRed{matCnt} = Q.' * (oneParamModel{matCnt} * Q);
%       end
      % project rhs and leftVecs
      for vecCnt = 1 : numLeftVecs
        % rhs is only frequency dependent
        if impedanceFlag
          redRhsScaled(:, vecCnt) = -0.5 * scaleRHS{vecCnt}(kStepCnt) * (Q.' * rhs{vecCnt});
        else
          redRhsScaled(:, vecCnt) = scaleRHS{vecCnt}(kStepCnt) * (Q.' * rhs{vecCnt});
        end
      end
      leftVecsRed = leftVecs * Q;
      % construct system matrix in parameter point
%       currentMat = zeros((order + 1) * numLeftVecs);
% %       currentMat = zeros(size(sys{1}, 1));
%       for matCnt = 1 : length(oneParamModelRed)
%         currentMat = currentMat + oneParamModelRed{matCnt};
%       end
      [L U] = lu(currentMatRed);
      currentSol = U \ (L \ redRhsScaled);
      sMat{(kStepCnt - 1) * cSpace + pntCnt} = leftVecsRed * currentSol;
    end
  else
    % no material dependence, only pure frequency dependence
    Q = zeros(size(sys{1}, 1), (order + 1) * numLeftVecs);
    paramPnt = [freqParam.steps(kStepCnt)];
    oneParamModel = contractROM(sys, sysMatRedNames, paramPnt);
    for rhsCnt = 1 : numLeftVecs
      %         Q(:, (1 : order) + (rhsCnt - 1) * numLeftVecs) = wcawe(fact, oneParamModel, sol{rhsCnt}, order);
      Q(:, (1 : (order + 1)) + (rhsCnt - 1) * numLeftVecs) = ...
        wcaweImprvd(fact, oneParamModel, sol{rhsCnt}, order, [], []);
    end
    [U S V] = svd(Q, 0);
    Q = U;
    % project oneParamModel
    oneParamModelRed = cell(length(oneParamModel), 1);
    for matCnt = 1 : length(oneParamModel)
      oneParamModelRed{matCnt} = Q.' * (oneParamModel{matCnt} * Q);
    end
    % project rhs and leftVecs
    for vecCnt = 1 : numLeftVecs
      % rhs is only frequency dependent
      if impedanceFlag
        redRhsScaled(:, vecCnt) = -0.5 * scaleRHS{vecCnt}(kStepCnt) * (Q.' * rhs{vecCnt});
      else
        redRhsScaled(:, vecCnt) = scaleRHS{vecCnt}(kStepCnt) * (Q.' * rhs{vecCnt});
      end
    end
    leftVecsRed = leftVecs * Q;
    % construct system matrix in parameter point
    currentMat = zeros((order + 1) * numLeftVecs);
    for matCnt = 1 : length(oneParamModelRed)
      currentMat = currentMat + oneParamModelRed{matCnt};
    end
    [L U] = lu(currentMat);
    currentSol = U \ (L \ redRhsScaled);
    sMat{kStepCnt} = leftVecsRed * currentSol;
  end
end

if impedanceFlag
  % sMat is really an impedance matrix
  % compute scattering matrix from the impedance matrix
  for sMatCnt = 1 : length(sMat)
    sMat{sMatCnt} = inv(sMat{sMatCnt} - eye(numLeftVecs)) * (sMat{sMatCnt} + eye(numLeftVecs));
  end
else
  % subtract excitation
  for k = 1 : length(sMat)
    [r c] = size(sMat{k});
    sMat{k} = sMat{k} - eye(r, c);
  end
end

profile viewer;
 
toc

%% Save results
disp(' ');
disp('Saving results ...');
tic

fNameSpara = strcat(modelName, 'S_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
  num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));
for k = 1 : length(paramNames)
  fNameSpara = strcat(fNameSpara, '_', paramNames{k}, '_', num2str(materialParams(k).min,'%14.14g'), '_', ...
    num2str(materialParams(k).max,'%14.14g'), '_', num2str(materialParams(k).numPnts,'%14.14g'));
end
fNameSpara = strcat(fNameSpara, '.txt');

saveSmatrix(sMat, freqParam, materialParams, fNameSpara, numLeftVecs, paramSpace, paramNames);

toc
