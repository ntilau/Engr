function cost = costFunDebye(parVec)

global freq epsRealRef epsImagRef;

epsInf = parVec(1);
epsZero = parVec(2);
tauE = parVec(3);

for k=1:length(freq)
  epsF(k) = epsInf + (epsZero-epsInf)./(1+j*2*pi*freq(k)*tauE);
end

cost = sum(abs(epsRealRef+j*epsImagRef-epsF).^2);
% cost = sum(abs(epsImagRef-imag(epsF)).^2);


