close all;
clear all:

set(0,'DefaultFigureWindowStyle','docked');

% modelName = ...
%   'C:\work\examples\coax\coaxParam\coaxParam_3e+008_MU_RELATIVE_3_(1,0)_3_ML\';
% sML = readMatFull(strcat(modelName, 'sysMatRed_1_0'));
% 
% modelName = ...
%   'C:\work\examples\coax\coaxParam\coaxParam_3e+008_MU_RELATIVE_3_(1,0)_4\';
% cMat = readMatFull(strcat(modelName, 'currentMat'));
% fNameRHS = strcat(modelName, 'rhsTest');
% rhs = vectorReader(fNameRHS);
% sol = cMat\rhs;
% solTest = vectorReader([modelName 'solTest']);

  
order = 20;
fontsize = 12;
modelName = ...
  'Z:\Diplomarbeit\Langer\wgIrisQuarterShort\wgIrisQuarterShort_1.2e+010_2\';

impedanceFlag = true;
linFreqParamFlag = true;

buildRedModelInterpolation(modelName, order, linFreqParamFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag);
% fNameSpara = [modelName 'S_f_1000000000_4500000000_1001_MU_RELATIVE_74_1_7_1.txt'];
% fNameSpara = [modelName 'S_f_1000000000_4500000000_10001_MU_RELATIVE_74_1_7_1.txt'];
% fNameSpara = 'C:\work\examples\coax\coax2\coax2_3e+009_MU_RELATIVE_74_(4,0)_8\S_f_1e+009_4.5e+009_101_MU_RELATIVE_74_(1,0)_(7,0)_101.txt';

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);

% plot results
figHandle = figure;
set(figHandle,'color','w');

% one parameter plot
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, abs(sVal));

% % two parameter plot
% pos = 1;
% nonOnePos = find(numParameterPnts(2:end) ~= 1) + 1;
% freqs = zeros(numParameterPnts(1),1);
% matVals = zeros(numParameterPnts(2),1);
% sVal = zeros(numParameterPnts(nonOnePos),numParameterPnts(1));
% for fCnt = 1:numParameterPnts(1)
%   for pCnt = 1:numParameterPnts(nonOnePos)
%     freqs(fCnt) = parameterVals(1,pos);
%     matVals(pCnt) = parameterVals(2,pos);
%     sVal(pCnt, fCnt) = sMatrices{pos}(1, 1);
%     pos = pos + 1;
%   end
% end
% surf(freqs*1e-9, matVals, abs(sVal));
% AZ = -1.4250e+002;
% EL = 40;
% view(AZ, EL);
% xlabel('Frequency (GHz)', 'FontSize', fontsize);
% ylabel('\mu_{r}', 'FontSize', fontsize);
% zlabel('|S_{11}|', 'FontSize', fontsize);
% axis([1 4.5 1 7 0 0.6]);
% %title('\epsilon_{r2} = 8', 'FontSize', fontsize);
% set(gca,'FontSize',fontsize);
% title('', 'FontSize', fontsize);
