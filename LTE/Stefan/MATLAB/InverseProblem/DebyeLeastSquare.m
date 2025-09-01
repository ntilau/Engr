% Computation of permittivity from Debye model

close all;
clear all;

global freq epsRealRef epsImagRef;

fileNameMatFile = 'G:\invProblems\epsData_OrcerCeps10.txt';
[freq, epsRealRef, epsImagRef] = readEpsFile(fileNameMatFile)
epsRef = epsRealRef+j*epsImagRef;

figure;
plot(freq, epsImagRef);
hold;
grid;

parStart = [10,10,1e-9]; % Make a starting guess at the solution

parEst = lsqcurvefit(@funDebyeLeastSquare, parStart, freq, epsRef)

% check the results
epsInf = parEst(1);
epsZero = parEst(2);
tauE = parEst(3);
for k=1:length(freq)
  epsF(k) = epsInf + (epsZero-epsInf)./(1+j*2*pi*freq(k)*tauE);
end

plot(freq, imag(epsF), 'Color', 'red')


% check the results
epsInf = real(parEst(1));
epsZero = real(parEst(2));
tauE = real(parEst(3));
for k=1:length(freq)
  epsF(k) = epsInf + (epsZero-epsInf)./(1+j*2*pi*freq(k)*tauE);
end

plot(freq, imag(epsF), 'Color', 'green')
