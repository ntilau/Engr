
modelName = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_10_pN\';
impedanceFlag = true;
%% load model

tic
disp('Loading model...');

% read names of the reduced system matrices, indicating their polynomial
% parameter dependence
fName = strcat(modelName, 'sysMatRedNames');
% read reduced system matrices
for k = 1:3
  fName = strcat(modelName, strcat('sysMatReduced', ...
    num2str(k-1)));
  sys{k} = readMatFull(fName);
end
% ident = readMatFull(strcat(modelName, 'identRed'));

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
% [fExp, paramNames, paramValInExp, numLeftVecs, abcFlag] = ...
%   readModParaTxtNew(fNameModRedTxt);
fExp = 3e9;
numLeftVecs = 2;
abcFlag = false;
paramNames = 'MU_RELATIVE';
paramValInExp = 4.0;

for k = 1:numLeftVecs
  % read leftVecs
  fNameLeftVecs = strcat(modelName, 'leftVecsRed', num2str(k-1));
  leftVecs(k,:) = vectorReader(fNameLeftVecs).';
  % read RHSs
  fNameRHS = strcat(modelName, 'redRhs', num2str(k-1));
  rhs{k} = vectorReader(fNameRHS);
  % read identRed
  fNameIdent = strcat(modelName, 'identRed', num2str(k-1));
  ident{k} = readMatFull(fNameIdent);
end

% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);

% compute parameter steps of material parameters
for k = 1:length(materialParams)
  if strcmp(materialParams(k).name, 'MU_RELATIVE')
    materialParams(k).steps = calcMuStepsNew(paramValInExp(k), ...
      materialParams(k).min, materialParams(k).max, ...
      materialParams(k).numPnts);
  elseif strfind(paramNames{k}, 'EPSILON_RELATIVE')
    error('EPSILON_RELATIVE does not lead to linear parameter dependence!');
  else
    error('Unknown material parameter!');
  end
end

% compute parameter steps of frequency parameter
freqParam.steps = calcK_SquareStepsNew(fExp, freqParam.fMin, ...
  freqParam.fMax, freqParam.numPnts);
scaleRHS = calcScaleRHSnew(fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff);
scaleIdent = calcScaleIdentNew(fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff);

c0 = 299792.458e3;
k0 = 2.0*pi*fExp/c0;

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
    currentParamVals, currentParamVals);
end

disp('Model loaded');
toc

%% solve model

disp('Solving model ...');
tic

[rSpace cSpace] = size(stepSpace);
row = zeros(1, c);
row(1, 1) = 1;
% find system matrix with k dependence
posFreq = findRowInMat(row, sysMatRedNames);  

for kStepCnt = 1:freqParam.numPnts
  if impedanceFlag
    fMat = sys{1} + freqParam.steps(kStepCnt)*sys{posFreq};
  else
    fMat = sys{1} + freqParam.steps(kStepCnt)*sys{posFreq};
    for excitationCnt = 1:numLeftVecs
      fMat = fMat + scaleIdent{excitationCnt}(kStepCnt) ...
        * ident{excitationCnt};
    end
  end
  for k = 1:numLeftVecs
    % rhs is only frequency dependent
    if impedanceFlag
      redRhsScaled{k} = -0.5*scaleRHS{k}(kStepCnt)*rhs{k};
    else
      redRhsScaled{k} = scaleRHS{k}(kStepCnt)*rhs{k};
    end
  end
  if cSpace
    for pntCnt = 1:cSpace
      currentMat = fMat;
      for sysMatCnt = 1:length(sys)
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
          currentMat = currentMat + scale * sys{sysMatCnt};
        end
      end
      for rhsCnt = 1:length(redRhsScaled)
        sol = currentMat\redRhsScaled{rhsCnt};    % solve equation system
        for lVecCnt = 1:numLeftVecs
          sMat{(kStepCnt-1)*cSpace + pntCnt}(lVecCnt, rhsCnt) = ...
            leftVecs(lVecCnt,:)*sol;
        end
      end
    end
  else  % no material dependence, only pure frequency dependence
    for rhsCnt = 1:length(redRhsScaled)
      sol = fMat\redRhsScaled{rhsCnt};      % solve equation system
      for lVecCnt = 1:numLeftVecs
        sMat{kStepCnt}(lVecCnt, rhsCnt) = leftVecs(lVecCnt,:)*sol;
      end
    end
  end
end

if impedanceFlag
  % sMat is really an impedance matrix
  % compute scattering matrix from the impedance matrix
  for sMatCnt = 1:length(sMat)
    sMat{sMatCnt} = inv(sMat{sMatCnt} + eye(numLeftVecs))...
      * (sMat{sMatCnt} - eye(numLeftVecs));
  end
else
  % subtract excitation
  for k = 1:length(sMat)
    [r c] = size(sMat{k});
    sMat{k} = sMat{k} - eye(r, c);
  end
end

disp('Model solved');
toc

%% Save results

disp('Saving results ...');
tic

fNameSpara = strcat(modelName, 'S_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
  num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));
for k = 1:length(paramNames)
  fNameSpara = strcat(fNameSpara, '_', paramNames{k}, '_', num2str(materialParams(k).min,'%14.14g'), '_', ...
    num2str(materialParams(k).max,'%14.14g'), '_', num2str(materialParams(k).numPnts,'%14.14g'));
end
fNameSpara = strcat(fNameSpara, '.txt');

%printSmatrix(solArray, freqParam, materialParams, fNameSpara, numLeftVecs, paramSpace, paramNames);
saveSmatrix(sMat, freqParam, materialParams, fNameSpara, numLeftVecs, paramSpace, paramNames);
 
disp('Results saved');
toc
