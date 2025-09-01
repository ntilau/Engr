% This script performs an accelerated model evaluation

pathName = 'C:\work\examples\coaxParamPEC\coaxParam_1e+008_0.999991_3\';
fNameIdent = strcat(pathName, 'identRed');
ident = readMatFull(fNameIdent);
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
  leftVecs(k,:) = vectorReader(fNameLeftVecs);
end

% read RHS
fNameRHS = strcat(pathName, 'redRhs');
rhs = vectorReader(fNameRHS);

% read "model.pvar"
fNameModPvar = strcat(pathName, 'model.pvar');
[fMin deltaF fMax muMin deltaMu muMax] = readModPvar(fNameModPvar);

muSteps = calcMuSteps(mu0, muMin, deltaMu, muMax);
kSquareSteps = calcK_SquareSteps(f0, fMin, deltaF, fMax);
scaleRHS = calcScaleRHS(f0, fMin, deltaF, fMax);
scaleIdent = calcScaleIdent(fMin, deltaF, fMax);

% solve model
numMuSteps = length(muSteps);
numK_Steps = length(kSquareSteps);
solArray = zeros(numLeftVecs, numMuSteps*numK_Steps);
for kStepCnt = 1:numK_Steps
  fMat = sys0 + kSquareSteps(kStepCnt)*sys2 + scaleIdent(kStepCnt)*ident;
  newRHS = (-2)*scaleRHS(kStepCnt)*rhs;
  for muStepCnt = 1:numMuSteps
    matrix = fMat + muSteps(muStepCnt)*sys1;
    sol = matrix\newRHS;
    for lVecCnt = 1:numLeftVecs
      solArray(lVecCnt,kStepCnt*numMuSteps+muStepCnt) = leftVecs(lVecCnt,:)*sol;
    end
  end
end

fNameSpara = strcat(pathName, 'sParaMatlab.txt');
printS(solArray, numK_Steps, numMuSteps, fMin, muMin, fNameSpara);



% fNameSpara = strcat(pathName, 'sParam.txt');
% [mus, freqs, s, de] = readS_ParamDet(fNameSpara);
% figure
% surf(unwrap(angle(s)));

