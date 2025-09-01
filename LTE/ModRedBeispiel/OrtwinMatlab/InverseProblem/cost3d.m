% This script computes the cost function as a function of 
% real(mu) and imag(mu)

close all;
clear all;

%%%%%%%%%%%%%%%%%%%%
% read global data %
%%%%%%%%%%%%%%%%%%%%
tic
% read measured data sed
global sRef identMat sys0 sys1 sys2 f0 mu0 rhs kSquareSteps scaleRHS...
    scaleIdent fMin fMax numF_Pnts numMuPnts leftVecs f numFktEval;

numFktEval = 0;
funValLast = -1;
muLast = [0, 0];

filename = 'C:\home\Ortwin\InvProblem\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.7e+010_101_m_5-5e-005i_5-5e-005i_1.txt';
[m, f, sRef, de] = readSparamMOR(filename);

pathName = 'C:\home\Ortwin\InvProblem\wg_perm_sym_1.2e+010_10_10_pN\';

fNameIdent = strcat(pathName, 'identRed');
identMat = readMatFull(fNameIdent);
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

% computation of derivatives of s-parameter from muReal and muImag
global derSolVec;
derSolVec = leftVecs(1,:)*(sys0\(sys1*(sys0\rhs)));

% read "modelNew.pvar"
fNameModPvar = strcat(pathName, 'model.pvar');
[fMin, fMax, numF_Pnts, muMin, muMax, numMuPnts, fCutOff] = readModPvarNew(fNameModPvar);
fMin = f(1);
fMax = f(end);
numF_Pnts = length(f);
numMuPnts = 1;

kSquareSteps = calcK_SquareStepsNew(f0, fMin, fMax, numF_Pnts);
scaleRHS = calcScaleRHSnew(f0, fMin, fMax, numF_Pnts, fCutOff);
scaleIdent = calcScaleIdentNew(f0, fMin, fMax, numF_Pnts, fCutOff);

lowBndMu = [1, -5];
upBndMu = [15, 0];

numMuRealPnts = 101;
numMuImagPnts = 101;
deltaMuReal = (upBndMu(1)-lowBndMu(1))/(numMuRealPnts-1);
deltaMuImag = (upBndMu(2)-lowBndMu(2))/(numMuImagPnts-1);
cost3d = zeros(numMuRealPnts, numMuImagPnts);
for muRealCnt = 1:numMuRealPnts
  for muImagCnt = 1:numMuImagPnts
    cost3d(muRealCnt, muImagCnt) = costFun([lowBndMu(1)+(muRealCnt-1)*...
      deltaMuReal, lowBndMu(2)+(muImagCnt-1)*deltaMuImag]);
  end
end

fNameCost3d = 'cost3d_5-i.txt';
writeCost3d(lowBndMu, upBndMu, numMuRealPnts, numMuImagPnts, cost3d,...
  fNameCost3d);

[muRealTest, muImagTest, cost3dTest] = readCost3d(fNameCost3d);
surf(muRealTest, muImagTest, cost3dTest');
axis([muRealTest(1), muRealTest(end), muImagTest(1), muImagTest(end), 0, 10]);

figure;
surf(muRealTest, muImagTest, log(cost3dTest)');

toc