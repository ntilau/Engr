% This script tests the Serendipity elements of higher order
close all;
clear all;

set(0,'DefaultFigureWindowStyle','docked');

% Lagrange interpolation in x direction
numPnts = 7;
delta = 1/(numPnts - 1);
x = [0 delta (3 * delta) (5 * delta) (6 * delta)];
y = [0 delta (5 * delta) (6 * delta)];
bx = [0 0 1 0 0].';
by = [0 0 1 0].';

Vx = zeros(length(x), length(x));
for xCnt = 1:length(x)
  for powerCnt = 1:length(x)
    Vx(xCnt, powerCnt) = x(xCnt)^(powerCnt - 1);
  end
end
cx = Vx \ bx;
% [Qx Rx] = qr(Vx);
% cxTest = Rx \ (Qx' * bx);

Vy = zeros(length(y), length(y));
for yCnt = 1:length(y)
  for powerCnt = 1:length(y)
    Vy(yCnt, powerCnt) = y(yCnt)^(powerCnt - 1);
  end
end
cy = Vy \ by;

finalPoly = [];
maxOrder = length(x) + length(y) - 2;
numParams = 2;
for k = 0:maxOrder
  finalPoly = rec(numParams, k, finalPoly, 0, 1);
end
coeffPoly = zeros(size(finalPoly, 1), 1);

for xCnt = 1:length(x)
  for yCnt = 1:length(y)
    rowNow = [(xCnt - 1) (yCnt - 1)]; 
    rowPos = findRowInMat(rowNow, finalPoly);
    coeffPoly(rowPos) = coeffPoly(rowPos) + cx(xCnt) * cy(yCnt);        
  end
end

xTest = 0:0.01:1;
yTest = 0:0.01:1;
fTest = zeros(length(xTest), length(yTest));

for s1Cnt = 1:length(xTest)
  for s2Cnt = 1:length(yTest)
    sAct = [xTest(s1Cnt) yTest(s2Cnt)];
    for rowCnt = 1:size(finalPoly, 1)
      pow = 1;
      for parCnt = 1:size(finalPoly, 2)
        pow = pow * sAct(parCnt)^finalPoly(rowCnt, parCnt);
      end
      fTest(s1Cnt, s2Cnt) = fTest(s1Cnt, s2Cnt) + coeffPoly(rowCnt) * pow;
    end
  end
end

surf(xTest, yTest, fTest);

% plot one dimensional Lagrange polynomials
fTestX = zeros(1, length(xTest));
for powerCnt = 1:length(x)
  fTestX = fTestX + cx(powerCnt) * xTest.^(powerCnt - 1);
end
figure;
plot(xTest, fTestX);
grid;

fTestY = zeros(1, length(yTest));
for powerCnt = 1:length(y)
  fTestY = fTestY + cy(powerCnt) * yTest.^(powerCnt - 1);
end
figure;
plot(yTest, fTestY);
grid;


