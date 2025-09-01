function fNameSpara=evaluateReducedModel(modelName)

constants;



%% load model

tic
disp(' ');
disp('Loading model...');

% read names of the reduced system matrices, indicating their polynomial
% parameter dependence
fName = strcat(modelName, 'sysMatMultiNames');
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
  fName = strcat(modelName, strcat('sysMatMulti_', ...
    num2str(sysMatRedNames(k,1))));
  for m = 2:c
    fName = strcat(fName, '_', num2str(sysMatRedNames(k,m)));
  end
  sys{k} = readMatFull(fName);
end

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[fExp, paramNames, paramValInExp, numLeftVecs, abcFlag] = ...
  readModParaTxt(fNameModRedTxt);

for k = 1:numLeftVecs
  % read leftVecs
  fNameLeftVecs = strcat(modelName, 'leftVecsMulti', num2str(k-1));
  leftVecs(k,:) = vectorReader(fNameLeftVecs).';
  % read RHSs
  fNameRHS = strcat(modelName, 'MultiRhs', num2str(k-1));
  rhs(:,k) = vectorReader(fNameRHS);
  % read identRed
  % fNameIdent = strcat(modelName, 'identRed', num2str(k-1));
  % ident{k} = readMatFull(fNameIdent);
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


%% Model Evaluation

disp(' ');
disp('Evaluate model...');
tic

S_red = sys{1};
T_red = sys{2};
abc_red = sys{3};


%Solve Reduced System
fs = linspace(freqParam.fMin, freqParam.fMax, freqParam.numPnts);
ks = 2*pi*fs/c0;

I = diag(ones(1,numLeftVecs));

for n = 1:length(fs),
    for k = 1:numLeftVecs,
       scale = scaleRhs(fs(n), fExp, freqParam.fCutOff, k);
       rhsScaled =  i*scale * rhs(:,k); 
       sol_red1{n,k} = (S_red + ks(n)*abc_red - ks(n)^2*T_red) \ rhsScaled ;
    end
    
    for kl=1:numLeftVecs,
       for kr=1:numLeftVecs,
          Z(kl, kr) = leftVecs(kl,:)*sol_red1{n,kr} ;
       end
    end
    
    sMat{n} = inv(-I + Z)*(Z + I);
end

toc
%% Save results
disp(' ');
disp('Saving results ...');
tic

fNameSpara = strcat(modelName, 'sMulti_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
  num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));

fNameSpara = strcat(fNameSpara, '.txt');

saveSmatrix(sMat, freqParam, materialParams, fNameSpara, numLeftVecs, paramSpace, paramNames);
 
toc
