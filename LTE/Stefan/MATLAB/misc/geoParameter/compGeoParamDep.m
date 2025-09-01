close all;
clear all;

set(0,'DefaultFigureWindowStyle','docked');

%% reconstruct parameter dependence

s = -0.004:0.001:0.004;

geoModelName = ...
  'C:\work\examples\lenseQuarterShort\lenseQuarterShort_1e+010_5_geoModel_-0.004_0_0.004\';

modelNameOriginalBase = ...
  'C:\work\examples\lenseQuarterShort\fine_h0_p1\lenseQuarterShort_1e+010_5_dy_';
for k = 1:length(s)
  fNameMatrix = strcat(modelNameOriginalBase, num2str(s(k)), ...
    '_dz_', num2str(0), '\system matrix');
  sysMatrix{k} = MatrixMarketReader(fNameMatrix);
end

% [row1, col1, val1] = find(sysMatrix{1});
% [row2, col2, val2] = find(sysMatrix{2});
% for k = 1:length(row1)
%   if (row1(k) ~= row2(k)) || (col1(k) ~= col2(k))
%     disp('found');
%   end
% end

% build Vandermonde matrix
V = zeros(length(s));
for k = 1:length(s)
  for m = 1:length(s)
    V(k, m) = s(k)^(m - 1);
  end
end
Vinv = inv(V);

% dissect sparse matrices to work on value arrays
% all matrices have the same nonzero pattern
val = zeros(nnz(sysMatrix{1}), length(s));
for k = 1:length(s)
  [row, col, val(:,k)] = find(sysMatrix{k});
end

parVal = zeros(size(val));

for valCnt = 1:size(parVal, 1)
  parVal(valCnt,:) = (Vinv * val(valCnt,:).').';
end

% assemble polynomial parameter dependence matrices
[r c] = size(sysMatrix{1});
for matCnt = 1:length(s)
  parMat{matCnt} = sparse(row, col, parVal(:,matCnt), r, c);
end

% % test purpose
% for matCnt = 1:length(s)
%   parMat{1} + s(matCnt) * parMat{2} + s(matCnt)^2 * parMat{3} - ...
%     sysMatrix{matCnt}
% end

%% test model

% load original matrices
yOrig = -0.004:0.0005:0.004;
zOrig = 0;
modelNameOriginalBase = ...
  'C:\work\examples\lenseQuarterShort\fine_h0_p1\lenseQuarterShort_1e+010_5_dy_';
dimSmat = 2;

% rhs and leftVec are always the same, therefore only load them once
rhs = zeros(size(sysMatrix{1},2), dimSmat);
lVec = zeros(size(sysMatrix{1},2), dimSmat);
for dimCnt = 1:dimSmat
  fNameRHS = strcat(modelNameOriginalBase, num2str(yOrig(1)), ...
    '_dz_', num2str(zOrig), '\rhs', num2str(dimCnt-1));
  rhs(:,dimCnt) = vectorReader(fNameRHS);
  fNameLvec = strcat(modelNameOriginalBase, num2str(yOrig(1)), ...
  '_dz_', num2str(zOrig), '\leftVec', num2str(dimCnt-1));
  lVec(:,dimCnt) = vectorReader(fNameLvec);
end
rhs = j*rhs;

% load matrices and solve
for pntCnt = 1:length(yOrig)
  fNameMatrix = strcat(modelNameOriginalBase, num2str(yOrig(pntCnt)), ...
    '_dz_', num2str(zOrig), '\system matrix');
  sMatOrig = MatrixMarketReader(fNameMatrix);
  Z{pntCnt} = lVec.' * (sMatOrig\rhs);
end

for k = 1:length(yOrig)
  z11(k) = Z{k}(1,1);
end

for sMatCnt = 1:length(yOrig)
  sMat{sMatCnt} = inv(Z{sMatCnt} - eye(dimSmat))...
    * (Z{sMatCnt} + eye(dimSmat));
  s11(sMatCnt) = sMat{sMatCnt}(1,1);
end

% solve with explicite parameter dependence
sTest = -0.004:0.0001:0.004;
% build matrices and solve
for pntCnt = 1:length(sTest)
  sTest(pntCnt)
  % REVISIT: fast hack to get nonzero pattern
  sMatNow = sysMatrix{1};
  sMatNow = sMatNow - sysMatrix{1};
  for powerCnt = 1:length(s)
    sMatNow = sMatNow + sTest(pntCnt)^(powerCnt-1) * parMat{powerCnt};
  end
%     sMatNow = parMat{1} + sTest(pntCnt) * parMat{2} + ...
%       sTest(pntCnt)^2 * parMat{3};
  Ztest{pntCnt} = lVec.' * (sMatNow\rhs);
end

for k = 1:length(sTest)
  z11Test(k) = Ztest{k}(1,1);
end

for sMatCnt = 1:length(sTest)
  sMatTest{sMatCnt} = inv(Ztest{sMatCnt} - eye(dimSmat))...
    * (Ztest{sMatCnt} + eye(dimSmat));
  s11Test(sMatCnt) = sMatTest{sMatCnt}(1,1);
end

% impedance plot
figHandle = figure;
plot(yOrig, abs(z11), 'rd');
hold;
grid;
plot(sTest, abs(z11Test));

% s11 plot
figHandle = figure;
plot(yOrig, abs(s11), 'rd');
hold;
grid;
plot(sTest, abs(s11Test));


%%
% 
% function h = lagrange( N, delay )
% % h = lagrange( N, delay )
% N = 10;
% delay = 0.1
% 
% n = 0:N;
% h = ones(1,N+1);
% for k = 0:N
%     index = find(n ~= k);
%     h(index) = h(index) *  (delay-k)./ (n(index)-k);
% end


s = [0 0.5 1];
% build Vandermonde matrix
V = zeros(length(s));
for k = 1:length(s)
  for m = 1:length(s)
    V(k, m) = s(k)^(m - 1);
  end
end
Vinv = inv(V);
c = [0 1 0].';
Vinv*c


