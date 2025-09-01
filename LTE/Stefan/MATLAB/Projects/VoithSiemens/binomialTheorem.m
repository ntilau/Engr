function polynomial = binomialTheorem(s0, power)
% compute (s0 + alpha) ^ power

polynomial = zeros(power + 1, 1);
for powerCnt = 0 : power
  polynomial(powerCnt + 1) = nchoosek(power, powerCnt) * s0 ^ (power - powerCnt);
end
