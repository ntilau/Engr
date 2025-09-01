% Test of projection algorithm
close all;
clear all;

dim = 4;
dimRed = 3;

A = rand(dim,dim);
X = rand(dim,dimRed);
proj = X'*A*X

projOuter = zeros(dimRed,dimRed);
for k=1:dim
    for l=1:dim
        projOuter = projOuter + A(k,l)*X(k,:)'*X(l,:);
    end
end
projOuter



mA = [1+4j 7+4j -13+3j -6+j; 7+4j 2+5j  -3+2j 5; 
    -13+3j -3+2j 3+6j 4-j; -6+j 5 4-j 4+7j]

mX = [2+3j 3+4j 4+5j 5+6j; -5+4j 33+9j -11+3j 7+5j; -8+9j 4+2j -2+j 17+2j]
mX = mX.';

mX'*mA*mX

projOuter = zeros(dimRed,dimRed);
for k=1:dim
    for l=1:dim
        rankOneUpdate = mA(k,l)*mX(k,:)'*mX(l,:);
        projOuter = projOuter + rankOneUpdate;
    end
end
projOuter