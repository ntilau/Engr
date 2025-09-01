function sse = costFunDebyeFit(params, freq, Data)

epsInf = params(1);
epsZero = params(2);
tauE = params(3);

for k=1:length(freq)
  epsF(k) = epsInf + (epsZero-epsInf)./(1+j*2*pi*freq(k)*tauE);
end

Error_Vector = epsF-Data;
% When curve fitting, a typical quantity to minimize is the sum 
% of squares error
sse = sum(abs(Error_Vector) .^ 2);
% sse = sum(abs(imag(Error_Vector)) .^ 2);

