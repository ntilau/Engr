function zMat = solveROM_Bandpass2FreqResp(l12, d1, d2, sysMatRedNames, freqParam, sys, ...
  scaleRHS, rhs, leftVecs)


l12n = 0.18;
l12 = l12 - l12n;
geoParams(1).name = 'l12';
geoParams(1).steps = l12;
geoParams(1).numPnts = length(l12);
geoParams(1).min = l12(1);
geoParams(1).max = l12(end);
d1n = 0.016;
d1 = d1 - d1n;
geoParams(2).name = 'd1';
geoParams(2).steps = d1;
geoParams(2).numPnts = length(d1);
geoParams(2).min = d1(1);
geoParams(2).max = d1(end);
d2n = 0.04;
d2 = d2 - d2n;
geoParams(3).name = 'd2';
geoParams(3).steps = d2;
geoParams(3).numPnts = length(d2);
geoParams(3).min = d2(1);
geoParams(3).max = d2(end);

pos = 1;
currentStepVals = zeros(length(geoParams), 1);
currentParamVals = zeros(length(geoParams), 1);
if isempty(geoParams)
  stepSpace = [];
else
  stepSpace = buildStepSpace(geoParams, pos, [], [], currentStepVals, currentParamVals);
end

[r c] = size(sysMatRedNames);
zMat = cell(1, freqParam.numPnts);
% [rSpace cSpace] = size(stepSpace);
numLeftVecs = size(leftVecs, 1);
row = zeros(1, c);
row(1, 1) = 1;

% find system matrix with frequency dependence
posFreq = findRowInMat(row, sysMatRedNames);
% tic;
freqMat = cell(2, 1);
freqMat{1} = sys{1};
freqMat{2} = sys{posFreq};
for sysMatCnt = 2:length(sys)
  if sysMatRedNames(sysMatCnt, 2:end) == zeros(1, length(geoParams))
    % do nothing, only pure frequency dependence,
    % which is already considered
  else
    scale = 1;
    % geometry dependence
    if length(sysMatRedNames(sysMatCnt,:)) > 1
      for pCnt = 2:length(sysMatRedNames(sysMatCnt,:))
        scale = scale * stepSpace(pCnt-1, 1)^sysMatRedNames(sysMatCnt, pCnt);
      end
    end
    % add matrices frequency system matrix
    if sysMatRedNames(sysMatCnt, 1) == 0
      freqMat{1} = freqMat{1} + scale * sys{sysMatCnt};
    elseif sysMatRedNames(sysMatCnt, 1) == 1
      freqMat{2} = freqMat{2} + scale * sys{sysMatCnt};
    else
      error('Frequency dependence higher than degree 1!');
    end
  end
end
% toc;
% tic;
% redRhsScaled = cell(numLeftVecs, 1);
% for kStepCnt = 1:freqParam.numPnts
%   currentMat = freqMat{1} + freqParam.steps(kStepCnt) * freqMat{2};
%   for k = 1:numLeftVecs
%     % rhs is only frequency dependent
%     redRhsScaled{k} = -0.5*scaleRHS{k}(kStepCnt)*rhs{k};
%   end
%   for rhsCnt = 1:length(redRhsScaled)
%     sol = currentMat\redRhsScaled{rhsCnt};    % solve equation system
%     zMat{(kStepCnt-1)*cSpace + 1}(:, rhsCnt) = leftVecs * sol;
%   end
% end
% toc;
% tic;
rhsMat = zeros(size(freqMat{1}, 1), numLeftVecs);
for colCnt = 1 : numLeftVecs
  rhsMat(:, colCnt) = rhs{colCnt};
end
tMatMinus = -freqMat{2};
[V D] = eig(freqMat{1}, tMatMinus);
normVec = diag(V' * tMatMinus * V);
V = V * sparse(1 : length(normVec), 1 : length(normVec), 1 ./ sqrt(normVec));
solMatUnscaled = V.' * rhsMat;
% toc;
% tic;
solMatScaled = zeros(size(solMatUnscaled));
for kStepCnt = 1:freqParam.numPnts
  % Attention: Here it is explicitely assumed, that both excitations show
  % the same frequency dependence!!!
  scaleVec = (diag(D) - freqParam.steps(kStepCnt)) .^ (-1);
  for colCnt = 1 : numLeftVecs
    solMatScaled(:, colCnt) = scaleVec .* solMatUnscaled(:, colCnt);
  end
  zMat{kStepCnt} = -0.5 * scaleRHS{1}(kStepCnt) * leftVecs * (V * solMatScaled);
end
% toc;
