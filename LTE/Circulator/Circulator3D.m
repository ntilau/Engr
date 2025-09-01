close all;
clear;

addpath(genpath('C:\Ortwin\Matlab'));
set(0,'DefaultFigureWindowStyle','docked');
fontsize = 24;
linewidth = 2.5;
c0 = 299792.458e3;


%% Shift expansion point - single parameter
% modelName = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorExtract\CirculatorExtract_1e+010_50_shifted\';
% modelName = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorTest\Circulator_1e+010_100\';
% modelName = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorTest\Circulator_1e+010_110\';
% modelName = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorTest\Circulator_1e+010_150_p2\';
% modelName = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorShort\CirculatorShort_1e+010_150_p2\';
% sys0 = mmread([modelName 'system matrix.mm']);
% k2_mat = mmread([modelName 'k^2 matrix.mm']);
% f0 = 10e9;
% k0 = 2*pi*f0/c0;
% sys0 = sys0 + k0^2*k2_mat;
% MatrixMarketWriter(sys0, [modelName 'system matrix.mm']);
% MatrixMarketWriter(-k2_mat, [modelName,'k^2 matrix.mm']);


%% Order reduction - multi-parameter
order = 4;
% modelName = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorTest\Circulator_1e+010_110\';
modelName = 'C:\Ortwin\CirculatorShort_1e+010_150_p2\';
impedanceFlag       = true;
linFreqParamFlag    = true;
newFileEndingFlag   = true;
orthoFlag           = true;
saveMatlabFlag      = true;
transposeFlag       = true;
transparentFlag     = false;
realProjMatFlag     = false;
removeDirichletFlag = true;
pardisoFlag         = false;

muRelExp    = 0.7;
kappaRelExp = 0.4;
% buildRedModInterpCirc(modelName, order, linFreqParamFlag, orthoFlag, ...
%   transparentFlag, realProjMatFlag, removeDirichletFlag, pardisoFlag, ...
%   muRelExp, kappaRelExp);
muRel    = 1;%linspace(0.5, 1, 3);
kappaRel = 0.37;
fNameSpara = solveRedModCirc(modelName, linFreqParamFlag, saveMatlabFlag, ...
  muRel, kappaRel);
% fNameSpara = solveUnredModCirc(modelName, impedanceFlag, linFreqParamFlag, ...
%     newFileEndingFlag, saveMatlabFlag, pardisoFlag, muRel, kappaRel);
% fNameSpara = [modelName 'S_f_8000000000_12000000000_41_MU_REL_1_KAPPA_REL_0.37_full.mat'];

if saveMatlabFlag
  Results = load(fNameSpara);
  freqs = linspace(Results.freqParam.fMin, Results.freqParam.fMax, ...
    Results.freqParam.numPnts);
  
  if length(Results.muRel) == 1 && length(Results.kappaRel) == 1
    % one paramter plot
    sVal11 = zeros(Results.freqParam.numPnts,1);
    sVal12 = zeros(Results.freqParam.numPnts,1);
    sVal13 = zeros(Results.freqParam.numPnts,1);
    for k = 1:Results.freqParam.numPnts
      sVal11(k) = Results.sMat{k}(1,1);
      sVal12(k) = Results.sMat{k}(1,2);
      sVal13(k) = Results.sMat{k}(1,3);
    end
    figHandle = figure;
    set(figHandle, 'color', 'w');
    plot(freqs, 20*log10(abs(sVal11)), 'LineWidth', linewidth);
    hold on;
    plot(freqs, 20*log10(abs(sVal12)), 'r', 'LineWidth', linewidth);
    plot(freqs, 20*log10(abs(sVal13)), 'g', 'LineWidth', linewidth);
  else
    % two parameter plot
    if length(Results.muRel) > 1
      sVal11 = zeros(length(muRel),Results.freqParam.numPnts);
      sVal12 = zeros(length(muRel),Results.freqParam.numPnts);
      sVal13 = zeros(length(muRel),Results.freqParam.numPnts);
      for fCnt = 1:length(freqs)
        for pCnt = 1:length(muRel)
          sVal11(pCnt,fCnt) = Results.sMat{fCnt,pCnt}(1,1);
          sVal12(pCnt,fCnt) = Results.sMat{fCnt,pCnt}(1,2);
          sVal13(pCnt,fCnt) = Results.sMat{fCnt,pCnt}(1,3);
        end
      end
      figHandle = figure;
      set(figHandle, 'color', 'w');
      surf(freqs * 1e-9, muRel, abs(sVal11), 'FaceColor', 'interp');
      figHandle = figure;
      set(figHandle, 'color', 'w');
      surf(freqs * 1e-9, muRel, abs(sVal12), 'FaceColor', 'interp');
      figHandle = figure;
      set(figHandle, 'color', 'w');
      surf(freqs * 1e-9, muRel, abs(sVal13), 'FaceColor', 'interp');
    end
  end
else
  [parameterNames, numParameterPnts, parameterVals, sMatrices] = ...
    loadSmatrix(fNameSpara); %#ok<UNRCH>
  sVal  = zeros(numParameterPnts(1),1);
  freqs = zeros(numParameterPnts(1),1);
  for k = 1:numParameterPnts(1)
    freqs(k) = parameterVals(1,k);
    sVal(k)  = sMatrices{k}(1,1);
  end
end


%% error plot
fNameSpara = 'C:\Ortwin\CirculatorShort_1e+010_150_p2\S_f_8000000000_12000000000_81_MU_REL_1_KAPPA_REL_0.37.mat';
Results = load(fNameSpara);
sVal11 = zeros(Results.freqParam.numPnts,1);
sVal12 = zeros(Results.freqParam.numPnts,1);
sVal13 = zeros(Results.freqParam.numPnts,1);
for k = 1:Results.freqParam.numPnts
  sVal11(k)  = Results.sMat{k}(1,1);
  sVal12(k)  = Results.sMat{k}(1,2);
  sVal13(k)  = Results.sMat{k}(1,3);
end
fNameSpara = 'C:\Ortwin\CirculatorShort_1e+010_150_p2\S_f_8000000000_12000000000_81_MU_REL_1_KAPPA_REL_0.37_full.mat';
ResultsFull = load(fNameSpara);
sVal11Full = zeros(ResultsFull.freqParam.numPnts,1);
sVal12Full = zeros(ResultsFull.freqParam.numPnts,1);
sVal13Full = zeros(ResultsFull.freqParam.numPnts,1);
for k = 1:Results.freqParam.numPnts
  sVal11Full(k) = ResultsFull.sMat{k}(1,1);
  sVal12Full(k) = ResultsFull.sMat{k}(1,2);
  sVal13Full(k) = ResultsFull.sMat{k}(1,3);
end
figHandle = figure;
set(figHandle, 'color', 'w');
semilogy(freqs, abs(sVal11-sVal11Full), 'LineWidth', linewidth);
hold on;
semilogy(freqs, abs(sVal12-sVal12Full), 'r', 'LineWidth', linewidth);
semilogy(freqs, abs(sVal13-sVal13Full), 'g', 'LineWidth', linewidth);

    

%% Order reduction - single parameter
% order = 23;
% % modelName = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorExtract\CirculatorExtract_1e+010_50_shifted\';
% modelName = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorTest\Circulator_1e+010_100\';
% impedanceFlag       = true;
% linFreqParamFlag    = true;
% newFileEndingFlag   = true;
% orthoFlag           = true;
% saveMatlabFlag      = true;
% transposeFlag       = true;
% transparentFlag     = false;
% realProjMatFlag     = false;
% removeDirichletFlag = true;
% pardisoFlag         = false;
% 
% buildRedModelInterpolation(modelName, order, linFreqParamFlag, transposeFlag,...
%   orthoFlag, transparentFlag, realProjMatFlag, removeDirichletFlag, ...
%   pardisoFlag);
% % buildRedModelInterpEfficientOld(modelName, order, linFreqParamFlag, ...
% %     transposeFlag, orthoFlag, transparentFlag, realProjMatFlag, ...
% %     removeDirichletFlag, pardisoFlag);
% fNameSpara = modelEvaluation(modelName, impedanceFlag, newFileEndingFlag, ...
%   saveMatlabFlag, transparentFlag);
% % fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag, ...
% %     newFileEndingFlag, saveMatlabFlag, pardisoFlag);
% % fNameSpara = [modelName 'S_f_70000000_140000000_700001.txt'];
% 
% if saveMatlabFlag
%   Results = load(fNameSpara);
%   freqs = linspace(Results.freqParam.fMin, Results.freqParam.fMax, ...
%     Results.freqParam.numPnts);
%   matVals = Results.paramSpace;
%   
%   if (length(matVals) == 1 || isempty(matVals))
%     % one paramter plot
%     sVal11  = zeros(Results.freqParam.numPnts,1);
%     sVal12  = zeros(Results.freqParam.numPnts,1);
%     sVal13  = zeros(Results.freqParam.numPnts,1);
%     for k = 1:Results.freqParam.numPnts
%       sVal11(k)  = Results.sMat{k}(1,1);
%       sVal12(k)  = Results.sMat{k}(1,2);
%       sVal13(k)  = Results.sMat{k}(1,3);
%     end
%     figHandle = figure;
%     set(figHandle, 'color', 'w');
%     plot(freqs, 20*log10(abs(sVal11)), 'LineWidth', linewidth);
%     hold on;
%     plot(freqs, 20*log10(abs(sVal12)), 'r', 'LineWidth', linewidth);
%     plot(freqs, 20*log10(abs(sVal13)), 'g', 'LineWidth', linewidth);
%   else
%     % two parameter plot
%     pos = 1;
%     sVal = zeros(length(matVals),length(freqs));
%     for fCnt = 1:length(freqs)
%       for pCnt = 1:length(matVals)
%         sVal(pCnt,fCnt) = Results.sMat{pos}(1,1);
%         pos = pos + 1;
%       end
%     end
%     figHandle = figure;
%     set(figHandle, 'color', 'w');
%     surf(freqs * 1e-9, matVals, abs(sVal), 'FaceColor', 'interp');
%     hold on;
%   end
% else
%   [parameterNames, numParameterPnts, parameterVals, sMatrices] = ...
%     loadSmatrix(fNameSpara); %#ok<UNRCH>
%   sVal  = zeros(numParameterPnts(1),1);
%   freqs = zeros(numParameterPnts(1),1);
%   for k = 1:numParameterPnts(1)
%     freqs(k) = parameterVals(1,k);
%     sVal(k)  = sMatrices{k}(1,1);
%   end
% end


%% Empty circulator test
% % fNameSpara = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorExtract\CirculatorExtract_1e+010_70\S_f_8e+009_1.2e+010_501.txt';
% fNameSpara = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorTest\Circulator_1e+010_60\S_f_8e+009_1.2e+010_401.txt';
% [parameterNames, numParameterPnts, parameterVals, sMatrices] = ...
%   loadSmatrix(fNameSpara);
% sVal  = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sVal(k)  = sMatrices{k}(1,1);
% end
% figure;
% plot(freqs, 20*log10(abs(sVal)));


%% Empty WG
% fNameSpara = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\EmptyWG_Test\EmptyWG_Test_1e+010_50\S_f_8e+009_1.2e+010_401.txt';
% [parameterNames, numParameterPnts, parameterVals, sMatrices] = ...
%   loadSmatrix(fNameSpara);
% sVal  = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sVal(k)  = sMatrices{k}(1,2);
% end
% figure;
% plot(freqs, 20*log10(abs(sVal)));


%% Compare matrices
% dirName = 'C:\work\examples\Circulator\HPlane_09_07_24\HPlane\Projects\CirculatorTest\';
% sys0scal = mmread([dirName 'sysMat_0_scalar_cmplx.mm']);
% sys0tens = mmread([dirName 'sysMat_0_tensor_cmplx.mm']);
% display(nnz(sys0scal-sys0tens));


