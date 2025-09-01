close all;
clear all;

tic;

linewidth = 2.5;
fontsize = 14;

set(0,'DefaultFigureWindowStyle','docked');

%% reconstruct parameter dependence

geoModelName = ...
  'C:\work\examples\wgIrisQuarterShort\wgIrisQuarterShort_1e+010_geoModel\';

% parameter intervals
s1Start = -0.000;
s1End   =  0.004;
s2Start = -0.002;
s2End   =  0.001;

% interpolation points in reference quadrilateral
% sIntPntsRef{1} = [0 1];  % x direction
% sIntPntsRef{2} = [0 1];  % y direction
% sIntPntsBarRef{1} = [0 0.5 1];  % x direction
% sIntPntsBarRef{2} = [0 0.5 1];  % y direction
% sIntPntsRef{1} = [0 0.5 1];  % x direction
% sIntPntsRef{2} = [0 0.5 1];  % y direction
% sIntPntsBarRef{1} = [0 0.25 0.5 0.75 1];  % x direction
% sIntPntsBarRef{2} = [0 0.25 0.5 0.75 1];  % y direction

% sIntPntsRef{1} = [0 0.5 1];  % x direction
% sIntPntsRef{2} = [0 0.5 1];  % y direction
% sIntPntsBarRef{1} = [0 1/6 2/6 0.5 4/6 5/6 1];  % x direction
% sIntPntsBarRef{2} = [0 1/6 2/6 0.5 4/6 5/6 1];  % y direction

sIntPntsRef{1} = [0 0.5 1];  % x direction
sIntPntsRef{2} = [0 1/6 0.5 5/6 1];  % y direction
sIntPntsBarRef{1} = [0 1/4 0.5 3/4 1];  % x direction
sIntPntsBarRef{2} = [0 1/6 2/6 0.5 4/6 5/6 1];  % y direction

% sIntPntsRef{1} = [0 1];  % x direction
% sIntPntsRef{2} = [0 1/12 2/6 0.5 4/6 11/12 1];  % y direction
% sIntPntsBarRef{1} = [0 1/3 2/3 1];  % x direction
% sIntPntsBarRef{2} = [0 1/6 2/6 0.5 4/6 5/6 1];  % y direction

% sIntPntsRef{1} = [0 1];  % x direction
% sIntPntsRef{2} = [0 1/20 1/5  2/5 3/5 4/5 19/20 1];  % y direction
% sIntPntsBarRef{1} = [0 1/3 2/3 1];  % x direction
% sIntPntsBarRef{2} = [0 1/20 1/5  2/5 3/5 4/5 19/20 1];  % y direction

% compute interpolation points
sIntPnts = cell(length(sIntPntsRef), 1);
sIntPntsBar = cell(length(sIntPntsBarRef), 1);
sIntPnts{1} = s1Start * (1 - sIntPntsRef{1}) + s1End * sIntPntsRef{1};
sIntPnts{2} = s2Start * (1 - sIntPntsRef{2}) + s2End * sIntPntsRef{2};
sIntPntsBar{1} = s1Start * (1 - sIntPntsBarRef{1}) + ...
  s1End * sIntPntsBarRef{1};
sIntPntsBar{2} = s2Start * (1 - sIntPntsBarRef{2}) + ...
  s2End * sIntPntsBarRef{2};

numIntPnts = length(sIntPnts{1}) * length(sIntPntsBar{2}) + ...
  length(sIntPntsBar{1}) * length(sIntPnts{2}) - ...
  length(sIntPnts{1}) * length(sIntPnts{2});
sIntPntsList = zeros(numIntPnts, 2);
posList = 1;
% compute interpolation point list
for s1Cnt = 1:length(sIntPnts{1})
  for s2Cnt = 1:length(sIntPntsBar{2})
    sIntPntsList(posList, :) = [sIntPnts{1}(s1Cnt) sIntPntsBar{2}(s2Cnt)];
    posList = posList + 1;
  end
end
for s1Cnt = 1:length(sIntPntsBar{1})
  for s2Cnt = 1:length(sIntPnts{2})
    row = [sIntPntsBar{1}(s1Cnt) sIntPnts{2}(s2Cnt)];
    rowPos = findRowInMat(row, sIntPntsList);
    if rowPos == -1
      sIntPntsList(posList, :) = [sIntPntsBar{1}(s1Cnt) sIntPnts{2}(s2Cnt)];
      posList = posList + 1;
    end
  end
end
figure;
plot(sIntPntsList(:, 1), sIntPntsList(:, 2), 'x');
grid;

% compute system matrices at interpolation points
modelNameOriginalBase = ...
  'C:\work\examples\wgIrisQuarterShort\wgIrisQuarterShort_1e+010_5_dy_';
% sysMatIntp = cell(s1NumPnts, s2NumPnts);
% k2MatIntp  = cell(s1NumPnts, s2NumPnts);
sysMatIntp = cell(numIntPnts, 1);
k2MatIntp  = cell(numIntPnts, 1);

for pntCnt = 1:numIntPnts
  % call MeshDistorter
  systemString = ['cd C:\work\examples\wgIrisQuarterShort\ & '...
    'MeshDistorter wgIrisQuarterShort 10000000000 5 ' ...
    num2str(sIntPntsList(pntCnt, 1)) ' ' num2str(sIntPntsList(pntCnt, 2)) ...
    ' -dx \w'];
  system(systemString);

  % name of new created directory
  dirName = strcat(modelNameOriginalBase, ...
    num2str(sIntPntsList(pntCnt, 1)), '_dz_', ...
    num2str(sIntPntsList(pntCnt, 2)), '\');
  fNameSysMat = strcat(dirName, 'system matrix');
  sysMatIntp{pntCnt} = MatrixMarketReader(fNameSysMat);
  fNameK2Mat = strcat(dirName, 'k^2 matrix');
  k2MatIntp{pntCnt} = MatrixMarketReader(fNameK2Mat);
  rmdir(dirName, 's');
end

% give every matrix the same nonzero pattern
nzStructSysMat = spones(sysMatIntp{1});
nzStructSysMatK2 = spones(k2MatIntp{1});
for pntCnt = 1:numIntPnts
  nzStructSysMat = nzStructSysMat + spones(sysMatIntp{pntCnt});
  nzStructSysMatK2 = nzStructSysMatK2 + spones(k2MatIntp{pntCnt});
end
for pntCnt = 1:numIntPnts
  sysMatIntp{pntCnt} = sysMatIntp{pntCnt} + nzStructSysMat;
%     sysMatIntp{s1Cnt, s2Cnt} = sysMatIntp{s1Cnt, s2Cnt} - nzStructSysMat;
  k2MatIntp{pntCnt} = k2MatIntp{pntCnt} + nzStructSysMatK2;
%     k2MatIntp{s1Cnt, s2Cnt} = k2MatIntp{s1Cnt, s2Cnt} - nzStructSysMatK2;
end

% dissect sparse matrices to work on value arrays
% Assumption: All matrices have the same nonzero pattern.
val = cell(numIntPnts, 1);
valK2 = cell(numIntPnts, 1);
[rowStruct, colStruct, valStructSysMat] = find(nzStructSysMat);
[rowK2Struct, colK2Struct, valK2StructSysMatK2] = find(nzStructSysMatK2);
for pntCnt = 1:numIntPnts
  [row, col, val{pntCnt}] = find(sysMatIntp{pntCnt});
  val{pntCnt} = val{pntCnt} - valStructSysMat;
  if ~(sum(rowStruct == row) == length(row))
    error('Wrong nonzero pattern');
  end
  [rowK2, colK2, valK2{pntCnt}] = find(k2MatIntp{pntCnt});
  if ~(sum(rowK2Struct == rowK2) == length(rowK2))
    error('Wrong nonzero pattern');
  end
  valK2{pntCnt} = valK2{pntCnt} - valK2StructSysMatK2;
end

[rSize cSize] = size(sysMatIntp{1, 1});

clear sysMatIntp;
clear k2MatIntp;

toc;

% compute [Q R] factorizations of Vandermonde matrices
Q = cell(length(sIntPnts));
R = cell(length(sIntPnts));
for dimCnt = 1:length(sIntPnts)
  V = zeros(length(sIntPnts{dimCnt}));
  for k = 1:length(sIntPnts{dimCnt})
    for m = 1:length(sIntPnts{dimCnt})
      V(k, m) = sIntPnts{dimCnt}(k)^(m - 1);
    end
  end
  [Q{dimCnt} R{dimCnt}] = qr(V);
end

Q_Bar = cell(length(sIntPntsBar));
R_Bar = cell(length(sIntPntsBar));
for dimCnt = 1:length(sIntPntsBar)
  V = zeros(length(sIntPntsBar{dimCnt}));
  for k = 1:length(sIntPntsBar{dimCnt})
    for m = 1:length(sIntPntsBar{dimCnt})
      V(k, m) = sIntPntsBar{dimCnt}(k)^(m - 1);
    end
  end
%   VinvBar{dimCnt} = inv(V);
  [Q_Bar{dimCnt} R_Bar{dimCnt}] = qr(V);
end

% build one dimensional Lagrange polynomials
lagrPoly = cell(length(sIntPnts), ...
  max(length(sIntPnts{1}), length(sIntPnts{2})));
for dimCnt = 1:length(sIntPnts)
  for pntCnt = 1:length(sIntPnts{dimCnt})
    c = zeros(length(sIntPnts{dimCnt}), 1);
    c(pntCnt) = 1;
%     lagrPoly{dimCnt, pntCnt} = Vinv{dimCnt} * c;
    lagrPoly{dimCnt, pntCnt} = R{dimCnt} \ (Q{dimCnt}' * c);
  end
end

lagrPolyBar = cell(length(sIntPntsBar), ...
  max(length(sIntPntsBar{1}), length(sIntPntsBar{2})));
for dimCnt = 1:length(sIntPntsBar)
  for pntCnt = 1:length(sIntPntsBar{dimCnt})
    c = zeros(length(sIntPntsBar{dimCnt}), 1);
    c(pntCnt) = 1;
%     lagrPolyBar{dimCnt, pntCnt} = VinvBar{dimCnt} * c;
    lagrPolyBar{dimCnt, pntCnt} = R_Bar{dimCnt} \ (Q_Bar{dimCnt}' * c);
  end
end

finalPoly = [];
maxOrder = max(length(sIntPntsBar{1}) + length(sIntPnts{2}), ...
  length(sIntPnts{1}) + length(sIntPntsBar{2}))- 2;
numParams = 2;
for k = 0:maxOrder
  finalPoly = rec(numParams, k, finalPoly, 0, 1);
end
coeffPoly = zeros(size(finalPoly, 1), length(val{1}));
coeffPolyK2 = zeros(size(finalPoly, 1), length(valK2{1}));

for pntCnt = 1:numIntPnts
  poly = cell(2, 1);
  polyBar = cell(2, 1);
%   % for x1Cnt = 1:length(sIntPnts{1})
%   x1Cnt = 1;
%   %   for x2Cnt = 1:length(sIntPnts{2})
%   x2Cnt = 1;
  s1Pos = find(sIntPnts{1} == sIntPntsList(pntCnt, 1));
  if ~isempty(s1Pos)
    % lagrange polynom along parameter 1
    poly{1} = lagrPoly{1, s1Pos};
  end
  s2Pos = find(sIntPnts{2} == sIntPntsList(pntCnt, 2));
  if ~isempty(s2Pos)
    % lagrange polynom along parameter 2
    poly{2} = lagrPoly{2, s2Pos};
  end
  s1PosBar = find(sIntPntsBar{1} == sIntPntsList(pntCnt, 1));
  if ~isempty(s1PosBar)
    % lagrange polynom along parameter 1
    polyBar{1} = lagrPolyBar{1, s1PosBar};
  end
  s2PosBar = find(sIntPntsBar{2} == sIntPntsList(pntCnt, 2));
  if ~isempty(s2PosBar)
    % lagrange polynom along parameter 2
    polyBar{2} = lagrPolyBar{2, s2PosBar};
  end
  
  for pow1Cnt = 1:length(poly{1})
    for pow2Cnt = 1:length(polyBar{2})
      rowNow = [(pow1Cnt - 1) (pow2Cnt - 1)];
      rowPos = findRowInMat(rowNow, finalPoly);
      %         coeffPoly(rowPos, :) = coeffPoly(rowPos, :) + ...
      %           val{x1Cnt, x2Cnt}.' * poly{1}(pow1Cnt) * ...
      %           poly{2}(pow2Cnt);
      coeffPoly(rowPos, :) = coeffPoly(rowPos, :) + ...
        val{pntCnt}.' * poly{1}(pow1Cnt) * ...
        polyBar{2}(pow2Cnt);
      coeffPolyK2(rowPos, :) = coeffPolyK2(rowPos,:) + ...
        valK2{pntCnt}.' * poly{1}(pow1Cnt) * ...
        polyBar{2}(pow2Cnt);
    end
  end

  for pow1Cnt = 1:length(polyBar{1})
    for pow2Cnt = 1:length(poly{2})
      rowNow = [(pow1Cnt - 1) (pow2Cnt - 1)];
      rowPos = findRowInMat(rowNow, finalPoly);
      %         coeffPoly(rowPos, :) = coeffPoly(rowPos, :) + ...
      %           val{x1Cnt, x2Cnt}.' * poly{1}(pow1Cnt) * ...
      %           poly{2}(pow2Cnt);
      coeffPoly(rowPos, :) = coeffPoly(rowPos, :) + ...
        val{pntCnt}.' * polyBar{1}(pow1Cnt) * ...
        poly{2}(pow2Cnt);
      coeffPolyK2(rowPos, :) = coeffPolyK2(rowPos, :) + ...
        valK2{pntCnt}.' * polyBar{1}(pow1Cnt) * ...
        poly{2}(pow2Cnt);
    end
  end

  for pow1Cnt = 1:length(poly{1})
    for pow2Cnt = 1:length(poly{2})
      rowNow = [(pow1Cnt - 1) (pow2Cnt - 1)];
      rowPos = findRowInMat(rowNow, finalPoly);
      %         coeffPoly(rowPos, :) = coeffPoly(rowPos, :) + ...
      %           val{x1Cnt, x2Cnt}.' * poly{1}(pow1Cnt) * ...
      %           poly{2}(pow2Cnt);
      coeffPoly(rowPos, :) = coeffPoly(rowPos, :) - ...
        val{pntCnt}.' * poly{1}(pow1Cnt) * ...
        poly{2}(pow2Cnt);
      coeffPolyK2(rowPos, :) = coeffPolyK2(rowPos, :) - ...
        valK2{pntCnt}.' * poly{1}(pow1Cnt) * ...
        poly{2}(pow2Cnt);
    end
  end
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% finalPoly = [];
% maxOrder = 8;
% numParams = 2;
% for k = 0:maxOrder
%   finalPoly = rec(numParams, k, finalPoly, 0, 1);
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
sOrig{1} = -0.000:0.0005:0.004;
sOrig{2} = -0.002:0.00025:0.001;

modelNameOriginalBase = ...
  'C:\work\examples\wgIrisQuarterShort\fine_h0_p2\wgIrisQuarterShort_1e+010_5_dy_';
% modelNameOriginalBase = ...
%   'V:\examples\lenseQuarterShort\fine_h0_p2\lenseQuarterShort_1e+010_5_dy_';
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
% fNameAll = strcat(geoModelName, 'all_h1_p2_t_5');
%fNameAll = strcat(geoModelName, 'all');
% save(fNameAll);

toc;

%% Check accuracy against remeshed problem
% figure;
% plot(sTest{1}, abs(s11(:, 1)));
% grid;
% hold;
% fNameHFSS_Results = 'lenseQuarterShortModified';
% run(fNameHFSS_Results);
% s11hfss = zeros(length(s1), 1);
% for s1Cnt = 1:length(s1)
%   s11hfss(s1Cnt) = S_HFSS{s1Cnt}(1, 1);
% end
% inRange = find((s1 >= -4) & (s1 <= 4));
% plot(s1(inRange) * 1e-3, abs(s11hfss(inRange)), 'rd');
% 
% % error plot
% figHandle = figure;
% set(figHandle, 'color', 'w');
% posS_Test1 = zeros(length(inRange), 1);
% for pntCnt = 1:length(inRange)
%   posS_Test1(pntCnt) = find(sTest{1} == ...
%     (s1(inRange(pntCnt)) * 1e-3));
% end
% plot(s1(inRange), abs(s11hfss(inRange) - s11(posS_Test1, 1)), ...
%   'LineWidth', linewidth);
% grid;
% set(gca, 'FontSize', fontsize);
% xlabel('Frequency (GHz)');
% ylabel('|Error|');

% save dataPic1 sTest s11 s11hfss inRange 

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
% fOrig = zeros(kStepCnt, 1);
% s11FOrig = zeros(kStepCnt, 1);
% for kStepCnt = 1:freqParam.numPnts
%   fOrig(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
%   s11FOrig(kStepCnt) = sF{kStepCnt}(1, 1);
% end
% figure;
% plot(fOrig, abs(s11FOrig), 'r');
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
% % 
% % save tschFreSwpAll

