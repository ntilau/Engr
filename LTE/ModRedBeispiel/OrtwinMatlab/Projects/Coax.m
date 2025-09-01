close all;
clear all;

linewidth = 2.5;
fontsize = 14;

modelName = ...
'C:\work\examples\coax\coax2Polynomial\coax2_3e+009_MU_RELATIVE_74_(4,0)_9\';
% fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 'S_f_1e+009_4.5e+009_51_MU_RELATIVE_74_(1,0)_(4,0)_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
sValO5 = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sValO5(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, abs(sValO5), 'b-', 'LineWidth', linewidth);

grid;
hold;


% response surface
modelName = ...
'C:\work\examples\coax\coax2Polynomial\coax2_3e+009_MU_RELATIVE_74_(4,0)_15\';
% fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 'S_f_1e+009_6e+009_51_MU_RELATIVE_74_(1,0)_(7,0)_51.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);
% plot results
figHandle = figure;
set(figHandle,'color','w');
pos = 1;
nonOnePos = find(numParameterPnts(2:end) ~= 1) + 1;
freqs = zeros(numParameterPnts(1),1);
matVals = zeros(numParameterPnts(2),1);
sVal = zeros(numParameterPnts(nonOnePos),numParameterPnts(1));
for fCnt = 1:numParameterPnts(1)
  for pCnt = 1:numParameterPnts(nonOnePos)
    freqs(fCnt) = parameterVals(1,pos);
    matVals(pCnt) = parameterVals(2,pos);
    sVal(pCnt, fCnt) = sMatrices{pos}(1, 1);
    pos = pos + 1;
  end
end
surf(freqs*1e-9, matVals, abs(sVal));


grid;
hold;

