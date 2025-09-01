
close all;
clear all;

pi_ = 3.141592653589793238;
c0 = 299792.458e3;
mu0 = 4e-7 * pi_;
eps0 = 1.0 / mu0 / c0 / c0;
eta0 = mu0 * c0;

diagElem = 1/pi/eps0*log(sqrt(2)+1);
offDiag = 1/4/pi/eps0;
diagTrans = offDiag/sqrt(2);

% A = [ diagElem offDiag offDiag diagTrans;
%       offDiag diagElem diagTrans offDiag;
%       offDiag diagTrans diagElem offDiag;
%       diagTrans offDiag offDiag diagElem; ]

A2 = ones(8)*offDiag;
for k = 1:8
  A2(k,k) = diagElem;
end
scaleMat = ones(8);
sd2 = 1/sqrt(2);
sd3 = 1/sqrt(3);
scaleMat = [1, 1, 1, sd2, 1, sd2, sd2, sd3;
            1, 1, sd2, 1, sd2, 1, sd3, sd2;
            1, sd2, 1, 1, sd2, sd3, 1, sd2;
            sd2, 1, 1, 1, sd3, sd2, sd2, 1;
            1, sd2, sd2, sd3, 1, 1, 1, sd2;
            sd2, 1, sd3, sd2, 1, 1, sd2, 1;
            sd2, sd3, 1, sd2, 1, sd2, 1, 1;
            sd3, sd2, sd2, 1, sd2, 1, 1, 1];
A2 = A2.*scaleMat;
          
v = [-1; -1; -1; -1; 1; 1; 1; 1];
sigma = A2\v;
cap = (sigma(3)+sigma(4))/2;
capAnalyt = eps0*2;

capNum = platCond3d(1, 1, 0.1, 0.025)
