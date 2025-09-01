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

parStart = rand(1,3); % Make a starting guess at the solution

% Now, we can call FMINSEARCH:
options = optimset('fminsearch');   % Use FMINSEARCH defaults 
parEst = fminsearch(@costFunDebyeFit, parStart, options, freq, epsRef);

parEst = [10.0, 10.3, 1e-10]
% check the results
epsInf = parEst(1);
epsZero = parEst(2);
tauE = parEst(3);
for k=1:length(freq)
  epsF(k) = epsInf + (epsZero-epsInf)./(1+j*2*pi*freq(k)*tauE);
end

plot(freq, imag(epsF), 'Color', 'red')




% function Estimates = fitcurvedemo
% % FITCURVEDEMO
% % Fit curve to data where user chooses equation to fit.
%    
% % Define function and starting point of fitting routine.
% fun = @expfun;
% Starting = rand(1, 2);
%   
% % First, we create the data.
% t = 0:.1:10;    t=t(:);    % to make 't' a column vector
% Data = 40 * exp(-.5 * t) + randn(size(t));
% m = [t Data];
%   
% % Now, we can call FMINSEARCH:
% options = optimset('fminsearch');   % Use FMINSEARCH defaults 
% Estimates = fminsearch(fun, Starting, options, t, Data);
% 
% % To check the fit
% plot(t, Data, '*')
% hold on
% plot(t, Estimates(1) * exp(-Estimates(2) * t), 'r')
% xlabel('t')
% ylabel('f(t)')
% title(['Fitting to function ', func2str(fun)]);
% legend('data', ['fit using ', func2str(fun)])
% hold off
% 
% % ----------------------------------------------------------
% 
% function sse = expfun(params, t, Data)
% % Accepts curve parameters as inputs, and outputs fitting the
% % error for the equation y = A * exp(-lambda * t);
% A = params(1);
% lambda = params(2);
% 
% Fitted_Curve = A .* exp(-lambda * t);
% Error_Vector = Fitted_Curve - Data;
% 
% % When curve fitting, a typical quantity to minimize is the sum 
% % of squares error
% sse = sum(Error_Vector .^ 2);
