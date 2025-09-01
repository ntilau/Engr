close all;
clear all:

set(0,'DefaultFigureWindowStyle','docked')
  
order = 8;
fontsize = 12;
modelName = ...
  'C:\work\examples\coax\coax2\coax2_3e+009_10\';
modelName = ...
  'C:\work\examples\coax\coax2\coax2_3e+009_MU_RELATIVE_74_(1,0)_9\';
modelName = ...
  'C:\work\examples\coax\coax2\coax2_3e+009_MU_RELATIVE_74_(4,0)_10\';
modelName = ...
  'C:\work\examples\SMA_AccurateModRed\SMA_Accurate_3e+009_9\';
modelName = ...
  'S:\examples\patch_antenna\patch_antenna_modRed\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_6\';

impedanceFlag = false;
linFreqParamFlag = false;

buildRedModelInterpolation(modelName, order, linFreqParamFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag);

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
