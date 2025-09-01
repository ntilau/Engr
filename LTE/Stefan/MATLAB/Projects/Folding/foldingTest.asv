close all;
clear;

addpath(genpath('C:\work\Matlab'));
set(0, 'DefaultFigureWindowStyle', 'docked');


%% Generate polynomially parameterized system

dim = 8;
numParams = 1;
order = 2;

% construct matrix with the ordering of the coefficients
permutMat = [];
for orderCnt = 0 : order
  permutMat = rec(numParams, orderCnt, permutMat, 0, 1);
end

sys = cell(size(permutMat, 1), 1);
for matCnt = 1 : length(sys)
  sys{matCnt} = randn(dim);
end

b = randn(dim, 1);
c = randn(dim, 1);


%% Linearize system

permutMatLin = [];
for orderCnt = 0 : 1
  permutMatLin = rec(numParams, orderCnt, permutMatLin, 0, 1);
end
linSys = cell(length(permutMatLin), 1);
% one parameter case
linSys{1} = [zeros(dim) eye(dim); -inv(sys{3}) * sys{1} -inv(sys{3}) * sys{2}];
linSys{2} = eye(2 * dim);
linB = [zeros(dim, 1); inv(sys{3}) * b];
linC = [c; zeros(dim, 1)];


%% Test linearized model

s = 4;
y = c.' * ((sys{1} + s * sys{2} + s ^ 2 * sys{3}) \ b);
display(y);
yLin = linC.' * ((s * linSys{2} - linSys{1}) \ linB);
display(yLin);


