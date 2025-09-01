close all;
clear;

tic;

linewidth = 2.0;
fontsize = 14;

addpath(genpath('C:\work\Matlab'));
set(0, 'DefaultFigureWindowStyle', 'docked');
modelNameOriginalBase = 'C:\work\examples\bandpassfilter\bandpass2\bandpass2_1.1e+009_5_l12_';
modelNameRefBase = 'C:\work\examples\bandpassfilter\bandpass2\referenceValues\bandpass2_1.1e+009_5_l12_';
geoModelName = 'C:\work\examples\bandpassfilter\bandpass2\bandpass2_1.1e+009_5_geo\';


% dirNameTest = 'C:\work\examples\bandpassfilter\bandpass2\bandpass2_1.1e+009_5_l12_0.17_d1_0.015_d2_0.038_test\';
% compressData(dirNameTest)
% load(strcat(dirNameTest,'rhs0'));
% rhs0



%% reconstruct parameter dependence

% nominal values
l12n = 0.18;
d1n = 0.016;
d2n = 0.04;

% parameter intervals
% s1Start = -0.03;
% s1End   = 0.03;
% s1NumPnts = 2;
% s2Start = -0.008;
% s2End   = 0.016;
% s2NumPnts = 2;
% s3Start = -0.02;
% s3End   = 0.04;
% s3NumPnts = 2;
s1Start = -0.03;
s1End   = 0.03;
s1NumPnts = 6;
s2Start = -0.007;
s2End   = 0.014;
s2NumPnts = 6;
s3Start = -0.017;
s3End   = 0.034;
s3NumPnts = 6;

% compute interpolation points
% take arbitrary interval into accout, not only [-1,1]
bma1 = 0.5 * (s1End - s1Start);
bpa1 = 0.5 * (s1End + s1Start);
bma2 = 0.5 * (s2End - s2Start);
bpa2 = 0.5 * (s2End + s2Start);
bma3 = 0.5 * (s3End - s3Start);
bpa3 = 0.5 * (s3End + s3Start);

% evalute the function at the zeros of the n-th Tschebyscheff polynomial
y1 = cos(pi * ((1:s1NumPnts) - 0.5) / s1NumPnts);
sIntPnts{1} = y1 * bma1 + bpa1;
y2 = cos(pi * ((1:s2NumPnts) - 0.5) / s2NumPnts);
sIntPnts{2} = y2 * bma2 + bpa2;
y3 = cos(pi * ((1:s3NumPnts) - 0.5) / s3NumPnts);
sIntPnts{3} = y3 * bma3 + bpa3;

% hierarchical interpolation points for debug purpose
% sIntPnts{1} = -0.03 : 0.015 : 0.03;
% sIntPnts{2} = -0.008 : 0.004 : 0.016;
% sIntPnts{3} = -0.02 : 0.01 : 0.04;
% sIntPnts{1} = -0.03 : 0.015/2 : 0.03;
% sIntPnts{2} = -0.008 : 0.004/2 : 0.016;
% sIntPnts{3} = -0.02 : 0.01/2 : 0.04;
% sIntPnts{1} = s1Start : (s1End-s1Start)/(s1NumPnts-1) : s1End;
% sIntPnts{2} = s2Start : (s2End-s2Start)/(s2NumPnts-1) : s2End;
% sIntPnts{3} = s3Start : (s3End-s3Start)/(s3NumPnts-1) : s3End;

s1NumPnts = length(sIntPnts{1});
s2NumPnts = length(sIntPnts{2});
s3NumPnts = length(sIntPnts{3});

sysMatIntp = cell(s1NumPnts, s2NumPnts, s3NumPnts);
k2MatIntp  = cell(s1NumPnts, s2NumPnts, s3NumPnts);

for s1Cnt = 1:length(sIntPnts{1})
  for s2Cnt = 1:length(sIntPnts{2})
    for s3Cnt = 1:length(sIntPnts{3})
      % call MeshDistorter
      systemString = ['cd C:\work\examples\bandpassfilter\bandpass2\ & '...
        'MeshDistorter bandpass2 1.1e9 5 ' num2str(l12n + sIntPnts{1}(s1Cnt)) ' ' ...
        num2str(d1n + sIntPnts{2}(s2Cnt)) ' ' num2str(d2n + sIntPnts{3}(s3Cnt)) ' -dx \w'];
      system(systemString);
      
      % name of new created directory
      dirName = buildDirName(modelNameOriginalBase, l12n + sIntPnts{1}(s1Cnt), ...
        d1n + sIntPnts{2}(s2Cnt), d2n + sIntPnts{3}(s3Cnt));
      compressData(dirName);      
%       dirName = buildDirName(modelNameRefBase, l12n + sIntPnts{1}(s1Cnt), ...
%         d1n + sIntPnts{2}(s2Cnt), d2n + sIntPnts{3}(s3Cnt));
%       fNameSysMat = strcat(dirName, 'system matrix');
%       sysMatIntp{s1Cnt, s2Cnt, s3Cnt} = MatrixMarketReader(fNameSysMat);
      fNameSysMat = strcat(dirName, 'systemMatrix');
      sysMatInpNow = load(fNameSysMat);
      sysMatIntp{s1Cnt, s2Cnt, s3Cnt} = sysMatInpNow.systemMatrix;
%       fNameK2Mat = strcat(dirName, 'k^2 matrix');
%       k2MatIntp{s1Cnt, s2Cnt, s3Cnt} = MatrixMarketReader(fNameK2Mat);
      fNameK2Mat = strcat(dirName, 'k^2matrix');
      k2MatIntpNow = load(fNameK2Mat);
      k2MatIntp{s1Cnt, s2Cnt, s3Cnt} = k2MatIntpNow.k2Matrix;
%       systemString2 = ['rmdir ' dirName ' /s /q'];
%       system(systemString2);
    end
  end
end

% build Vandermonde matrices
Q = cell(length(sIntPnts), 1);
R = cell(length(sIntPnts), 1);
for dimCnt = 1:length(sIntPnts)
  V = zeros(length(sIntPnts{dimCnt}));
  for k = 1:length(sIntPnts{dimCnt})
    for m = 1:length(sIntPnts{dimCnt})
      V(k, m) = sIntPnts{dimCnt}(k)^(m - 1);
    end
  end
  [Q{dimCnt} R{dimCnt}] = qr(V);
end

% give every matrix the same nonzero pattern
nzStructSysMat = spones(sysMatIntp{1, 1});
nzStructSysMatK2 = spones(k2MatIntp{1, 1});
for s1Cnt = 1:length(sIntPnts{1})
  for s2Cnt = 1:length(sIntPnts{2})
    for s3Cnt = 1:length(sIntPnts{3})
      nzStructSysMat = nzStructSysMat + spones(sysMatIntp{s1Cnt, s2Cnt, s3Cnt});
      nzStructSysMatK2 = nzStructSysMatK2 + spones(k2MatIntp{s1Cnt, s2Cnt, s3Cnt});
    end
  end
end
for s1Cnt = 1:length(sIntPnts{1})
  for s2Cnt = 1:length(sIntPnts{2})
    for s3Cnt = 1:length(sIntPnts{3})
      sysMatIntp{s1Cnt, s2Cnt, s3Cnt} = sysMatIntp{s1Cnt, s2Cnt, s3Cnt} + nzStructSysMat;
      k2MatIntp{s1Cnt, s2Cnt, s3Cnt} = k2MatIntp{s1Cnt, s2Cnt, s3Cnt} + nzStructSysMatK2;
    end
  end
end

% dissect sparse matrices to work on value arrays
% Assumption: All matrices have the same nonzero pattern.
val = cell(length(sIntPnts{1}));
valK2 = cell(length(sIntPnts{1}));
[rowStruct, colStruct, valStructSysMat] = find(nzStructSysMat);
[rowK2Struct, colK2Struct, valK2StructSysMatK2] = find(nzStructSysMatK2);
for s1Cnt = 1:length(sIntPnts{1})
  for s2Cnt = 1:length(sIntPnts{2})
    for s3Cnt = 1:length(sIntPnts{3})
      [row, col, val{s1Cnt, s2Cnt, s3Cnt}] = find(sysMatIntp{s1Cnt, s2Cnt, s3Cnt});
      val{s1Cnt, s2Cnt, s3Cnt} = val{s1Cnt, s2Cnt, s3Cnt} - valStructSysMat;
      if ~(sum(rowStruct == row) == length(row))
        error('Wrong nonzero pattern');
      end
      [rowK2, colK2, valK2{s1Cnt, s2Cnt, s3Cnt}] = find(k2MatIntp{s1Cnt, s2Cnt, s3Cnt});
      if ~(sum(rowK2Struct == rowK2) == length(rowK2))
        error('Wrong nonzero pattern');
      end
      valK2{s1Cnt, s2Cnt, s3Cnt} = valK2{s1Cnt, s2Cnt, s3Cnt} - valK2StructSysMatK2;
    end
  end
end

toc;

[rSize cSize] = size(sysMatIntp{1});
clear sysMatIntp;
clear k2MatIntp;

% build one dimensional Lagrange polynomials
lagrPoly = cell(length(sIntPnts), max(length(sIntPnts{1})));
for dimCnt = 1:length(sIntPnts)
  for pntCnt = 1:length(sIntPnts{dimCnt})
    c = zeros(length(sIntPnts{dimCnt}), 1);
    c(pntCnt) = 1;
    lagrPoly{dimCnt, pntCnt} = R{dimCnt} \ (Q{dimCnt}' * c);
  end
end

finalPoly = [];
maxOrder = length(sIntPnts{1}) + length(sIntPnts{2}) + length(sIntPnts{3}) - 3;
numParams = 3;
for k = 0:maxOrder
  finalPoly = rec(numParams, k, finalPoly, 0, 1);
end

% coeffPoly = zeros(size(finalPoly, 1), length(val{1}));
% coeffPolyK2 = zeros(size(finalPoly, 1), length(valK2{1}));
coeffPoly = cell(size(finalPoly, 1), 1);
coeffPolyK2 = cell(size(finalPoly, 1), 1);
poly = cell(1, 1);
for x1Cnt = 1:length(sIntPnts{1})
  for x2Cnt = 1:length(sIntPnts{2})
    for x3Cnt = 1:length(sIntPnts{3})
      % lagrange polynom along parameter 1
      poly{1} = lagrPoly{1, x1Cnt};
      % lagrange polynom along parameter 2
      poly{2} = lagrPoly{2, x2Cnt};
      % lagrange polynom along parameter 3
      poly{3} = lagrPoly{3, x3Cnt};
      for pow1Cnt = 1:length(poly{1})
        for pow2Cnt = 1:length(poly{2})
          for pow3Cnt = 1:length(poly{3})
            rowNow = [(pow1Cnt - 1) (pow2Cnt - 1) (pow3Cnt - 1)];
            rowPos = findRowInMat(rowNow, finalPoly);
%             coeffPoly(rowPos, :) = coeffPoly(rowPos,:) + val{x1Cnt, x2Cnt, x3Cnt}.' * poly{1}(pow1Cnt) ...
%               * poly{2}(pow2Cnt) * poly{3}(pow3Cnt);
%             coeffPolyK2(rowPos, :) = coeffPolyK2(rowPos,:) + valK2{x1Cnt, x2Cnt, x3Cnt}.' * poly{1}(pow1Cnt) ...
%               * poly{2}(pow2Cnt) * poly{3}(pow3Cnt);
            if isempty(coeffPoly{rowPos})
              coeffPoly{rowPos} = val{x1Cnt, x2Cnt, x3Cnt}.' * poly{1}(pow1Cnt) ...
                * poly{2}(pow2Cnt) * poly{3}(pow3Cnt);
              coeffPolyK2{rowPos} = valK2{x1Cnt, x2Cnt, x3Cnt}.' * poly{1}(pow1Cnt) ...
                * poly{2}(pow2Cnt) * poly{3}(pow3Cnt);
            else
              coeffPoly{rowPos} = coeffPoly{rowPos} + val{x1Cnt, x2Cnt, x3Cnt}.' * poly{1}(pow1Cnt) ...
                * poly{2}(pow2Cnt) * poly{3}(pow3Cnt);
              coeffPolyK2{rowPos} = coeffPolyK2{rowPos} + valK2{x1Cnt, x2Cnt, x3Cnt}.' * poly{1}(pow1Cnt) ...
                * poly{2}(pow2Cnt) * poly{3}(pow3Cnt);
            end
          end
        end
      end
    end
  end
end

parMat = cell(size(finalPoly, 1), 1);
parMatK2 = cell(size(finalPoly, 1), 1);
% assemble polynomial parameter dependence matrices
for matCnt = 1:length(parMat)
  if ~isempty(coeffPoly{matCnt})
    parMat{matCnt} = sparse(row, col, coeffPoly{matCnt}, rSize, cSize);
    parMatK2{matCnt} = sparse(rowK2, colK2, coeffPolyK2{matCnt}, rSize, cSize);
  else
    dimMat = size(parMat{1}, 1);
    parMat{matCnt} = sparse(dimMat, dimMat);
    parMatK2{matCnt} = sparse(dimMat, dimMat);
  end
end

% save(strcat(geoModelName, 'bandpassBeforeTest_5_5_5.mat'));
 
toc;
 

%% test model

% load(strcat(geoModelName, 'bandpassBeforeTest.mat'));
% load original matrices
% sOrig{1} = 0.17:0.01:0.19;
% sOrig{2} = 0.015:0.001:0.017;
% sOrig{3} = 0.038:0.002:0.042;
% sOrig{1} = -0.03 : 0.015 : 0.03;
% sOrig{2} = -0.008 : 0.004 : 0.016;
% sOrig{3} = -0.02 : 0.01 : 0.04;
sOrig{1} = -0.03 : 0.015 : 0.03;
sOrig{2} = -0.007 : 0.004 : 0.014;
sOrig{3} = -0.017 : 0.01 : 0.034;
s1NumPnts = 9;
s2NumPnts = 9;
s3NumPnts = 9;
sOrig{1} = s1Start : (s1End-s1Start)/(s1NumPnts-1) : s1End;
sOrig{2} = s2Start : (s2End-s2Start)/(s2NumPnts-1) : s2End;
sOrig{3} = s3Start : (s3End-s3Start)/(s3NumPnts-1) : s3End;

dimSmat = 2;
% rhs and leftVec are always the same, therefore only load them once
rhs = zeros(size(parMat{1}, 2), dimSmat);
lVec = zeros(size(parMat{1}, 2), dimSmat);
for dimCnt = 1:dimSmat
%   dirName = buildDirName(modelNameOriginalBase, l12n + sOrig{1}(1), d1n + sOrig{2}(1), d2n + sOrig{3}(1));
%   dirName = buildDirName(modelNameRefBase, l12n + sOrig{1}(1), d1n + sOrig{2}(1), d2n + sOrig{3}(1));
  fNameRHS = strcat(geoModelName, 'rhs', num2str(dimCnt-1));
  rhs(:,dimCnt) = vectorReader(fNameRHS);
%   rhsRead = load(fNameRHS);
%   if dimCnt == 1
%     rhs(:,dimCnt) = rhsRead.rhs0;
%   elseif dimCnt == 2
%     rhs(:,dimCnt) = rhsRead.rhs1;
%   else
%     error('Should not happen!');
%   end
  fNameLvec = strcat(geoModelName, 'leftVec', num2str(dimCnt-1));
  lVec(:,dimCnt) = vectorReader(fNameLvec);
%   lVecRead = load(fNameLvec);
%   if dimCnt == 1
%     lVec(:,dimCnt) = lVecRead.leftVec0;
%   elseif dimCnt == 2
%     lVec(:,dimCnt) = lVecRead.leftVec1;
%   else
%     error('Should not happen!');
%   end
end
rhs = j*rhs;

% load matrices and solve
z11 = zeros(length(sOrig{1}), length(sOrig{2}), length(sOrig{3}));
s11 = zeros(length(sOrig{1}), length(sOrig{2}), length(sOrig{3}));
for s1Cnt = 1:length(sOrig{1})
  for s2Cnt = 1:length(sOrig{2})
    for s3Cnt = 1:length(sOrig{3})
      systemString = ['cd C:\work\examples\bandpassfilter\bandpass2\ & '...
        'MeshDistorter bandpass2 1.1e9 5 ' num2str(l12n + sOrig{1}(s1Cnt)) ' ' ...
        num2str(d1n + sOrig{2}(s2Cnt)) ' ' num2str(d2n + sOrig{3}(s3Cnt)) ' -dx \w'];
      system(systemString);
      % name of new created directory
      dirName = buildDirName(modelNameOriginalBase, l12n + sOrig{1}(s1Cnt), ...
        d1n + sOrig{2}(s2Cnt), d2n + sOrig{3}(s3Cnt));
%       compressData(dirName);      
      fNameSysMat = strcat(dirName, 'system matrix');
      sMatOrig = MatrixMarketReader(fNameSysMat);
%       fNameSysMat = strcat(dirName, 'systemMatrix');
%       sMatOrig = load(fNameSysMat);
%       fNameMatrix = strcat(buildDirName(modelNameOriginalBase, l12n + sOrig{1}(s1Cnt), d1n + sOrig{2}(s2Cnt), ...
%         d2n + sOrig{3}(s3Cnt)), 'system matrix');
%       sMatOrig = MatrixMarketReader(fNameMatrix);
%       fNameMatrix = strcat(buildDirName(modelNameRefBase, l12n + sOrig{1}(s1Cnt), d1n + sOrig{2}(s2Cnt), ...
%         d2n + sOrig{3}(s3Cnt)), 'systemMatrix');
%       sMatOrigRead = load(fNameMatrix);
%       sMatOrig = sMatOrigRead.systemMatrix;
      Z = lVec.' * (sMatOrig\rhs);
      z11(s1Cnt, s2Cnt) = Z(1, 1);
      S = inv(Z - eye(dimSmat)) * (Z + eye(dimSmat));
      s11(s1Cnt, s2Cnt, s3Cnt) = S(1,1);
    end
  end
end

% save(strcat(geoModelName, 's11Orig'), 's11', 'sOrig');
% load(strcat(geoModelName, 's11Orig_9_9_9'), 's11');

% solve with explicite parameter dependence
sTest = sOrig;
% build matrices and solve
z11Test = zeros(length(sOrig{1}), length(sOrig{2}), length(sOrig{3}));
s11Test = zeros(length(sOrig{1}), length(sOrig{2}), length(sOrig{3}));
for s1Cnt = 1:length(sTest{1})
  for s2Cnt = 1:length(sTest{2})
    for s3Cnt = 1:length(sTest{3})
      sAct = [sTest{1}(s1Cnt) sTest{2}(s2Cnt) sTest{3}(s3Cnt)];
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
      s11Test(s1Cnt, s2Cnt, s3Cnt) = S(1,1);
    end
  end
end

for s3Cnt = 1:length(sOrig{3});
  figure;
  surf(sTest{2} + d1n, sTest{1} + l12n, abs(s11(:,:,s3Cnt)));
  title(strcat('S_{11}: d2 = ', num2str(d2n + sTest{3}(s3Cnt))));
  figure,
  surf(sTest{2} + d1n, sTest{1} + l12n, abs(s11Test(:,:,s3Cnt)));
  title(strcat('S_{11}Test: d2 = ', num2str(d2n + sTest{3}(s3Cnt))));
  figure;
  surf(sTest{2} + d1n, sTest{1} + l12n, abs(s11Test(:,:,s3Cnt) - s11(:,:,s3Cnt)));
  title(strcat('S_{11}Error: d2 = ', num2str(d2n + sTest{3}(s3Cnt))));
end

% fNameParMat = strcat(geoModelName, 'parMat');
% save(fNameParMat, 'parMat', 'finalPoly');
% fNameParMat = strcat(geoModelName, 'parMatK2');
% save(fNameParMat, 'parMatK2', 'finalPoly');
% fNameAll = strcat(geoModelName, 'all_h1_p2_t_5');
%fNameAll = strcat(geoModelName, 'all');
% save(fNameAll);

%save webbDielPostdataEquiPic1 sTest s11 s11Test sIntPnts

% save(strcat(geoModelName, 'bandpassAfterTest_6_6_6_tsch.mat'));
% save(strcat(geoModelName, 's11Test_7_7_7_tsch'), 's11Test', 'sTest');

toc;


%% frequency sweep
% load(strcat(geoModelName, 'bandpassAfterTest.mat'));

numLeftVecs = 2;
s1 = 0.015;
s2 = 0.012;
s3 = 0.03;
freqParam.fExp = 1.1e9;
freqParam.fMin = 1e9;
freqParam.fMax = 1.2e9;
freqParam.numPnts = 101;
c0 = 299792.458e3;
k0 = 2 * pi * freqParam.fExp / c0;
freqParam.fCutOff = [7.4948113728104901e+008 7.4948113728104901e+008];
freqParam.steps = calcK_SquareRelSteps(freqParam.fExp, freqParam.fMin, ...
  freqParam.fMax, freqParam.numPnts);
scaleRHS = calcScaleRHS(freqParam.fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff);
rhsF = cell(numLeftVecs, 1);
leftVecsF = cell(numLeftVecs, 1);
for rhsCnt = 1:numLeftVecs
  rhsF{rhsCnt} = rhs(:,rhsCnt);
  leftVecsF{rhsCnt} = lVec(:,rhsCnt);
end
% % load matrices
% % fNameMatrix = strcat(buildDirName(modelNameRefBase, l12n + s1, d1n + s2, d2n + s3), 'system matrix');
% % sMatFreq = MatrixMarketReader(fNameMatrix);
% fNameMatrix = strcat(buildDirName(modelNameRefBase, l12n + s1, d1n + s2, ...
%   d2n + s3), 'systemMatrix');
% sMatFreqRead = load(fNameMatrix);
% sMatFreq = sMatFreqRead.systemMatrix;
% % fNameMatrixK2 = strcat(buildDirName(modelNameRefBase, l12n + s1, d1n + s2, d2n + s3), '\k^2 matrix');
% % sMatFreqK2 = MatrixMarketReader(fNameMatrixK2);
% fNameMatrix = strcat(buildDirName(modelNameRefBase, l12n + s1, d1n + s2, ...
%   d2n + s3), 'k^2matrix');
% sMatFreqK2Read = load(fNameMatrix);
% sMatFreqK2 = sMatFreqK2Read.k2Matrix;
% build matrices
% call MeshDistorter
systemString = ['cd C:\work\examples\bandpassfilter\bandpass2\ & '...
  'MeshDistorter bandpass2 1.1e9 5 ' num2str(l12n + s1) ' ' ...
  num2str(d1n + s2) ' ' num2str(d2n + s3) ' -dx \w'];
system(systemString);
% name of new created directory
dirName = buildDirName(modelNameOriginalBase, l12n + s1, d1n + s2, d2n + s3);
fNameSysMat = strcat(dirName, 'system matrix');
sMatFreq = MatrixMarketReader(fNameSysMat);
fNameK2Mat = strcat(dirName, 'k^2 matrix');
sMatFreqK2 = MatrixMarketReader(fNameK2Mat);
systemString2 = ['rmdir ' dirName ' /s /q'];
system(systemString2);

% solve
sF = cell(freqParam.numPnts);
for kStepCnt = 1:freqParam.numPnts
  fMat = sMatFreq - k0^2 * freqParam.steps(kStepCnt) * sMatFreqK2;
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
    for lVecCnt = 1:numLeftVecs
      sF{kStepCnt}(lVecCnt, rhsCnt) = leftVecsF{lVecCnt}.' * sol;
    end
  end
end
for sMatCnt = 1:length(sF)
  sF{sMatCnt} = inv(sF{sMatCnt} - eye(numLeftVecs))...
    * (sF{sMatCnt} + eye(numLeftVecs));
end

% 2d plot
if freqParam.numPnts == 1
  deltaF = 0;
else
  deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
end
fOrig = zeros(kStepCnt, 1);
s11FOrig = zeros(kStepCnt, 1);
for kStepCnt = 1:freqParam.numPnts
  fOrig(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
  s11FOrig(kStepCnt) = sF{kStepCnt}(1, 1);
end
figure;
plot(fOrig, abs(s11FOrig), 'r');
grid;
hold;

% build matrices with polynom
sAct = [s1 s2 s3];
% REVISIT: fast hack to get nonzero pattern
sysMatNow = parMat{1};
sysMatNow = sysMatNow - parMat{1};
k2MatNow = parMatK2{1};
k2MatNow = k2MatNow - parMatK2{1};
for rowCnt = 1:size(finalPoly, 1)
  pow = 1;
  for parCnt = 1:size(finalPoly, 2)
    pow = pow * sAct(parCnt)^finalPoly(rowCnt, parCnt);
  end
  sysMatNow = sysMatNow + parMat{rowCnt} * pow;
  k2MatNow = k2MatNow + parMatK2{rowCnt} * pow;
end
sMatFreq = sysMatNow;
sMatFreqK2 = k2MatNow;
% solve
sF = cell(freqParam.numPnts);
for kStepCnt = 1:freqParam.numPnts
  fMat = sMatFreq - k0^2 * freqParam.steps(kStepCnt) * sMatFreqK2;
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
    for lVecCnt = 1:numLeftVecs
      sF{kStepCnt}(lVecCnt, rhsCnt) = leftVecsF{lVecCnt}.' * sol;
    end
  end
end
for sMatCnt = 1:length(sF)
  sF{sMatCnt} = inv(sF{sMatCnt} - eye(numLeftVecs))...
    * (sF{sMatCnt} + eye(numLeftVecs));
end
% 2d plot
if freqParam.numPnts == 1
  deltaF = 0;
else
  deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
end
f = zeros(kStepCnt, 1);
s11F = zeros(kStepCnt, 1);
for kStepCnt = 1:freqParam.numPnts
  f(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
  s11F(kStepCnt) = sF{kStepCnt}(1, 1);
end
plot(f, abs(s11F));
% 
% save tschFreSwpAll

toc;

% save webbDielPostTestEquiZeroPlusF
% save webbDielPostTestEquiZeroPlusFreqPlot f s11F s11FOrig fOrig

% save(strcat(geoModelName, 'bandpassAfterFreq_7_7_7_tsch.mat'));
