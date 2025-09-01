% Computation of permittivity from Debye model

% close all;
clear all;

global freq epsRealRef epsImagRef;

fileNameMatFile = 'G:\invProblems\epsData_OrcerCeps10.txt';
[freq, epsRealRef, epsImagRef] = readEpsFile(fileNameMatFile)

figure;
plot(freq, epsImagRef);
hold;
grid;

p = polyfit(freq, epsImagRef, 2)
epsF = p(3)+p(2)*freq+p(1)*(freq.^2);

% [p,S,mu] = polyfit(freq, epsImagRef, 2)
% epsF = p(3)+p(2)*(freq-mu(1))/mu(2)+p(1)*(((freq-mu(1))/mu(2)).^2);
plot(freq, (epsF), 'Color', 'red')


% parStart = [-1,-1,-1]; % Make a starting guess at the solution
% options = optimset('LargeScale','off');
% options = optimset('TolFun',1e-10000);
% 
% lowBndMu = [-10, -10, -10];
% upBndMu = [10, 10, 10];
% 
% 
% [parEst, fval] = fmincon(@costFunQuadratic,parStart,[],[],[],[],lowBndMu,...
%   upBndMu,[],options)
% 
% % check the results
% epsInf = parEst(1);
% epsZero = parEst(2);
% tauE = parEst(3);
% for k=1:length(freq)
%   epsF(k) = epsInf + (epsZero-epsInf)./(1+j*2*pi*freq(k)*tauE);
% end
%freq = freq*1e9

