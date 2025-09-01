close all;
clear;

addpath(genpath('C:\work\Matlab'));
set(0,'DefaultFigureWindowStyle','docked');
fontsize = 12;
linewidth = 1.0;
c0 = 299792.458e3;


%% our C++ MOR
% fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports\3d_500000_50_p2\S_f_100000_1e+006_1001.txt';
% fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports\3d_500000_50_p1\S_f_100000_1e+006_1001.txt';
% fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports\rj45_all_face_ports_pec\3d_500000_50\S_f_100000_1e+006_1001.txt';
fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports3\3d_6e+008_50\S_f_1e+008_1e+009_1001.txt';
% fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_51_fSweep_eps1_1_p1\S_f_1e+008_1e+009_1001.txt';
[parNames, numParPnts, parVals, sMats] = readscatmats(fNameSpara);
figHandle = figure;
set(figHandle,'color','w');
plot(parVals, abs(sMats{1,1}), 'b');
hold;


%% CST results
nPort = 8;
fMin = 0;
fMax = 1e9;
% path = 'C:\work\examples\CST\rj45_all_face_ports\resultsCST\';
path = 'C:\work\examples\CST\rj45_all_face_ports3\resultsCST\';
% path = 'C:\work\examples\CST\rj45_all_face_ports\resultsCSTwoLowFreqStab\';
data =  dlmread([path 'a1(1)1(1).sig'],' ',4,0);
f_scaling = dlmread([path 'a1(1)1(1).sig'],' ',[3 1 3 1]);
f_CST = data(:,1)*f_scaling;
clear data;
absS_CST = zeros(length(f_CST), nPort^2);
argS_CST = zeros(length(f_CST), nPort^2);
for iPort = 1 : nPort
    for jPort = 1 : nPort
        filenamea = ['a' num2str(iPort) '(1)' num2str(jPort) '(1).sig'];
        filenamep = ['p' num2str(iPort) '(1)' num2str(jPort) '(1).sig'];
        data = [dlmread([path filenamea],' ',4,1) dlmread([path filenamep],' ',4,1)];
        absS_CST(:,(iPort-1)*nPort + jPort) = data(:,1);
        argS_CST(:,(iPort-1)*nPort + jPort) = data(:,2);
    end
end
argS_CST = argS_CST / 180 * pi;
S_CST    = absS_CST .* exp(1i*argS_CST);
s11CST = S_CST(:,1);
plot(linspace(fMin,fMax,1001), abs(s11CST), 'r', 'LineWidth', linewidth);


%% our C++ MOR: PEC
% fNameSpara =
% 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_50\S_f_1e+008_1e+009_1001.txt';
% fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_51_fSweep_eps1_1\S_f_1e+008_1e+009_1001.txt';
% fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_51_fSweep_eps2p2_p1\S_f_1e+008_1e+009_1001.txt';
% fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_51_fSweep_eps1_1_p2\S_f_1e+008_1e+009_1001.txt';
fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_50_fSweep_eps1_2p2_p2\S_f_1e+008_1e+009_1001.txt';
[parNames, numParPnts, parVals, sMats] = readscatmats(fNameSpara);
figHandle = figure;
set(figHandle,'color','w');
plot(parVals, abs(sMats{1,1}), 'g');
hold;


%% EM_WaveSolver results
pathname = 'C:\work\examples\CST\rj45_all_face_ports\';
filename = 'sParam.s8p';
DUM = TouchStone2DUM(pathname, filename);
plot(DUM.f, abs(DUM.S{1,1}), 'kd', 'LineWidth', linewidth);


%% Load reference matrix
tTest = mmread('C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_51_raw_eps1_1\k^2 matrix.mm');
tTest = tTest(~dirMarker, ~dirMarker);
figure;
spy(tTest);
figure;
spy(tTest - SysMat(2).val - SysMat(3).val)
nnz(tTest - SysMat(2).val - SysMat(3).val)


%% Discrete Matlab sweep

% modelName = 'C:\work\examples\CST\rj45_all_face_ports\3d_500000_100_p1\';
% modelName = 'C:\work\examples\CST\rj45_all_face_ports\3d_500000_100_p2\';
% modelName = 'C:\work\examples\CST\rj45_all_face_ports\rj45_all_face_ports_pec\3d_500000_100\';
% modelName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_100\';
% modelName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(2.2,0)_101\';
modelName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_51_p2\';

fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[fExp,parNames,parValInExp,nLeftVecs,abcFlag] = readModParaTxt(fNameModRedTxt);
expWvNm = 2*pi*fExp/c0;
dirMarker = readFullVector([modelName 'dirMarker.fvec']);
[rhs, lVec] = readSystemVectors(modelName, nLeftVecs, dirMarker);
tic;
SysMat = readSystemMatrices(modelName, dirMarker);
toc;
freq = 1e8:9e8:1e9;
param(1).name = 'k0';
param(2).name = 'epsRel1';
rhsMat = zeros(length(rhs{1}), length(rhs));
for rhsCnt = 1:length(rhs)
    rhsMat(:,rhsCnt) = rhs{rhsCnt};
end
lVecMat = zeros(length(lVec), length(lVec{1}));
for lVecCnt = 1:length(lVec)
    lVecMat(lVecCnt,:) = lVec{lVecCnt};
end

fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);
scaleRHS = calcScaleRHS(fExp,freq(1),freq(end),length(freq),freqParam.fCutOff);

scatMat = cell(length(freq),1);
for fCnt = 1:length(freq)
    k0 = 2*pi*freq(fCnt)/c0;
    param(1).val = k0;
    param(2).val = 2.2;
    M = buildFemMatrix(SysMat, param);
    P = eye(nLeftVecs);
    for k = 1:nLeftVecs
        P(k,k) = sqrt(scaleRHS{k}(fCnt));   % frequency dependent normalization
    end
    sol = M\rhsMat;
    Z = P * (1i*lVecMat*sol) * P;
    scatMat{fCnt} = inv(Z-eye(nLeftVecs)) * (Z+eye(nLeftVecs));
end

s11Full = zeros(length(freq),1);
for fCnt = 1:length(freq)
    s11Full(fCnt) = scatMat{fCnt}(1,1);
end
plot(freq, abs(s11Full), 'ko', 'LineWidth', linewidth);


%% runtime test
fname = 'C:\work\examples\CST\rj45_all_face_ports\3d_500000_100_p2\k^2 matrix.mm';
tic;
A = MatrixMarketReader(fname);
toc;
tic;
B = mmread(fname);
toc;
nnz(A-B)

fname = 'C:\work\examples\CST\rj45_all_face_ports\3d_500000_100_p2\rhs_0.fvec';
tic;
a1 = readFullVector2(fname);
toc;
tic;
a2 = vectorReader(fname);
toc;

fname = 'C:\work\examples\CST\rj45_all_face_ports\3d_500000_50_p2\S_f_100000_1e+006_1001.txt';
% fname = 'C:\work\examples\CST\ppWG\3d_1e+007_50\S_f_1e+006_2e+007_201.txt';
% [parNames, numParPnts, parVals, sMats] = loadSmatrix(fname);
[parNames, numParPnts, parVals, sMats] = readscatmats(fname);
plot(parVals, abs(sMats{7,7}), 'r');

fname = 'C:\work\examples\coax\coax2\results\coax2_3e+009_MU_RELATIVE_74_(4,0)_10_stable_new\S_f_1e+009_4.5e+009_101_MU_RELATIVE_74_(1,0)_(7,0)_101.txt';
[parNames, numParPnts, parVals, sMats] = loadSmatrix(fname);
% two parameter plot
pos = 1;
nonOnePos = find(numParPnts(2:end) ~= 1) + 1;
freqs = zeros(numParPnts(1),1);
matVals = zeros(numParPnts(2),1);
sVal = zeros(numParPnts(nonOnePos),numParPnts(1));
for fCnt = 1:numParPnts(1)
    for pCnt = 1:numParPnts(nonOnePos)
        freqs(fCnt) = parVals(1,pos);
        matVals(pCnt) = parVals(2,pos);
        sVal(pCnt, fCnt) = sMats{pos}(1,1);
        pos = pos + 1;
    end
end
figHandle = figure;
set(figHandle,'color','w');
surf(freqs*1e-9, matVals, abs(sVal));

[parNames, numParPnts, parVals, sMats] = readscatmats(fname);
% two parameter plot
tic;
pos = 1;
nonOnePos = find(numParPnts(2:end) ~= 1) + 1;
freqs = zeros(numParPnts(1),1);
matVals = zeros(numParPnts(2),1);
sVal = zeros(numParPnts(nonOnePos),numParPnts(1));
for fCnt = 1:numParPnts(1)
    for pCnt = 1:numParPnts(nonOnePos)
        freqs(fCnt) = parVals(1,pos);
        matVals(pCnt) = parVals(2,pos);
        sVal(pCnt, fCnt) = sMats{1,1}(pos);
        pos = pos + 1;
    end
end
toc;
figHandle = figure;
set(figHandle,'color','w');
surf(freqs*1e-9, matVals, abs(sVal));


%% solveUnredModel results
modelName = 'C:\work\examples\CST\rj45_all_face_ports\rj45_all_face_ports_pec\3d_500000_100_shift\';
% modelName = 'C:\work\examples\CST\rj45_all_face_ports\rj45_all_face_ports_pec\3d_500000_100\';

%%%%%%%%%%%%%%%%%%%%%%%%%%
% sys0 = MatrixMarketReader(strcat(modelName,'system matrix.mm'));
% k2_mat = MatrixMarketReader(strcat(modelName,'k^2 matrix.mm'));
% f0 = 500000;
% k0 = 2*pi*f0/c0;
% sys0 = sys0 - k0^2 * k2_mat;
% MatrixMarketWriter(sys0, strcat(modelName,'system matrix.mm'));
% % sys0 = sys0 - (1-0.01j) * k0^2 * k2_mat;
% % MatrixMarketWriter(sys0, strcat(modelName,'system matrix'));
% % MatrixMarketWriter((1-0.01j)*k2_mat, strcat(modelName,'k^2 matrix'));
%%%%%%%%%%%%%%%%%%%%%%%%%%

impedanceFlag     = true;
linFreqParamFlag  = true;
newFileEndingFlag = true;
% orthoFlag         = true;
% saveMatlabFlag    = false;
% transposeFlag     = true;
% transparentFlag   = false;

% buildRedModelTransp(modelName, order, linFreqParamFlag);
% buildRedModelInterpolation(modelName, order, linFreqParamFlag, ...
%     transposeFlag, orthoFlag, transparentFlag);
% fNameSpara = modelEvaluation(modelName, impedanceFlag, newFileEndingFlag, ...
%     saveMatlabFlag, transparentFlag);
fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag, ...
    newFileEndingFlag);

[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
sVal  = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
    freqs(k) = parameterVals(1,k);
    sVal(k)  = sMatrices{k}(1,1);
end
absS11 = abs(sVal);
plot(freqs, absS11, 'LineWidth', linewidth);


%% Matlab-ROM results
order = 10;
modelName = 'C:\work\examples\CST\rj45_all_face_ports\rj45_all_face_ports_pec\3d_500000_100_shift\';

%%%%%%%%%%%%%%%%%%%%%%%%%%
% sys0 = MatrixMarketReader(strcat(modelName,'system matrix.mm'));
% k2_mat = MatrixMarketReader(strcat(modelName,'k^2 matrix.mm'));
% f0 = 110e6;
% k0 = 2*pi*f0/c0;
% sys0 = sys0 - k0^2 * k2_mat;
% MatrixMarketWriter(sys0, strcat(modelName,'system matrix.mm'));
% % sys0 = sys0 - (1-0.01j) * k0^2 * k2_mat;
% % MatrixMarketWriter(sys0, strcat(modelName,'system matrix'));
% % MatrixMarketWriter((1-0.01j)*k2_mat, strcat(modelName,'k^2 matrix'));
%%%%%%%%%%%%%%%%%%%%%%%%%%

impedanceFlag     = true;
linFreqParamFlag  = true;
newFileEndingFlag = true;
orthoFlag         = true;
saveMatlabFlag    = false;
transposeFlag     = true;
transparentFlag   = false;

% buildRedModelTransp(modelName, order, linFreqParamFlag);
buildRedModelInterpolation(modelName, order, linFreqParamFlag, ...
    transposeFlag, orthoFlag, transparentFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag, newFileEndingFlag, ...
    saveMatlabFlag, transparentFlag);
% fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag, ...
%     newFileEndingFlag);
% fNameSpara = [modelName 'S_f_70000000_140000000_700001.txt'];

if saveMatlabFlag
    results = load(fNameSpara);
    freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, ...
        results.freqParam.numPnts);
    sVal  = zeros(results.freqParam.numPnts,1);
    for k = 1:results.freqParam.numPnts
        sVal(k)  = results.sMat{k}(1,1);
    end
else
    [parameterNames, numParameterPnts, parameterVals, sMatrices] = ...
        loadSmatrix(fNameSpara);
    sVal  = zeros(numParameterPnts(1),1);
    freqs = zeros(numParameterPnts(1),1);
    for k = 1:numParameterPnts(1)
        freqs(k) = parameterVals(1,k);
        sVal(k)  = sMatrices{k}(1,1);
    end
end

figHandle = figure;
set(figHandle, 'color', 'w');
absS11dB = abs(sVal);
plot(freqs, absS11dB, 'g', 'LineWidth', linewidth);


%% our C++ MOR: p = 2
fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports\3d_500000_50_p2\S_f_100000_1e+006_1001.txt';
[parNames, numParPnts, parVals, sMatrices] = loadSmatrix(fNameSpara);
s11mor = zeros(numParPnts(1),1);
freqs = zeros(numParPnts(1),1);
for k = 1:numParPnts(1)
    freqs(k) = parVals(1,k);
    s11mor(k) = sMatrices{k}(7,7);
end
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs, abs(s11mor), 'b', 'LineWidth', linewidth);
hold;


%% our C++ MOR with PEC: p = 2
fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports\3d_500000_90_pec\S_f_100000_1e+006_1001.txt';
[parNames, numParPnts, parVals, sMatrices] = loadSmatrix(fNameSpara);
s11mor = zeros(numParPnts(1),1);
freqs = zeros(numParPnts(1),1);
for k = 1:numParPnts(1)
    freqs(k) = parVals(1,k);
    s11mor(k) = sMatrices{k}(7,7);
end
plot(freqs, abs(s11mor), 'g', 'LineWidth', linewidth);


%% CST results: PEC
nPort = 8;
fMin = 1e8;
fMax = 1e9;
path = 'C:\work\examples\CST\rj45_all_face_ports3\resultsCST\';
% path = 'C:\work\examples\CST\rj45_all_face_ports\resultsCSTwoLowFreqStab\';
data =  dlmread([path 'a1(1)1(1).sig'],' ',4,0);
f_scaling = dlmread([path 'a1(1)1(1).sig'],' ',[3 1 3 1]);
f_CST = data(:,1)*f_scaling;
clear data;
absS_CST = zeros(length(f_CST), nPort^2);
argS_CST = zeros(length(f_CST), nPort^2);
for iPort = 1 : nPort
    for jPort = 1 : nPort
        filenamea = ['a' num2str(iPort) '(1)' num2str(jPort) '(1).sig'];
        filenamep = ['p' num2str(iPort) '(1)' num2str(jPort) '(1).sig'];
        data = [dlmread([path filenamea],' ',4,1) dlmread([path filenamep],' ',4,1)];
        absS_CST(:,(iPort-1)*nPort + jPort) = data(:,1);
        argS_CST(:,(iPort-1)*nPort + jPort) = data(:,2);
    end
end
argS_CST = argS_CST / 180 * pi;
S_CST    = absS_CST .* exp(1i*argS_CST);
s11CST = S_CST(:,64);
plot(linspace(fMin,fMax,1001), abs(s11CST), 'g', 'LineWidth', linewidth);
