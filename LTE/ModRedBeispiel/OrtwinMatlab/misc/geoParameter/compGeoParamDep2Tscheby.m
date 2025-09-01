close all;
clear all;

tic;

set(0,'DefaultFigureWindowStyle','docked');

%% reconstruct parameter dependence

geoModelName = ...
  'C:\work\examples\lenseQuarterShort\lenseQuarterShort_1e+010_geoModel\';
% geoModelName = ...
%   'Y:\examples\lenseQuarterShort\lenseQuarterShort_1e+010_geoModel\';

% parameter intervals
s1Start = -0.004;
s1End   =  0.004;
s2Start = -0.002;
s2End   =  0.002;
s1NumPnts = 5;
s2NumPnts = 5;
% sIntPnts{1} = -0.000:0.001:0.004;
% sIntPnts{2} = -0.002:0.0005:0.000;

% compute interpolation points
% take arbitrary interval into accout, not only [-1,1]
bma1 = 0.5 * (s1End - s1Start);
bpa1 = 0.5 * (s1End + s1Start);
bma2 = 0.5 * (s2End - s2Start);
bpa2 = 0.5 * (s2End + s2Start);

% evalute the function at the zeros of the n-th Tschebyscheff polynomial
y1 = cos(pi * ((1:s1NumPnts) - 0.5) / s1NumPnts);
sIntPnts{1} = y1 * bma1 + bpa1;
y2 = cos(pi * ((1:s2NumPnts) - 0.5) / s2NumPnts);
sIntPnts{2} = y2 * bma2 + bpa2;
%f = func(y * bma + bpa);

% modelNameOriginalBase = ...
%   'C:\work\examples\lenseQuarterShort\fine_h0_p2\lenseQuarterShort_1e+010_5_dy_';
modelNameOriginalBase = ...
  'C:\work\examples\lenseQuarterShort\lenseQuarterShort_1e+010_5_dy_';
% modelNameOriginalBase = ...
%   'Y:\examples\lenseQuarterShort\fine_h1_p2\lenseQuarterShort_1e+010_5_dy_';
sysMatIntp = cell(s1NumPnts, s2NumPnts);
k2MatIntp  = cell(s1NumPnts, s2NumPnts);

for s1Cnt = 1:length(sIntPnts{1})
  for s2Cnt = 1:length(sIntPnts{2})
    % call mesh
    systemString = ['cd C:\work\examples\lenseQuarterShort\ & '...
      'MeshDistorter lenseQuarterShort 10000000000 5 ' ...
      num2str(sIntPnts{1}(s1Cnt)) ' ' num2str(sIntPnts{2}(s2Cnt)) ...
      ' -dx \w'];
    system(systemString);
    % name of new created directory
    dirName = strcat(modelNameOriginalBase, ...
      num2str(sIntPnts{1}(s1Cnt)), '_dz_', ...
      num2str(sIntPnts{2}(s2Cnt)), '\');
    fNameSysMat = strcat(dirName, '\system matrix');
    sysMatIntp{s1Cnt, s2Cnt} = MatrixMarketReader(fNameSysMat);
    fNameK2Mat = strcat(dirName, '\k^2 matrix');
    k2MatIntp{s1Cnt, s2Cnt} = MatrixMarketReader(fNameK2Mat);
    systemString2 = ['rmdir ' dirName ' /s /q'];
    % system(systemString2); 
  end
end

% build Vandermonde matrices
Vinv = cell(length(sIntPnts), 1);
for dimCnt = 1:length(sIntPnts)
  V = zeros(length(sIntPnts{dimCnt}));
  for k = 1:length(sIntPnts{dimCnt})
    for m = 1:length(sIntPnts{dimCnt})
      V(k, m) = sIntPnts{dimCnt}(k)^(m - 1);
    end
  end
  Vinv{dimCnt} = inv(V);
end

% give every matrix the same nonzero pattern
nzStructSysMat = spones(sysMatIntp{1, 1});
nzStructSysMatK2 = spones(k2MatIntp{1, 1});
for s1Cnt = 1:length(sIntPnts{1})
  for s2Cnt = 1:length(sIntPnts{2})
    nzStructSysMat = nzStructSysMat + spones(sysMatIntp{s1Cnt, s2Cnt});
    nzStructSysMatK2 = nzStructSysMatK2 + spones(k2MatIntp{s1Cnt, s2Cnt});
  end
end
for s1Cnt = 1:length(sIntPnts{1})
  for s2Cnt = 1:length(sIntPnts{2})
    sysMatIntp{s1Cnt, s2Cnt} = sysMatIntp{s1Cnt, s2Cnt} + nzStructSysMat;
%     sysMatIntp{s1Cnt, s2Cnt} = sysMatIntp{s1Cnt, s2Cnt} - nzStructSysMat;
    k2MatIntp{s1Cnt, s2Cnt} = k2MatIntp{s1Cnt, s2Cnt} + nzStructSysMatK2;
%     k2MatIntp{s1Cnt, s2Cnt} = k2MatIntp{s1Cnt, s2Cnt} - nzStructSysMatK2;
  end
end

% dissect sparse matrices to work on value arrays
% Assumption: All matrices have the same nonzero pattern.
val = cell(length(sIntPnts{1}), length(sIntPnts{2}));
valK2 = cell(length(sIntPnts{1}), length(sIntPnts{2}));
[rowStruct, colStruct, valStructSysMat] = find(nzStructSysMat);
[rowK2Struct, colK2Struct, valK2StructSysMatK2] = find(nzStructSysMatK2);
for s1Cnt = 1:length(sIntPnts{1})
  for s2Cnt = 1:length(sIntPnts{2})
    [row, col, val{s1Cnt, s2Cnt}] = find(sysMatIntp{s1Cnt, s2Cnt});
    val{s1Cnt, s2Cnt} = val{s1Cnt, s2Cnt} - valStructSysMat;
    if ~(sum(rowStruct == row) == length(row))
      error('Wrong nonzero pattern');
    end
    [rowK2, colK2, valK2{s1Cnt, s2Cnt}] = find(k2MatIntp{s1Cnt, s2Cnt});
    if ~(sum(rowK2Struct == rowK2) == length(rowK2))
      error('Wrong nonzero pattern');
    end
    valK2{s1Cnt, s2Cnt} = valK2{s1Cnt, s2Cnt} - valK2StructSysMatK2;
  end
end

toc;

[rSize cSize] = size(sysMatIntp{1, 1});
clear sysMatIntp;
clear k2MatIntp;

% build one dimensional Lagrange polynomials
lagrPoly = cell(length(sIntPnts), ...
  max(length(sIntPnts{1}), length(sIntPnts{2})));
for dimCnt = 1:length(sIntPnts)
  for pntCnt = 1:length(sIntPnts{dimCnt})
    c = zeros(length(sIntPnts{dimCnt}), 1);
    c(pntCnt) = 1;
    lagrPoly{dimCnt, pntCnt} = Vinv{dimCnt} * c;
  end
end

finalPoly = [];
maxOrder = length(sIntPnts{1}) + length(sIntPnts{2} - 2);
numParams = 2;
for k = 0:maxOrder
  finalPoly = rec(numParams, k, finalPoly, 0, 1);
end
coeffPoly = zeros(size(finalPoly, 1), length(val{1, 1}));
coeffPolyK2 = zeros(size(finalPoly, 1), length(valK2{1, 1}));

poly = cell(2, 1);
for x1Cnt = 1:length(sIntPnts{1})
  for x2Cnt = 1:length(sIntPnts{2})
    % lagrange polynom along parameter 1
    poly{1} = lagrPoly{1, x1Cnt};
    % lagrange polynom along parameter 2
    poly{2} = lagrPoly{2, x2Cnt};
    for pow1Cnt = 1:length(poly{1})
      for pow2Cnt = 1:length(poly{2})
        rowNow = [(pow1Cnt - 1) (pow2Cnt - 1)];
        rowPos = findRowInMat(rowNow, finalPoly);
        coeffPoly(rowPos, :) = coeffPoly(rowPos,:) + ...
          val{x1Cnt, x2Cnt}.' * poly{1}(pow1Cnt) * ...
          poly{2}(pow2Cnt);        
        coeffPolyK2(rowPos, :) = coeffPolyK2(rowPos,:) + ...
          valK2{x1Cnt, x2Cnt}.' * poly{1}(pow1Cnt) * ...
          poly{2}(pow2Cnt);        
      end
    end
  end
end

parMat = cell(size(finalPoly, 1), 1);
parMatK2 = cell(size(finalPoly, 1), 1);
% assemble polynomial parameter dependence matrices
for matCnt = 1:length(parMat)
  parMat{matCnt} = sparse(row, col, coeffPoly(matCnt, :), rSize, cSize);
  parMatK2{matCnt} = sparse(rowK2, colK2, coeffPolyK2(matCnt, :), ...
    rSize, cSize);
end

% % test purpose
% for matCnt = 1:length(s)
%   parMat{1} + s(matCnt) * parMat{2} + s(matCnt)^2 * parMat{3} - ...
%     sysMatrix{matCnt}
% end


%% test model

% load original matrices
sOrig{1} = -0.004:0.0005:0.004;
sOrig{2} = -0.002:0.00025:0.002;

modelNameOriginalBase = ...
  'C:\work\examples\lenseQuarterShort\fine_h0_p2\lenseQuarterShort_1e+010_5_dy_';
% modelNameOriginalBase = ...
%   'Y:\examples\lenseQuarterShort\fine_h1_p2\lenseQuarterShort_1e+010_5_dy_';
dimSmat = 2;

% rhs and leftVec are always the same, therefore only load them once
rhs = zeros(size(parMat{1}, 2), dimSmat);
lVec = zeros(size(parMat{1}, 2), dimSmat);
for dimCnt = 1:dimSmat
  fNameRHS = strcat(modelNameOriginalBase, num2str(sOrig{1}(1)), ...
    '_dz_', num2str(sOrig{2}(1)), '\rhs', num2str(dimCnt-1));
  rhs(:,dimCnt) = vectorReader(fNameRHS);
  fNameLvec = strcat(modelNameOriginalBase, num2str(sOrig{1}(1)), ...
  '_dz_', num2str(sOrig{2}(1)), '\leftVec', num2str(dimCnt-1));
  lVec(:,dimCnt) = vectorReader(fNameLvec);
end
rhs = j*rhs;

% load matrices and solve
z11 = zeros(length(sOrig{1}), length(sOrig{2}));
s11 = zeros(length(sOrig{1}), length(sOrig{2}));
for s1Cnt = 1:length(sOrig{1})
  for s2Cnt = 1:length(sOrig{2})
    fNameMatrix = strcat(modelNameOriginalBase, ...
      num2str(sOrig{1}(s1Cnt)), '_dz_', ...
      num2str(sOrig{2}(s2Cnt)), '\system matrix');
    sMatOrig = MatrixMarketReader(fNameMatrix);
    Z = lVec.' * (sMatOrig\rhs);
    z11(s1Cnt, s2Cnt) = Z(1, 1);
    S = inv(Z - eye(dimSmat)) * (Z + eye(dimSmat));
    s11(s1Cnt, s2Cnt) = S(1,1);
  end
end


% solve with explicite parameter dependence
sTest = sOrig;
% build matrices and solve
z11Test = zeros(length(sOrig{1}), length(sOrig{2}));
s11Test = zeros(length(sOrig{1}), length(sOrig{2}));
for s1Cnt = 1:length(sTest{1})
  for s2Cnt = 1:length(sTest{2})
    sAct = [sTest{1}(s1Cnt) sTest{2}(s2Cnt)];
    disp(sAct);
    % REVISIT: fast hack to get nonzero pattern
    sysMatNow = parMat{1};
    sysMatNow = sysMatNow - parMat{1};
    for rowCnt = 1:size(finalPoly, 1)
      pow = 1;
      for parCnt = 1:size(finalPoly, 2)
        pow = pow * sAct(parCnt)^finalPoly(rowCnt, parCnt);
      end
      sysMatNow = sysMatNow + parMat{rowCnt} * pow ;
    end
    Z = lVec.' * (sysMatNow\rhs);
    z11Test(s1Cnt, s2Cnt) = Z(1, 1);
    S = inv(Z - eye(dimSmat)) * (Z + eye(dimSmat));
    s11Test(s1Cnt, s2Cnt) = S(1,1);
  end
end

figure;
surf(sTest{2}, sTest{1}, abs(s11));
figure,
surf(sTest{2}, sTest{1}, abs(s11Test));
figure;
surf(sTest{2}, sTest{1}, abs(s11 - s11Test));

% fNameParMat = strcat(geoModelName, 'parMat');
% save(fNameParMat, 'parMat', 'finalPoly');
% fNameParMat = strcat(geoModelName, 'parMatK2');
% save(fNameParMat, 'parMatK2', 'finalPoly');
% fNameAll = strcat(geoModelName, 'all_h0_p2');
% save(fNameAll);

% %% frequency sweep
% numLeftVecs = 2;
% yDist = 0.003;
% zDist = 0.001;
% % yDist = 0;
% % zDist = 0;
% freqParam.fExp = 10e9;
% freqParam.fMin = 8e9;
% freqParam.fMax = 17e9;
% freqParam.numPnts = 31;
% c0 = 299792.458e3;
% k0 = 2 * pi * freqParam.fExp / c0;
% freqParam.fCutOff = [7.49481137281049e9 7.49481137281049e9];
% freqParam.steps = calcK_SquareRelSteps(freqParam.fExp, freqParam.fMin, ...
%   freqParam.fMax, freqParam.numPnts);
% scaleRHS = calcScaleRHS(freqParam.fExp, freqParam.fMin, freqParam.fMax, ...
%   freqParam.numPnts, freqParam.fCutOff);
% rhsF = cell(numLeftVecs, 1);
% leftVecsF = cell(numLeftVecs, 1);
% for rhsCnt = 1:numLeftVecs
%   rhsF{rhsCnt} = rhs(:,rhsCnt);
%   leftVecsF{rhsCnt} = lVec(:,rhsCnt);
% end
% % load matrices
% fNameMatrix = strcat(modelNameOriginalBase, num2str(yDist), '_dz_', ...
%   num2str(zDist), '\system matrix');
% sMatFreq = MatrixMarketReader(fNameMatrix);
% fNameMatrixK2 = strcat(modelNameOriginalBase, num2str(yDist), '_dz_', ...
%   num2str(zDist), '\k^2 matrix');
% sMatFreqK2 = MatrixMarketReader(fNameMatrixK2);
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
% 
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
% figure;
% plot(f, abs(s11F), 'r');
% grid;
% hold;
% 
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
% 
