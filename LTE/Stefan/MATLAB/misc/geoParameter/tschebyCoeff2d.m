function c2 = tschebyCoeff2d(f)
% This function computes the two dimensional Tschebysheff interpolation
% Input: f  = two dimensional array containing function values at the
%             Tschebysheff interpolation points
% Output: c2 = coefficients of two dimensional Tschebysheff polynomials.

[n1 n2] = size(f);
fac1 = 2 / n1;
fac2 = 2 / n2;
c1 = zeros(n1, n2);
for k = 1:n2
  for j = 1:n1
    c1(j, k) = fac1 * sum(f(:, k) .* (cos(pi * (j - 1) ...
      * ((1:n1) - 0.5) / n1)).');
  end
end

c2 = zeros(n1, n2);
for j = 1:n1
  for k = 1:n2
    c2(j, k) = fac2 * sum(c1(j, :) .* (cos(pi * (k - 1) ...
      * ((1:n2) - 0.5) / n2)));
  end
end