function zMat = solveROM_Bandpass2(l12, d1, d2, sysMatRedNames, freqParam, linearFlag, sys, ...
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
[rSpace cSpace] = size(stepSpace);
numLeftVecs = size(leftVecs, 1);
row = zeros(1, c);
row(1, 1) = 1;
if linearFlag
  % find system matrix with frequency dependence
  posFreq = findRowInMat(row, sysMatRedNames);
 else
  % find system matrix with linear k dependence
  posLinK = findRowInMat(row, sysMatRedNames);
  row(1, 1) = 2;
  % find system matrix with square k dependence
  posSquK = findRowInMat(row, sysMatRedNames);
end

redRhsScaled = cell(numLeftVecs, 1);
for kStepCnt = 1:freqParam.numPnts
  if linearFlag
    fMat = sys{1} + freqParam.steps(kStepCnt)*sys{posFreq};
  else
    fMat = sys{1} + freqParam.steps(kStepCnt)*sys{posLinK} + ...
      freqParam.steps(kStepCnt)^2*sys{posSquK};
  end
  % fMat = sys{1};
  for k = 1:numLeftVecs
    % rhs is only frequency dependent
    redRhsScaled{k} = -0.5*scaleRHS{k}(kStepCnt)*rhs{k};
  end
  if cSpace
    for pntCnt = 1:cSpace
      currentMat = fMat;
      for sysMatCnt = 2:length(sys)
        if sysMatRedNames(sysMatCnt, 2:end) == zeros(1, length(geoParams))
          % do nothing, only pure frequency dependence,
          % which is already considered
        else
          scale = 1;
          % frequency dependence
          scale = scale * (freqParam.steps(kStepCnt))^sysMatRedNames(sysMatCnt,1);
          % geometry dependence
          if length(sysMatRedNames(sysMatCnt,:)) > 1
            for pCnt = 2:length(sysMatRedNames(sysMatCnt,:))
              scale = scale * stepSpace(pCnt-1, pntCnt)^sysMatRedNames(sysMatCnt, pCnt);
            end
          end
          % add matrices to build system matrix
          % in current point in parameter space
          currentMat = currentMat + scale * sys{sysMatCnt};
        end
      end
      for rhsCnt = 1:length(redRhsScaled)
        sol = currentMat\redRhsScaled{rhsCnt};    % solve equation system
%         for lVecCnt = 1:numLeftVecs
%           sMat{(kStepCnt-1)*cSpace + pntCnt}(lVecCnt, rhsCnt) = ...
%             leftVecs(lVecCnt,:)*sol;
%         end
        zMat{(kStepCnt-1)*cSpace + pntCnt}(:, rhsCnt) = leftVecs * sol;
      end
    end
  end
end
