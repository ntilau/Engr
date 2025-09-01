clear all;

%% frequency sweep
modelName = cell(3, 1);
modelName{1} = ...
  'C:\work\examples\wgIrisQuarterShort\wgIrisQuarterShort_1e+010_10_dy_0.002_dz_-0.002';
modelName{2} = ...
  'C:\work\examples\wgIrisQuarterShort\wgIrisQuarterShort_1.2e+010_10_dy_0.002_dz_-0.002';
modelName{3} = ...
  'C:\work\examples\wgIrisQuarterShort\wgIrisQuarterShort_1.4e+010_10_dy_0.002_dz_-0.002';
dimSmat = 2;
numLeftVecs = 2;

sMat = cell(length(modelName), 1);
sMatK2 = cell(length(modelName), 1);
rhs = cell(length(modelName), 2);
lVec = cell(length(modelName), 2);

% load matrices
for freqCnt = 1:length(modelName)
  fNameMatrix = strcat(modelName{freqCnt}, '\system matrix');
  sMat{freqCnt} = MatrixMarketReader(fNameMatrix);
  fNameMatrixK2 = strcat(modelName{freqCnt}, '\k^2 matrix');
  sMatK2{freqCnt} = MatrixMarketReader(fNameMatrixK2);
  fNameRHS = strcat(modelName{freqCnt}, '\rhs0');
  rhs{freqCnt, 1} = j * vectorReader(fNameRHS);
  fNameRHS = strcat(modelName{freqCnt}, '\rhs1');
  rhs{freqCnt, 2} = j * vectorReader(fNameRHS);
  fNameLeftVec = strcat(modelName{freqCnt}, '\leftVec0');
  lVec{freqCnt, 1} = vectorReader(fNameLeftVec);
  fNameLeftVec = strcat(modelName{freqCnt}, '\leftVec1');
  lVec{freqCnt, 2} = vectorReader(fNameLeftVec);
end

freqParam.fExp = 10e9;
freqParam.fMin = 10e9;
freqParam.fMax = 14e9;
freqParam.numPnts = 3;
c0 = 299792.458e3;
k0 = 2 * pi * freqParam.fExp / c0;
freqParam.fCutOff = [7.49481137281049e9 7.49481137281049e9];
freqParam.steps = calcK_SquareRelSteps(freqParam.fExp, freqParam.fMin, ...
  freqParam.fMax, freqParam.numPnts);
scaleRHS = calcScaleRHS(freqParam.fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff);
rhsF = cell(numLeftVecs, 1);
leftVecsF = cell(numLeftVecs, 1);
for rhsCnt = 1:numLeftVecs
  rhsF{rhsCnt} = rhs{1, rhsCnt};
  leftVecsF{rhsCnt} = lVec{1, rhsCnt};
end

sMatFreq = sMat{1};
sMatFreqK2 = sMatK2{1};

[r c] = size(sMatFreq);

% solve
sF = cell(freqParam.numPnts, 1);
sO = cell(freqParam.numPnts, 1);
for kStepCnt = 1:freqParam.numPnts
  deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
  kNow = 2*pi*(freqParam.fMin + (kStepCnt - 1)*deltaF) / c0;

%   fMat2 = sMatFreq + (kNow^2 - k0^2) * sMatFreqK2;
%   display(fMat2((r - 3):r, (c - 3):c));

  fMat = sMatFreq - k0^2 * freqParam.steps(kStepCnt) * sMatFreqK2;

%   display(fMat((r - 3):r, (c - 3):c));
%   display(sMat{kStepCnt}((r - 3):r, (c - 3):c));
 
 % fMat = sys{1};
  redRhsScaled = cell(numLeftVecs, 1);
  for k = 1:numLeftVecs
    % rhs is only frequency dependent
    % redRhsScaled{k} = -0.5*scaleRHS{k}(kStepCnt)*rhsF{k};
    % different scaling of rhs because there's no reduction step
    redRhsScaled{k} = scaleRHS{k}(kStepCnt)*rhsF{k};
  end
  for rhsCnt = 1:length(rhsF)
    sol = fMat\redRhsScaled{rhsCnt};    % solve equation system
    solO = sMat{kStepCnt} \ rhs{kStepCnt, rhsCnt};
    for lVecCnt = 1:numLeftVecs
      sF{kStepCnt}(lVecCnt, rhsCnt) = leftVecsF{lVecCnt}.' * sol;
      sO{kStepCnt}(lVecCnt, rhsCnt) = lVec{kStepCnt, lVecCnt}.' * solO;
    end
  end
end
for sMatCnt = 1:length(sF)
  sF{sMatCnt} = inv(sF{sMatCnt} - eye(numLeftVecs))...
    * (sF{sMatCnt} + eye(numLeftVecs));
  sO{sMatCnt} = inv(sO{sMatCnt} - eye(numLeftVecs))...
    * (sO{sMatCnt} + eye(numLeftVecs));
end

% 2d plot
if freqParam.numPnts == 1
  deltaF = 0;
else
  deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
end
fOrig = zeros(kStepCnt, 1);
s11FOrig = zeros(kStepCnt, 1);
s11O = zeros(kStepCnt, 1);
for kStepCnt = 1:freqParam.numPnts
  fOrig(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
  s11FOrig(kStepCnt) = sF{kStepCnt}(1, 1);
  s11O(kStepCnt) = sO{kStepCnt}(1, 1);
end
figure;
plot(fOrig, abs(s11FOrig), 'b');
grid;
hold;
plot(fOrig, abs(s11O), 'rd');

% % build matrices with polynom
% sAct = [yDist zDist];
% % REVISIT: fast hack to get nonzero pattern
% sysMatNow = parMat{1};
% sysMatNow = sysMatNow - parMat{1};
% k2MatNow = parMatK2{1};
% k2MatNow = k2MatNow - parMatK2{1};
% for rowCnt = 1:size(finalPoly, 1)
%   pow = 1;
%   for parCnt = 1:size(finalPoly, 2)
%     pow = pow * sAct(parCnt)^finalPoly(rowCnt, parCnt);
%   end
%   sysMatNow = sysMatNow + parMat{rowCnt} * pow ;
%   k2MatNow = k2MatNow + parMatK2{rowCnt} * pow ;
% end
% sMatFreq = sysMatNow;
% sMatFreqK2 = k2MatNow;
% % solve
% sF = cell(freqParam.numPnts);
% for kStepCnt = 1:freqParam.numPnts
%   fMat = sMatFreq - k0^2 * freqParam.steps(kStepCnt) * sMatFreqK2;
%   % fMat = sys{1};
%   redRhsScaled = cell(numLeftVecs, 1);
%   for k = 1:numLeftVecs
%     % rhs is only frequency dependent
%     % redRhsScaled{k} = -0.5*scaleRHS{k}(kStepCnt)*rhsF{k};
%     % different scaling of rhs because there's no reduction step
%     redRhsScaled{k} = scaleRHS{k}(kStepCnt)*rhsF{k};
%   end
%   for rhsCnt = 1:length(rhsF)
%     sol = fMat\redRhsScaled{rhsCnt};    % solve equation system
%     for lVecCnt = 1:numLeftVecs
%       sF{kStepCnt}(lVecCnt, rhsCnt) = leftVecsF{lVecCnt}.' * sol;
%     end
%   end
% end
% for sMatCnt = 1:length(sF)
%   sF{sMatCnt} = inv(sF{sMatCnt} - eye(numLeftVecs))...
%     * (sF{sMatCnt} + eye(numLeftVecs));
% end
% % 2d plot
% if freqParam.numPnts == 1
%   deltaF = 0;
% else
%   deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
% end
% f = zeros(kStepCnt, 1);
% s11F = zeros(kStepCnt, 1);
% for kStepCnt = 1:freqParam.numPnts
%   f(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
%   s11F(kStepCnt) = sF{kStepCnt}(1, 1);
% end
% plot(f, abs(s11F));