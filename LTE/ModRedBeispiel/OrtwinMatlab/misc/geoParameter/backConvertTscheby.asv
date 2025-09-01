function d = backConvertTscheby(a, b, c)
% input parameters:
%    a = lower bound of interval
%    b = upper bound of interval
%    c = array containing coefficients of Tschebyscheff polynomials
%
% output parameter:
%    d = coefficients of polynomials 1, x, x^2, ...

n  = length(c);
d  = zeros(n, 1);
dd = zeros(n, 1);

d(1) = c(end);

for j = (length(c) - 2):-1:1
  for k = (n - j):-1:1
    sv = d(k+1);
    d(k + 1) = 2 * d(k) - dd(k + 1);
    dd(k + 1) = sv;
  end
  sv = d(1);
  d(1) = -dd(1) + c(j + 1);
  dd(1) = sv;
end

for j = (n - 1):-1:1
  d(j + 1) = d(j) - dd(j + 1);
end

d(1) = -dd(1) + 0.5 * c(1);

% take interval [a,b] into account
cnst = 2 / (b - a);
fac = cnst;
for j = 1:1:(n - 1)
  d(j + 1) = d(j + 1) * fac;
  fac = fac * cnst;
end
cnst = 0.5 * (a + b);
for j = 0:1:(n-2)
  for k = (n-2):-1:j
    d(k + 1) = d(k + 1) - cnst * d(k + 2);
  end
end
    

