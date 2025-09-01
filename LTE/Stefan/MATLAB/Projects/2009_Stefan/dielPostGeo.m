close all;
clear;

addpath(genpath('C:\Work\Matlab'));
set(0,'DefaultFigureWindowStyle','docked');
fontsize = 24;
linewidth = 2.5;

c0 = 299792.458e3;

Spoly = load('C:\work\examples\Stefan\S_poly.mat');
Tpoly = load('C:\work\examples\Stefan\T_poly.mat');
Rhs = load('C:\work\examples\Stefan\rhs.mat');
Cl = load('C:\work\examples\Stefan\C.mat');
IndMat = load('C:\work\examples\Stefan\ind.mat');

scalGeo = 1.5e-3;
for iMat = 1:length(Spoly.CoeffStiffMat)
  Spoly.CoeffStiffMat{iMat} = scalGeo^(iMat-1) * Spoly.CoeffStiffMat{iMat};
  Tpoly.CoeffMassMat{iMat} = scalGeo^(iMat-1) * Tpoly.CoeffMassMat{iMat};
end

fExpRhs = 20e9;
kExpRhs = (2*pi*fExpRhs/c0);
tmFlag = false;


%% build unreduced model
% construct matrix with the ordering of the coefficients
permutMat = [];   % first column describes frequency dependence
maxOrder = length(Spoly.CoeffStiffMat);% maximum order of parameter dependence
% maxOrder = length(Spoly.CoeffStiffMat)+1;% maximum order of parameter dependence
for k = 0:maxOrder
  permutMat = rec(2, k, permutMat, 0, 1);
end

% build unreduced model with expansion point zero
sysMat = cell(size(permutMat,1),1);
for iMat = 1:length(Spoly.CoeffStiffMat)
  row = [0 iMat-1];
  rowNum = findRowInMat(row, permutMat);
  sysMat{rowNum} = Spoly.CoeffStiffMat{iMat}(~IndMat.ind,~IndMat.ind) ...
    - kExpRhs^2*Tpoly.CoeffMassMat{iMat};
end

for iMat = 1:length(Tpoly.CoeffMassMat)
  row = [1 iMat-1];
%   row = [2 iMat-1];
  rowNum = findRowInMat(row, permutMat);
%   sysMat{rowNum} = -Tpoly.CoeffMassMat{iMat};
  sysMat{rowNum} = -kExpRhs^2*Tpoly.CoeffMassMat{iMat};
end

Model.A = sysMat;
B = zeros(size(sysMat{1},1),2);
B(:,1) = Rhs.rhsMat{1}(~IndMat.ind);
B(:,2) = Rhs.rhsMat{2}(~IndMat.ind);
Model.B = cell(size(permutMat,1),1);
Model.B{1} = B;
Model.C = cell(size(permutMat,1),1);
Model.C{1} = Cl.C(:,~IndMat.ind);
Model.permutMat = permutMat;


%% solve unreduced model

fCutOff = 14989622745.6210;
f = linspace(15e9, 25e9, 101);
parPnts = zeros(length(f),2);
% parPnts(:,1) = (2*pi*f/c0).^2;
parPnts(:,1) = (2*pi*f/c0).^2 ./ (2*pi*fExpRhs/c0).^2 - 1;

scaleRHS = calcScaleRHS(fExpRhs, f(1), f(end), length(f), fCutOff, tmFlag);

res = solvePolyModel(Model, parPnts);
resFull = zeros(length(res),1);
for iPnt = 1:length(res)
  P = eye(2,2);
  for k = 1:2
    P(k,k) = sqrt(scaleRHS{1}(iPnt)); % frequency dependent normalization
  end
  mZ = P * res{iPnt} * P;
  sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
  resFull(iPnt) = sMat(1,1);
end
figure;
plot(f, 20*log10(abs(resFull)));


%% create ROM
order = 10;
% fExp = 20e9;
expPnt = [0 0];
orthoFlag = true;
pardisoFlag = false;

ModelShifted = shiftExpPntABCD(Model, expPnt);  % shift expansion point
[Fact.L, Fact.U, Fact.P, Fact.Q] = lu(ModelShifted.A{1});
K = compInputKrySpaceABCD(ModelShifted, Fact, order, orthoFlag, pardisoFlag);
clear Fact;
RedModel = projModelABCD(Model, K.', K);

%save reduced model
% fName = ['C:\work\examples\CST\Andreas\rom_' num2str(expPnt(1)) '_' ...
%   num2str(expPnt(2)) '_o_' num2str(order)]; 
% save(fName, 'RedModel');


%% solve shifted unreduced model
% f = linspace(15e9, 25e9, 101);
% expPnt = [(2*pi*fExp/c0)^2 1];
% ModelShifted = shiftExpPntABCD(Model, expPnt);  % shift expansion point
% % parPnts = zeros(length(f),2);
% parPnts = -1*ones(length(f),2);
% parPnts(:,1) = (2*pi*f/c0).^2 - (2*pi*fExp/c0)^2;
% res = solvePolyModel(ModelShifted, parPnts);
% resRed = zeros(length(res),1);
% for iPnt = 1:length(res)
%   P = eye(2,2);
%   for k = 1:2
%     P(k,k) = sqrt(scaleRHS{1}(iPnt)); % frequency dependent normalization
%   end
%   mZ = P * res{iPnt} * P;
%   sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
%   resRed(iPnt) = sMat(1,1);
% end
% figure;
% plot(f, 20*log10(abs(resRed)));
% 
% figure;
% semilogy(f, abs(resFull-resRed));


%% solve reduced model

fCutOff = 14989622745.6210;
f = linspace(15e9, 25e9, 101);
parPnts = zeros(length(f),2);
parPnts(:,1) = (2*pi*f/c0).^2 ./ (2*pi*fExpRhs/c0).^2 - 1;


scaleRHS = calcScaleRHS(fExpRhs, f(1), f(end), length(f), fCutOff, tmFlag);

res = solvePolyModel(RedModel, parPnts);
resRed = zeros(length(res),1);
for iPnt = 1:length(res)
  P = eye(2,2);
  for k = 1:2
    P(k,k) = sqrt(scaleRHS{1}(iPnt)); % frequency dependent normalization
  end
  mZ = P * res{iPnt} * P;
  sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
  resRed(iPnt) = sMat(1,1);
end
figure;
plot(f, 20*log10(abs(resRed)));

figure;
semilogy(f, abs(resFull-resRed));







%% build single paramter unreduced model
% construct matrix with the ordering of the coefficients
permutMat = [];   % first column describes frequency dependence
% maxOrder = 1;
maxOrder = 2;
for k = 0:maxOrder
  permutMat = rec(1, k, permutMat, 0, 1);
end

% build unreduced model with expansion point zero
sysMat = cell(size(permutMat,1),1);
sysMat{1} = Spoly.CoeffStiffMat{1}(~IndMat.ind,~IndMat.ind);
% sysMat{2} = -Tpoly.CoeffMassMat{1};
sysMat{3} = -Tpoly.CoeffMassMat{1};

Model.A = sysMat;
B = zeros(size(sysMat{1},1),2);
B(:,1) = Rhs.rhsMat{1}(~IndMat.ind);
B(:,2) = Rhs.rhsMat{2}(~IndMat.ind);
Model.B = cell(size(permutMat,1),1);
Model.B{1} = B;
Model.C = cell(size(permutMat,1),1);
Model.C{1} = Cl.C(:,~IndMat.ind);
Model.permutMat = permutMat;


%% solve unreduced model

fExpRhs = 20e9;
fCutOff = 14989622745.6210;
f = linspace(15e9, 25e9, 101);
parPnts = zeros(length(f),1);
parPnts(:,1) = (2*pi*f/c0).^2;
% parPnts(:,1) = (2*pi*f/c0);

scaleRHS = calcScaleRHS(fExpRhs, f(1), f(end), length(f), fCutOff);

res = solvePolyModel(Model, parPnts);
resFull = zeros(length(res),1);
for iPnt = 1:length(res)
  P = eye(2,2);
  for k = 1:2
    P(k,k) = sqrt(scaleRHS{1}(iPnt)); % frequency dependent normalization
  end
  mZ = P * res{iPnt} * P;
  sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
  resFull(iPnt) = sMat(1,1);
end
figure;
plot(f, 20*log10(abs(resFull)));


%% create single parameter ROM
order = 20;
fExp = 18e9;
expPnt = (2*pi*fExp/c0)^2;
% expPnt = 2*pi*fExp/c0;
orthoFlag = true;
pardisoFlag = false;

ModelShifted = shiftExpPntABCD(Model, expPnt);  % shift expansion point
[Fact.L, Fact.U, Fact.P, Fact.Q] = lu(ModelShifted.A{1});
K = compInputKrySpaceABCD(ModelShifted, Fact, order, orthoFlag, pardisoFlag);
clear Fact;
RedModel = projModelABCD(Model, K.', K);

%save reduced model
% fName = ['C:\work\examples\CST\Andreas\rom_' num2str(expPnt(1)) '_' ...
%   num2str(expPnt(2)) '_o_' num2str(order)]; 
% save(fName, 'RedModel');


%% solve single parameter reduced model

fCutOff = 14989622745.6210;
fExpRhs = 20e9;
f = linspace(15e9, 25e9, 101);
parPnts = zeros(length(f),1);
parPnts(:,1) = (2*pi*f/c0).^2;
% parPnts(:,1) = 2*pi*f/c0;

scaleRHS = calcScaleRHS(fExpRhs, f(1), f(end), length(f), fCutOff);

res = solvePolyModel(RedModel, parPnts);
resRed = zeros(length(res),1);
for iPnt = 1:length(res)
  P = eye(2,2);
  for k = 1:2
    P(k,k) = sqrt(scaleRHS{1}(iPnt)); % frequency dependent normalization
  end
  mZ = P * res{iPnt} * P;
  sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
  resRed(iPnt) = sMat(1,1);
end
figure;
plot(f, 20*log10(abs(resRed)));

figure;
semilogy(f, abs(resFull-resRed));




%% build single paramter unreduced model -> geometry only
% construct matrix with the ordering of the coefficients
permutMat = [];   % first column describes frequency dependence
% maxOrder = 1;
maxOrder = 2;
for k = 0:maxOrder
  permutMat = rec(1, k, permutMat, 0, 1);
end

% build unreduced model with expansion point zero
fExp = 20e9;
kExp = 2*pi*fExp/c0;
sysMat = cell(size(permutMat,1),1);
sysMat{1} = Spoly.CoeffStiffMat{1}(~IndMat.ind,~IndMat.ind) - kExp^2 * ...
  Tpoly.CoeffMassMat{1};
sysMat{2} = Spoly.CoeffStiffMat{2}(~IndMat.ind,~IndMat.ind) - kExp^2 * ...
  Tpoly.CoeffMassMat{2};
sysMat{3} = Spoly.CoeffStiffMat{3}(~IndMat.ind,~IndMat.ind) - kExp^2 * ...
  Tpoly.CoeffMassMat{3};

Model.A = sysMat;
B = zeros(size(sysMat{1},1),2);
B(:,1) = Rhs.rhsMat{1}(~IndMat.ind);
B(:,2) = Rhs.rhsMat{2}(~IndMat.ind);
Model.B = cell(size(permutMat,1),1);
Model.B{1} = B;
Model.C = cell(size(permutMat,1),1);
Model.C{1} = Cl.C(:,~IndMat.ind);
Model.permutMat = permutMat;


%% solve unreduced model -> geometry only

fExpRhs = 20e9;
fCutOff = 14989622745.6210;
f = 20e9;
parPnts = (-0.0015:0.00005:0.0015).';

scaleRHS = calcScaleRHS(fExpRhs, f(1), f(end), length(f), fCutOff);

res = solvePolyModel(Model, parPnts);
resFull = zeros(length(res),1);
for iPnt = 1:length(res)
  P = eye(2,2);
  for k = 1:2
    P(k,k) = sqrt(scaleRHS{1}(1)); % frequency dependent normalization
  end
  mZ = P * res{iPnt} * P;
  sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
  resFull(iPnt) = sMat(1,1);
end
figure;
plot(parPnts, 20*log10(abs(resFull)));


%% create single parameter ROM -> geometry only
order = 20;
expPnt = 0;
orthoFlag = true;
pardisoFlag = false;

ModelShifted = shiftExpPntABCD(Model, expPnt);  % shift expansion point
[Fact.L, Fact.U, Fact.P, Fact.Q] = lu(ModelShifted.A{1});
K = compInputKrySpaceABCD(ModelShifted, Fact, order, orthoFlag, pardisoFlag);
clear Fact;
RedModel = projModelABCD(Model, K.', K);


%% solve single parameter reduced model -> geometry only

fCutOff = 14989622745.6210;
fExpRhs = 20e9;
f = 20e9;
parPnts = (-0.0015:0.00005:0.0015).';

scaleRHS = calcScaleRHS(fExpRhs, f(1), f(end), length(f), fCutOff);

res = solvePolyModel(RedModel, parPnts);
resRed = zeros(length(res),1);
for iPnt = 1:length(res)
  P = eye(2,2);
  for k = 1:2
    P(k,k) = sqrt(scaleRHS{1}(1)); % frequency dependent normalization
  end
  mZ = P * res{iPnt} * P;
  sMat = (mZ - eye(2)) \ (mZ + eye(2));  % Z -> S
  resRed(iPnt) = sMat(1,1);
end
figure;
plot(parPnts, 20*log10(abs(resRed)));

figure;
semilogy(parPnts, abs(resFull-resRed));


