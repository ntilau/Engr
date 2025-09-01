% This script performs the model evaluation with Z-Formulation

% close all;
% clear all;

tic

pathName = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_pN\';
% pathName = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_empty\';
fNameSys0 = strcat(pathName, 'sysMatReduced0');
sys0 = readMatFull(fNameSys0);
fNameSys1 = strcat(pathName, 'sysMatReduced1');
sys1 = readMatFull(fNameSys1);
fNameSys2 = strcat(pathName, 'sysMatReduced2');
sys2 = readMatFull(fNameSys2);

% read "modelParam.txt"
fNameModRedTxt = strcat(pathName, 'modelParam.txt');
[f0, mu0, numLeftVecs] = readModParaTxt(fNameModRedTxt);

% read leftVecs
for k = 1:numLeftVecs
  fNameLeftVecs = strcat(pathName, 'leftVecsRed', num2str(k-1));
  leftVecs(k,:) = vectorReader(fNameLeftVecs).';
end

% read RHS
fNameRHS = strcat(pathName, 'redRhs');
rhs = vectorReader(fNameRHS);

% read "model.pvar"
fNameModPvar = strcat(pathName, 'model.pvar');
[fMin deltaF fMax muMin deltaMu muMax fCutOff] = readModPvar(fNameModPvar);

muSteps = calcMuSteps(mu0, muMin, deltaMu, muMax);
kSquareSteps = calcK_SquareSteps(f0, fMin, deltaF, fMax);
scaleRHS = calcScaleRHS(f0, fMin, deltaF, fMax, fCutOff);

warning off all;
% solve model
numMuSteps = length(muSteps);
numK_Steps = length(kSquareSteps);
solArray = zeros(numLeftVecs, numMuSteps*numK_Steps);
for kStepCnt = 1:numK_Steps
  fMat = sys0 + kSquareSteps(kStepCnt)*sys2;
  newRHS = (-1)*scaleRHS(kStepCnt)*rhs;
  for muStepCnt = 1:numMuSteps
    matrix = fMat + muSteps(muStepCnt)*sys1;
    sol = matrix\newRHS;
    for lVecCnt = 1:numLeftVecs
      solArray(lVecCnt,(kStepCnt-1)*numMuSteps+muStepCnt) = ...
        leftVecs(lVecCnt,:)*sol;
    end
  end
end

% calculating the s-parameter by first buildung the Z matrix and computing
% S = (Z-I)^{-1}*(Z+I)
zMatrix = zeros(numLeftVecs, numLeftVecs);
for k = 1:numMuSteps*numK_Steps
  zMatrix(1,1) = solArray(1,k);
  zMatrix(2,1) = solArray(2,k);
  zMatrix(1,2) = solArray(2,k);
  zMatrix(2,2) = solArray(1,k);
  % sMatrix = inv(zMatrix-eye(numLeftVecs))*(zMatrix+eye(numLeftVecs));
  sMatrix = inv(zMatrix+eye(numLeftVecs))*(zMatrix-eye(numLeftVecs));
  % overwrite solArray
  solArray(1,k) = sMatrix(1,1);
  solArray(2,k) = sMatrix(2,1);
end

fNameSpara = [pathName, 's_11_m_f_', num2str(fMin','%11.4g'), '_', ...
  num2str(deltaF,'%11.4g'), '_', num2str(fMax,'%11.4g'), '_m_', num2str(muMin,'%11.4g'), ...
  '_', num2str(deltaMu,'%11.4g'), '_', num2str(muMax,'%11.4g'), '.txt'];
printS(solArray, numK_Steps, numMuSteps, fMin, deltaF, muMin, deltaMu, ...
  fNameSpara);

toc
