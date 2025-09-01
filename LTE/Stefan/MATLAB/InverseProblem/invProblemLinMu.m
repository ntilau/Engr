% This script solves the inverse problem

% create measured data sed
% filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_pN\s_11_f_8e+009_1.7e+010_101_m_5-1i_5-1i_1.txt';
% [m, f, s, de] = readSparamMOR(filename);
% sRef = s;   % data have no noise yet

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
filename = 'G:\invProblems\wg_perm_sym_1.2e+010_10_10_pN\s_11_f_8e+009_1.4e+010_101_m_5-1i_5-1.003i_101_muLine.txt';
filename = 'C:\work\examples\wg_perm_sym\results\optMaterials\eps2.6_s_11_f_8e+009_1.4e+010_121_m_2.6-0.0065i_2.6-0.0065i_121_muLine.txt';
filename = 'C:\work\examples\wg_perm_sym\results\optMaterials\eps20_s_11_f_8e+009_1.4e+010_121_m_20-0.0025i_20-0.00385i_121_muLine.txt';
filename = 'C:\work\examples\wg_perm_sym\results\optMaterials\eps10.2_s_11_f_8e+009_1.4e+010_121_m_10.2-0.02244i_10.2-0.02703i_121_muLine.txt';
%filename = 'C:\work\examples\wg_perm_sym\results\optMaterials\LS_s_11_f_8e+009_1.4e+010_121_m_3.667-3.889i_3.333-3.333i_121_muLine.txt';
[m, f, sRef, de] = readSparamMOR_muLine(filename);
% % sRef = sRef+(randn(1,length(sRef))+j*randn(1,length(sRef)))*1e-5;
% fNameFreq = 'C:\work\examples\wg_perm_sym\results\optMaterials\LS_f.txt';
% VectorWriter(f,fNameFreq);
% fNameS = 'C:\work\examples\wg_perm_sym\results\optMaterials\LS_sPar.txt';
% VectorWriterComplex(sRef,fNameS);


pathName = 'C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\';

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

%%%%%%%%%%%%%%%%%%%%%%
% start optimization %
%%%%%%%%%%%%%%%%%%%%%%
parStart = [7,-3,7,-3]; % Make a starting guess at the solution
options = optimset('LargeScale','off');
% options = optimset(options, 'GradObj','on');
% options = optimset(options, 'Hessian','on');
% options = optimset(options, 'DerivativeCheck','on');
% options = optimset(options, 'TolX', 1e-12);
% options = optimset(options, 'TolFun', 1e-12);

% 0 <= real(mu) <= 15
% -10 <= imag(mu) <= 0
lowBndMu = [1, -10, 1, -10];
upBndMu = [25, 0, 25, 0];

% [muEst, fval] = fmincon(@costFunGradLinMu,parStart,[],[],[],[],lowBndMu,...
%   upBndMu,[],options)

[muEst, fval] = fmincon(@costFunLinMu,parStart,[],[],[],[],lowBndMu,...
  upBndMu,[],options)

numFktEval

toc