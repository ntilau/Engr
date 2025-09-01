function vals = funDebyeLeastSquare(parVec, freq)

epsInf = parVec(1);
epsZero = parVec(2);
tauE = parVec(3);

for k=1:length(freq)
  vals(k) = epsInf + (epsZero-epsInf)./(1+j*2*pi*freq(k)*tauE);
end


