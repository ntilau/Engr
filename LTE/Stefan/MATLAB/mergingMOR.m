
order = 5;
fontsize = 12;
modelName = ...
  'C:\work\examples\coax\coaxParam\coaxParam_2e+008_MU_RELATIVE_3_(1,0)_5\';
% modelName = 'C:\work\examples\coax\coaxParam\coaxParam_2e+008_5\';
% buildRedModelLinearParam(modelName, order)
modelEvaluationLinear(modelName, true);
fNameSpara = [modelName 'S_f_100000000_300000000_51_MU_RELATIVE_3_1_4_51.txt'];
% fNameSpara = [modelName 'S_f_100000000_300000000_51.txt'];
tic;
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
toc;
% plot results
figHandle = figure;
set(figHandle,'color','w');

% % one parameter plot
% sVal = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, abs(sVal));

% two parameter plot
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
AZ = -1.4250e+002;
EL = 40;
view(AZ, EL);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('\mu_{r}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
%title('\epsilon_{r2} = 8', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);
title('', 'FontSize', fontsize);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Polynomial algorithm %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

modelName = ...
  'C:\work\examples\coax\coaxParam\coaxParam_2e+008_MU_RELATIVE_3_(1,0)_6\';
% fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 'S_f_1e+008_3e+008_51_MU_RELATIVE_3_(1,0)_(4,0)_51.txt'];
tic;
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);
toc;
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
AZ = -1.4250e+002;
EL = 40;
view(AZ, EL);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('\mu_{r}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
%title('\epsilon_{r2} = 8', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);
title('', 'FontSize', fontsize);


