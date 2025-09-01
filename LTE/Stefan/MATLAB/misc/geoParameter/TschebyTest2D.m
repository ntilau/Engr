% This script tests the properties of Tschebyscheff Approximation
% close all;
clear all;

set(0,'DefaultFigureWindowStyle','docked');

% function defined on interval [a,b]
a1 = -1;
b1 = +1;
a2 = -1;
b2 = +1;
func = @(x, y) (sin(x) * sin(y));

% number of interpolation points
n1 = 8;
n2 = 8;
dimLow = 4;

% take arbitrary interval into accout, not only [-1,1]
bma1 = 0.5 * (b1 - a1);
bpa1 = 0.5 * (b1 + a1);
bma2 = 0.5 * (b2 - a2);
bpa2 = 0.5 * (b2 + a2);

% evalute the function at the zeros of the n-th Tschebyscheff polynomial
y1 = cos(pi * ((1:n1) - 0.5) / n1);
y2 = cos(pi * ((1:n2) - 0.5) / n2);
f = zeros(length(y1), length(y2));
for y2Cnt = 1:length(y2)
  for y1Cnt = 1:length(y1)
    f(y1Cnt, y2Cnt) = func(y1(y1Cnt) * bma1 + bpa1, ...
      y2(y2Cnt) * bma2 + bpa2);
  end
end

% compute coefficent matrix c of the Tschebyscheff polynomials
c2 = tschebyCoeff2d(f);
% fac1 = 2 / n1;
% fac2 = 2 / n2;
% c1 = zeros(n1, n2);
% for k = 1:n2
%   for j = 1:n1
%     c1(k, j) = fac1 * sum(f(k, :) .* (cos(pi * (j - 1) ...
%       * ((1:n1) - 0.5) / n1)));
%   end
% end
% 
% c2 = zeros(n1, n2);
% for j = 1:n1
%   for k = 1:n2
%     c2(k, j) = fac2 * sum(c1(:, j).' .* (cos(pi * (k - 1) ...
%       * ((1:n2) - 0.5) / n2)));
%   end
% end

x1 = a1:0.1:b1;
x2 = a2:0.1:b2;
t1 = zeros(length(x1), n2);
for j = 1:n1
  t1(:, j) = evalTscheby(c2(:, j), a1, b1, x1);
end
t2 = zeros(length(x1), length(x2));
for k = 1:size(t1, 1)
  t2(k, :) = evalTscheby(t1(k, :), a2, b2, x2);
end

% back conversion into polynomials 1, x, y, x^2, ....
% order (first x then y or vice versa) in wich backConvertTscheby 
% is called doesn't make a difference
d1 = zeros(n1, n2);
for k = 1:n1
  d1(k, :) = backConvertTscheby(a2, b2, c2(k, :));
end
d2 = zeros(n1, n2);
for j = 1:n2
  d2(:, j) = backConvertTscheby(a1, b1, d1(:, j));
end
display(d2);

% plot functions
fRes = zeros(length(x1), length(x2));
for x2Cnt = 1:length(x2)
  for x1Cnt = 1:length(x1)
    fRes(x1Cnt, x2Cnt) = func(x1(x1Cnt), x2(x2Cnt));
  end
end

figure;
surf(x2, x1, fRes);
figure;
surf(x2, x1, t2);
% axis([a1 b1 a2 b2 -1 1]);

% plot magnitude of error
figure;
surf(x2, x1, abs(fRes - t2));

% approximation of lower order
c2Low = c2(1:dimLow, 1:dimLow);
t1Low = zeros(length(x1), dimLow);
for j = 1:dimLow
  t1Low(:, j) = evalTscheby(c2Low(:, j), a1, b1, x1);
end
t2Low = zeros(length(x1), length(x2));
for k = 1:size(t1Low, 1)
  t2Low(k, :) = evalTscheby(t1Low(k, :), a2, b2, x2);
end

% plot functions
figure;
surf(x2, x1, t2Low);
figure;
surf(x2, x1, abs(fRes - t2Low));


