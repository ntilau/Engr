close all;
clear;

set(0,'DefaultFigureWindowStyle','docked');

order = 10;
fontsize = 12;
linewidth = 1.0;
modelName = 'C:\Ortwin\coax2_3e+009_MU_RELATIVE_74_(4,0)_10\';

impedanceFlag = true;
linFreqParamFlag = true;

buildRedModel(modelName, order, linFreqParamFlag);
% buildRedModelInterpTransp(modelName, order, linFreqParamFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag);
% fNameSpara = [modelName 'S_f_1000000000_4500000000_101_MU_RELATIVE_74_1_7_101.txt'];

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);

%% plot results
figHandle = figure;
set(figHandle,'color','w');

% two parameter plot
pos = 1;
nonOnePos = find(numParameterPnts(2:end) ~= 1) + 1;
freqs = zeros(numParameterPnts(1),1);
matVals = zeros(numParameterPnts(2),1);
sVal = zeros(numParameterPnts(nonOnePos),numParameterPnts(1));
for fCnt = 1:numParameterPnts(1)
  for pCnt = 1:numParameterPnts(nonOnePos)
    freqs(fCnt) = parameterVals(1,pos);
    matVals(pCnt) = parameterVals(2,pos);
    sVal(pCnt, fCnt) = sMatrices{pos}(1, 1);
    pos = pos + 1;
  end
end
surf(freqs*1e-9, matVals, abs(sVal));
AZ = -1.4250e+002;
EL = 40;
view(AZ, EL);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('\mu_{r}', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
%axis([1 4.5 1 7 0 0.6]);
%title('\epsilon_{r2} = 8', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);
title('', 'FontSize', fontsize);


%% analytical solution
eta0 = 376.73031346177066;
c = 299792458.00000000;
pi_ = 3.1415926535897931;

% analytical calculation of reflection coefficent
len1=0.05;
len2=0.025;

% less points for better b/w plot
mus = 1:6e-2:7;
freqsBack = freqs;
freqs = 1e9:35000000:4.5e9;

k0 = 2*pi_*freqs/c;
zW1 = ones(length(mus), length(k0)).*eta0;
zW2 = ones(length(mus), length(k0)).*(eta0/(2));

for row = 1:length(mus)
    zW2(row,:) = zW2(row,:).*sqrt(mus(row));
end

gamma1 = zeros(length(mus), length(k0));
gamma2 = zeros(length(mus), length(k0));
for row=1:length(mus)
    gamma1(row,:) = j*k0.';
    for col=1:length(k0)
        gamma2(row,col) = j*k0(col)*2.*sqrt(mus(row));
    end
end

rho0 = (zW1-zW2)./(zW1+zW2).*ones(length(mus), length(k0));
rhoLen = rho0.*exp(2*gamma2*len1);
zLen = zW2.*(1+rhoLen)./(1-rhoLen);

rho0_1 = (zLen - zW1)./(zLen + zW1);
rhoLen_1 = rho0_1.*exp(2*gamma1*len2);


%% Comparison between analytical and numerical solution

figHandle = figure;
set(figHandle,'color','w');
surf(freqs*1e-9, matVals, abs(sVal - conj(rhoLen_1)));
AZ = -119.00;
EL = 68.00;
view(AZ, EL);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('Relative magnetic permeability', 'FontSize', fontsize);
zlabel('|Error S_{11}|', 'FontSize', fontsize);
% axis([1 4.5 1 7 1e-6 1]);
set(gca,'FontSize',fontsize);


%% Solve original model

fNameSpara = solveUnredModel(modelName, impedanceFlag);
% fNameSpara = [modelName 'S_f_160000000_240000000_11.txt'];

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);

sValFull = zeros(numParameterPnts(1), 1);
fFull = zeros(numParameterPnts(1), 1);
for k = 1 : numParameterPnts(1)
  fFull(k) = parameterVals(1, k);
  sValFull(k) = sMatrices{k}(1, 1);
end
figHandle = figure;
set(figHandle, 'color', 'w');
plot(fFull * 1e-9, abs(sValFull), 'rd', 'LineWidth', linewidth);
grid;



