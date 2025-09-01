% Computation of permittivity from Debye model

close all;
clear all;

global freq epsRealRef epsImagRef;

fileNameMatFile = 'G:\invProblems\epsData_OrcerCeps10.txt';
[freq, epsRealRef, epsImagRef] = readEpsFile(fileNameMatFile)

figure;
plot(freq, epsImagRef);
hold;
grid;

parStart = [10,10,1e-9]; % Make a starting guess at the solution
options = optimset('LargeScale','off', 'TolFun',1e-9, 'TolX',1e-20);

% 0 <= real(mu) <= 15
% -10 <= imag(mu) <= 0
lowBndMu = [5, 5, 0];
upBndMu = [15, 15, 3e-6];

[parEst, fval] = fmincon(@costFunDebye,parStart,[],[],[],[],lowBndMu,...
  upBndMu,[],options)

% check the results
epsInf = parEst(1);
epsZero = parEst(2);
tauE = parEst(3);
for k=1:length(freq)
  epsF(k) = epsInf + (epsZero-epsInf)./(1+j*2*pi*freq(k)*tauE);
end

plot(freq, imag(epsF), 'Color', 'red')
