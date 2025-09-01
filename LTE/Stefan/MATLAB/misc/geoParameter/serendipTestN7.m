close all;
clear all;

tic;

linewidth = 2.5;
fontsize = 14;

set(0,'DefaultFigureWindowStyle','docked');

%% reconstruct parameter dependence

func = @(x, y) (y^3 * x^2);

% parameter intervals
s1Start = -2;
s1End   =  2;
s2Start = -1;
s2End   =  1;

% interpolation points in reference quadrilateral
% sIntPntsRef{1} = [0 1];  % x direction
% sIntPntsRef{2} = [0 1];  % y direction
% sIntPntsBarRef{1} = [0 0.5 1];  % x direction
% sIntPntsBarRef{2} = [0 0.5 1];  % y direction
% sIntPntsRef{1} = [0 0.5 1];  % x direction
% sIntPntsRef{2} = [0 0.5 1];  % y direction
% sIntPntsBarRef{1} = [0 0.25 0.5 0.75 1];  % x direction
% sIntPntsBarRef{2} = [0 0.25 0.5 0.75 1];  % y direction
sIntPntsRef{1} = [0 0.5 1];  % x direction
sIntPntsRef{2} = [0 0.5 1];  % y direction
sIntPntsBarRef{1} = [0 1/6 2/6 0.5 4/6 5/6 1];  % x direction
sIntPntsBarRef{2} = [0 1/6 2/6 0.5 4/6 5/6 1];  % y direction
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
% compute interpolation points
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

% evalute the function at the interpolation Points
val = cell(numIntPnts, 1);
for pntCnt = 1:numIntPnts
  val{pntCnt} = func(sIntPntsList(pntCnt, 1), sIntPntsList(pntCnt, 2));
end

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
%   c = R \ (Q' * b);
%   Vinv{dimCnt} = inv(V);
end

% VinvBar = cell(length(sIntPntsBar));
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
        val{pntCnt} * poly{1}(pow1Cnt) * ...
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
        val{pntCnt} * polyBar{1}(pow1Cnt) * ...
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
        val{pntCnt} * poly{1}(pow1Cnt) * ...
        poly{2}(pow2Cnt);
    end
  end
end


% solve with explicite parameter dependence
sTest = cell(2, 1);
sTest{1} = 0:0.05:1;
sTest{2} = 0:0.05:1;
% build matrices and solve
s11Test = zeros(length(sTest{1}), length(sTest{2}));
for s1Cnt = 1:length(sTest{1})
  for s2Cnt = 1:length(sTest{2})
    sAct = [sTest{1}(s1Cnt) sTest{2}(s2Cnt)];
%     disp(sAct);
    fNow = 0;
    % REVISIT: fast hack to get nonzero pattern
%     sysMatNow = parMat{1};
%     sysMatNow = sysMatNow - parMat{1};
    for rowCnt = 1:size(finalPoly, 1)
      pow = 1;
      for parCnt = 1:size(finalPoly, 2)
        pow = pow * sAct(parCnt)^finalPoly(rowCnt, parCnt);
      end
      fNow = fNow + coeffPoly(rowCnt, :) * pow ;
    end
    s11Test(s1Cnt, s2Cnt) = fNow;
  end
end

figure;
surf(sTest{2}, sTest{1}, abs(s11Test));



