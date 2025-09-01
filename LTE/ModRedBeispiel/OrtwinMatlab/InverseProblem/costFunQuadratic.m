function cost = costFunQuadratic(parVec)

global freq epsRealRef epsImagRef;

epsConst = parVec(1);
epsLin = parVec(2);
epsQuad = parVec(3);

for k=1:length(freq)
  epsF(k) = epsRealRef(k) + j*(epsConst+epsLin*freq(k)+epsQuad*freq(k).^2);
end

%cost = sum(abs(epsRealRef+j*epsImagRef-epsF).^2);
cost = sum(abs(epsImagRef-imag(epsF)).^2);


