close all;
clear;

addpath(genpath('C:\Work\Matlab'));
set(0,'DefaultFigureWindowStyle','docked');
fontsize = 24;
linewidth = 2.5;
c0 = 299792.458e3;


%% Shift expansion point - multiple parameters
% modelName = 'C:\work\examples\permittivity_measurement\wg_perm_sym\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(5,0)_50_old\';
% sys0 = mmread([modelName 'system matrix.mm']);
% k2_mat = mmread([modelName 'k^2 matrix.mm']);
% mEps1 = mmread([modelName 'MU_RELATIVE_sample.mm']);
% f0 = 12e9;
% k0 = 2*pi*f0/c0;
% sys0 = sys0 + k0^2*k2_mat;
% MatrixMarketWriter(sys0, [modelName,'system matrix.mm']);
% MatrixMarketWriter(-k2_mat, [modelName,'k^2 matrix.mm']);


%% Order reduction - multiple parameters
order = 8;
modelName = 'C:\work\examples\permittivity_measurement\wg_perm_sym\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(5,0)_50_old\';
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
tmFlag              = true;

buildRedModelInterpolation(modelName, order, linFreqParamFlag, transposeFlag,...
  orthoFlag, transparentFlag, realProjMatFlag, removeDirichletFlag, ...
  pardisoFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag, newFileEndingFlag, ...
    saveMatlabFlag, transparentFlag, tmFlag);
% fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag, ...
%   newFileEndingFlag, saveMatlabFlag, pardisoFlag, tmFlag);
% fNameSpara = [modelName 'S_f_70000000_140000000_700001.txt'];

if saveMatlabFlag
  Results = load(fNameSpara);
  freqs = linspace(Results.freqParam.fMin, Results.freqParam.fMax, ...
    Results.freqParam.numPnts);
  matVals = Results.paramSpace;
  
  if (size(matVals,2) == 1 || isempty(matVals))
    % one paramter plot
    sVal  = zeros(Results.freqParam.numPnts,1);
    for k = 1:Results.freqParam.numPnts
      sVal(k)  = Results.sMat{k}(1,1);
    end
    figHandle = figure;
    set(figHandle, 'color', 'w');
    plot(freqs, abs(sVal), 'LineWidth', linewidth);
    hold on;
  else
    % two parameter plot
    pos = 1;
    sVal = zeros(length(matVals),length(freqs));
    for fCnt = 1:length(freqs)
      for pCnt = 1:length(matVals)
        sVal(pCnt,fCnt) = Results.sMat{pos}(1,1);
        pos = pos + 1;
      end
    end
    figHandle = figure;
    set(figHandle, 'color', 'w');
    surf(freqs*1e-9, matVals(1,:), abs(sVal), 'FaceColor', 'interp');
    hold on;
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


%% error plot: frequency
fNameSpara = 'C:\work\examples\permittivity_measurement\wg_perm_sym\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(5,0)_50_old\S_f_8000000000_17000000000_51_MU_RELATIVE_sample_5_5_1.mat';
Results = load(fNameSpara);
sVal11 = zeros(Results.freqParam.numPnts,1);
for k = 1:Results.freqParam.numPnts
  sVal11(k) = Results.sMat{k}(1,1);
end
fNameSpara = 'C:\work\examples\permittivity_measurement\wg_perm_sym\wg_perm_sym_1.2e+010_MU_RELATIVE_sample_(5,0)_50_old\S_f_8000000000_17000000000_51_MU_RELATIVE_sample_5_5_1_full.mat';
ResultsFull = load(fNameSpara);
sVal11Full = zeros(ResultsFull.freqParam.numPnts,1);
for k = 1:Results.freqParam.numPnts
  sVal11Full(k) = ResultsFull.sMat{k}(1,1);
end
figHandle = figure;
set(figHandle, 'color', 'w');
semilogy(freqs, abs(sVal11-sVal11Full), 'LineWidth', linewidth);



