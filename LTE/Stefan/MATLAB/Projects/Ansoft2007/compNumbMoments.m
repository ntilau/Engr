
N = 5;  % number of parameters
m = 9;  % order of moments
numMom = 0;  % number of moments
for k = 0:m
  numMom = numMom + factorial(k + N - 1) / factorial(k) / factorial(N - 1);
end
display(numMom);

numTotalWCAWE_Vec = (m + 1) * factorial(m + N - 1) / factorial(m) / ...
  factorial(N - 1);
display(numTotalWCAWE_Vec);


