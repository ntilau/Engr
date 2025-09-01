% This script tests the properties of Tschebyscheff Approximation
close all;
clear all;

set(0,'DefaultFigureWindowStyle','docked');

% function defined on interval [a,b]
a = -2;
b = +2;
func = @(x) sin(x);

% number of interpolation points
n = 8;

% take arbitrary interval into accout, not only [-1,1]
bma = 0.5 * (b - a);
bpa = 0.5 * (b + a);

% evalute the function at the zeros of the n-th Tschebyscheff polynomial
y = cos(pi * ((1:n) - 0.5) / n);
f = func(y * bma + bpa);

% compute coefficent vector c of the Tschebyscheff polynomials
fac = 2 / n;
c = zeros(n, 1);
for j = 1:n
  c(j) = fac * sum(f .* (cos(pi * (j - 1) * ((1:n) - 0.5) / n)));
end

c
f

x = a:0.01:b;
t = evalTscheby(c, a, b, x);

% approximation of lower order
c1 = c(1:4);
t1 = evalTscheby(c1, a, b, x);

% back conversion in polynomials 1, x, x^2, ....
d = backConvertTscheby(a, b, c);
p1 = zeros(1, length(x));
for powerCnt = 0:(length(d) - 1)
  p1 = p1 + d(powerCnt + 1) * x.^(powerCnt);
end

% plot functions
figure;
plot(x, t);
grid;
hold;
fun = func(x);
plot(x, fun, 'r');
plot(x, t1, 'g');
plot(x, p1, 'k');

% plot magnitude of error
figure;
semilogy(x, abs(fun - t));
grid;
hold;
semilogy(x, abs(fun - t1), 'g');
semilogy(x, abs(fun - p1), 'k');


