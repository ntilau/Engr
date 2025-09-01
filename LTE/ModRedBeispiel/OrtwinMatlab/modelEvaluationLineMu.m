% This script performs the model evaluation

tic

pathName = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\';
% pathName = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\';

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
  leftVecs(k,:) = vectorReader(fNameLeftVecs).';
end

% read RHS
fNameRHS = strcat(pathName, 'redRhs');
rhs = vectorReader(fNameRHS);

% read "modelNew.pvar"
fNameModPvar = strcat(pathName, 'model.pvar');
[fMin, fMax, numF_Pnts, muMin, muMax, numMuPnts, fCutOff] = ...
  readModPvarNew(fNameModPvar);

if numF_Pnts ~= numMuPnts
  error('Number of frequency and material points must be the same!');
end

muSteps = calcMuStepsNew(mu0, muMin, muMax, numMuPnts);
kSquareSteps = calcK_SquareStepsNew(f0, fMin, fMax, numF_Pnts);
scaleRHS = calcScaleRHSnew(f0, fMin, fMax, numF_Pnts, fCutOff);
scaleIdent = calcScaleIdentNew(f0, fMin, fMax, numF_Pnts, fCutOff);

% warning off all;
warning off;
% solve model
solArray = zeros(numLeftVecs, numMuPnts);
for stepCnt = 1:numF_Pnts
  fMat = sys0 + kSquareSteps(stepCnt)*sys2 + scaleIdent(stepCnt)*ident;
  newRHS = (-2)*scaleRHS(stepCnt)*rhs;
  matrix = fMat + muSteps(stepCnt)*sys1;
  sol = matrix\newRHS;
  for lVecCnt = 1:numLeftVecs
    solArray(lVecCnt, stepCnt) = leftVecs(lVecCnt,:)*sol;
  end
end

% subtract excitation
solArray(1,1:end) = solArray(1,1:end)-1;

%fNameSpara = strcat(pathName, 's_11_m_f_' .txt');
fNameSpara = [pathName, 's_11_f_', num2str(fMin','%11.4g'), '_', ...
  num2str(fMax,'%11.4g'), '_', num2str(numF_Pnts,'%4i'), '_m_', num2str(muMin,'%11.4g'), ...
  '_', num2str(muMax,'%11.4g'), '_', num2str(numMuPnts,'%4i'), '_muLine.txt'];
printSnewLineMu(solArray, fMin, fMax, numF_Pnts, muMin, muMax, numMuPnts, ...
  fNameSpara);

[mus, freqs, s, s12] = readSparamMOR_muLine(fNameSpara);

toc
