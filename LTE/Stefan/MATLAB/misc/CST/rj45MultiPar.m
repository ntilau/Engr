close all;
clear;

addpath(genpath('C:\work\Matlab'));
set(0,'DefaultFigureWindowStyle','docked');
fontsize = 24;
linewidth = 2.5;
c0 = 299792.458e3;


%% Build ROM

order = 5;
modelName = 'C:\Ortwin\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_61_p2_shifted\';
% modelName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_60_raw_eps1_2p2_p1_shifted\';
% modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.1e+008_61_Copy\';
% modelName = 'C:\work\examples\coax\coaxParam\coaxParam_3e+008_MU_RELATIVE_3_(1,0)_3_ML\';
%%%%%%%%%%%%%%%%%%%%%%%%%%
% sys0 = mmread(strcat(modelName,'system matrix.mm'));
% k2_mat = mmread(strcat(modelName,'k^2 matrix.mm'));
% mEps = mmread(strcat(modelName,'EPSILON_RELATIVE_Solid_Connector_1.mm'));
% f0 = 6e8;
% k0 = 2*pi*f0/c0;
% epsExp = 2.2;
% sys0 = sys0 + k0^2*k2_mat + k0^2*epsExp*mEps;
% MatrixMarketWriter(sys0, strcat(modelName,'system matrix.mm'));
% MatrixMarketWriter(-k2_mat - epsExp*mEps, [modelName,'k^2 matrix.mm']);
% MatrixMarketWriter(-epsExp*mEps, ...
%     [modelName,'EPSILON_RELATIVE_Solid_Connector_1.mm']);
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% sys0 = mmread(strcat(modelName,'system matrix.mm'));
% k2_mat = mmread(strcat(modelName,'k^2 matrix.mm'));
% f0 = 6e8;
% k0 = 2*pi*f0/c0;
% epsExp = 2.2;
% sys0 = sys0 + k0^2*k2_mat;
% MatrixMarketWriter(sys0, strcat(modelName,'system matrix.mm'));
% MatrixMarketWriter(-k2_mat, [modelName,'k^2 matrix.mm']);
%%%%%%%%%%%%%%%%%%%%%%%%%%

impedanceFlag       = true;
linFreqParamFlag    = false;
newFileEndingFlag   = true;
orthoFlag           = true;
saveMatlabFlag      = true;
transposeFlag       = true;
transparentFlag     = false;
realProjMatFlag     = false;
removeDirichletFlag = true;

% buildRedModelInterpolation(modelName, order, linFreqParamFlag, transposeFlag,...
%     orthoFlag, transparentFlag, realProjMatFlag, removeDirichletFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag, newFileEndingFlag, ...
    saveMatlabFlag, transparentFlag);
% fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag, ...
%     newFileEndingFlag);
% fNameSpara = [modelName 'S_f_70000000_140000000_700001.txt'];

if saveMatlabFlag
    results = load(fNameSpara);
    freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, ...
        results.freqParam.numPnts);
    
%     % one paramter plot
%     sVal  = zeros(results.freqParam.numPnts,1);
%     for k = 1:results.freqParam.numPnts
%         sVal(k)  = results.sMat{k}(1,1);
%     end
    
    % two parameter plot
    pos = 1;
    matVals = results.paramSpace;
    sVal = zeros(length(matVals),length(freqs));
    for fCnt = 1:length(freqs)
        for pCnt = 1:length(matVals)
            sVal(pCnt,fCnt) = results.sMat{pos}(1,1);
            pos = pos + 1;
        end
    end

else
    [parameterNames, numParameterPnts, parameterVals, sMatrices] = ...
        loadSmatrix(fNameSpara); %#ok<UNRCH>
    sVal  = zeros(numParameterPnts(1),1);
    freqs = zeros(numParameterPnts(1),1);
    for k = 1:numParameterPnts(1)
        freqs(k) = parameterVals(1,k);
        sVal(k)  = sMatrices{k}(1,1);
    end
end

figHandle = figure;
set(figHandle, 'color', 'w');
% plot(freqs, abs(sVal), 'LineWidth', linewidth);
surf(freqs * 1e-9, matVals, abs(sVal), 'FaceColor', 'interp');
hold on;


%% Discrete Matlab sweep

modelName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_61_p2\';
% modelName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_60_raw_eps1_2p2_p1\';

fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[fExp,parNames,parValInExp,nLeftVecs,abcFlag] = readModParaTxt(fNameModRedTxt);
expWvNm = 2*pi*fExp/c0;
dirMarker = readFullVector([modelName 'dirMarker.fvec']);
[rhs, lVec] = readSystemVectors(modelName, nLeftVecs, dirMarker);
SysMat = readSystemMatrices(modelName, dirMarker);
freq = linspace(1e8, 1e9, 21);
% freq = 6e8;
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

tic;
scatMat = cell(length(freq),1);
for fCnt = 1:length(freq)
    k0 = 2*pi*freq(fCnt)/c0;
    param(1).val = k0;
    param(2).val = 30.0;
    M = buildFemMatrix(SysMat, param);
    P = eye(nLeftVecs);
    for k = 1:nLeftVecs
        P(k,k) = sqrt(scaleRHS{k}(fCnt));   % frequency dependent normalization
    end
    sol = M\rhsMat;
    Z = P * (1i*lVecMat*sol) * P;
    scatMat{fCnt} = (Z-eye(nLeftVecs)) \ (Z+eye(nLeftVecs));
end
toc;
s11Full = zeros(length(freq),1);
for fCnt = 1:length(freq)
    s11Full(fCnt) = scatMat{fCnt}(1,1);
end
plot(freq, abs(s11Full), 'ko', 'LineWidth', linewidth);
% save([modelName, 'fullResEps2p2'], 'freq', 's11Full');
% ResultsFull = load([modelName, 'fullResEps2p2']);
% plot(ResultsFull.freq, abs(ResultsFull.s11Full), 'rd', 'LineWidth', linewidth);


%% error plot

figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs, abs(sVal-s11Full), 'LineWidth', linewidth);


%% compare matrices

A = mmread('C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_51_p1_shifted\system matrix.mm');
dMark=vectorReader('C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_51_p1_shifted\dirMarker.fvec');
A=A(~dMark,~dMark);
display(nnz(A-M));


%% C++ sweep

fNameSpara = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_51_fSweep_eps2p2_p1\S_f_1e+008_1e+009_1001.txt';
[parNames, numParPnts, parVals, sMats] = readscatmats(fNameSpara);
figHandle = figure;
set(figHandle,'color','w');
plot(parVals, abs(sMats{1,1}), 'g');
hold;


%% 3d plot

fName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_61_p2_shifted\S_f_100000000_1000000000_201_EPSILON_RELATIVE_Solid_Connector_1_1_30_201.mat';
Results = load(fName);
freqs = linspace(Results.freqParam.fMin, Results.freqParam.fMax, ...
    Results.freqParam.numPnts);
pos = 1;
matVals = Results.paramSpace;
sVal = zeros(length(matVals),length(freqs));
for fCnt = 1:length(freqs)
    for pCnt = 1:length(matVals)
        sVal(pCnt,fCnt) = Results.sMat{pos}(1,1);
        pos = pos + 1;
    end
end
figHandle = figure;
set(figHandle, 'color', 'w');
surf(freqs * 1e-9, matVals, abs(sVal), 'FaceColor', 'interp');
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('\epsilon_r', 'FontSize', fontsize);
axis([0.1 1 1 30 0 1]);
view([0 90]);
set(gca, 'FontSize', fontsize);


%% 2d plot

fName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_61_p2_shifted\S_f_100000000_1000000000_1001_EPSILON_RELATIVE_Solid_Connector_1_30_500_1.mat';
Results = load(fName);
freqs = linspace(Results.freqParam.fMin, Results.freqParam.fMax, ...
    Results.freqParam.numPnts);
sVal  = zeros(Results.freqParam.numPnts,1);
for k = 1:Results.freqParam.numPnts
    sVal(k)  = Results.sMat{k}(1,1);
end
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs*1e-9, abs(sVal), 'LineWidth', linewidth);
hold on;
set(gca, 'FontSize', fontsize);

fNameFull = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_61_p2\fullResEps30.mat';
ResultsFull = load(fNameFull);
plot(ResultsFull.freq*1e-9,abs(ResultsFull.s11Full),'rd','LineWidth',linewidth);

legend('ROM 5', 'Full FE', 'Location', 'NorthWest');
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|S_{11}|', 'FontSize', fontsize);


%% 2d error plot

fName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_61_p2_shifted\S_f_100000000_1000000000_21_EPSILON_RELATIVE_Solid_Connector_1_30_500_1.mat';
Results = load(fName);
freqs = linspace(Results.freqParam.fMin, Results.freqParam.fMax, ...
    Results.freqParam.numPnts);
sVal  = zeros(Results.freqParam.numPnts,1);
for k = 1:Results.freqParam.numPnts
    sVal(k)  = Results.sMat{k}(1,1);
end

fNameFull = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_61_p2\fullResEps30.mat';
ResultsFull = load(fNameFull);

figHandle = figure;
set(figHandle, 'color', 'w');
set(gca, 'FontSize', fontsize);
semilogy(freqs*1e-9, abs(ResultsFull.s11Full-sVal), 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error S_{11}|', 'FontSize', fontsize);


%% Computation with new format
order = 5;
modelName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_EPSILON_RELATIVE_Solid_Connector_1_(1,0)_51_p1_shifted_test\';
% modelName = 'C:\work\examples\CST\rj45_all_face_ports3_pec\3d_6e+008_60_raw_eps1_2p2_p1_shifted\';
% modelName = 'C:\work\examples\AnalyticMeshed\AnalyticMeshedRectWG\AnalyticMeshedWG_1.1e+008_61_Copy\';
% modelName = 'C:\work\examples\coax\coaxParam\coaxParam_3e+008_MU_RELATIVE_3_(1,0)_3_ML\';
%%%%%%%%%%%%%%%%%%%%%%%%%%
% sys0 = mmread(strcat(modelName,'system matrix.mm'));
% k2_mat = mmread(strcat(modelName,'k^2 matrix.mm'));
% mEps = mmread(strcat(modelName,'EPSILON_RELATIVE_Solid_Connector_1.mm'));
% f0 = 6e8;
% k0 = 2*pi*f0/c0;
% epsExp = 2.2;
% sys0 = sys0 + k0^2*k2_mat + k0^2*epsExp*mEps;
% MatrixMarketWriter(sys0, strcat(modelName,'system matrix.mm'));
% MatrixMarketWriter(-k2_mat - epsExp*mEps, [modelName,'k^2 matrix.mm']);
% MatrixMarketWriter(-epsExp*mEps, ...
%     [modelName,'EPSILON_RELATIVE_Solid_Connector_1.mm']);
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% sys0 = mmread(strcat(modelName,'system matrix.mm'));
% k2_mat = mmread(strcat(modelName,'k^2 matrix.mm'));
% f0 = 6e8;
% k0 = 2*pi*f0/c0;
% epsExp = 2.2;
% sys0 = sys0 + k0^2*k2_mat;
% MatrixMarketWriter(sys0, strcat(modelName,'system matrix.mm'));
% MatrixMarketWriter(-k2_mat, [modelName,'k^2 matrix.mm']);
%%%%%%%%%%%%%%%%%%%%%%%%%%

impedanceFlag       = true;
linFreqParamFlag    = false;
newFileEndingFlag   = true;
orthoFlag           = true;
saveMatlabFlag      = true;
transposeFlag       = true;
transparentFlag     = false;
realProjMatFlag     = false;
removeDirichletFlag = true;

buildRedModelInterpolation(modelName, order, linFreqParamFlag, transposeFlag,...
    orthoFlag, transparentFlag, realProjMatFlag, removeDirichletFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag, newFileEndingFlag, ...
    saveMatlabFlag, transparentFlag);
% fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag, ...
%     newFileEndingFlag);
% fNameSpara = [modelName 'S_f_70000000_140000000_700001.txt'];

if saveMatlabFlag
    results = load(fNameSpara);
    freqs = linspace(results.freqParam.fMin, results.freqParam.fMax, ...
        results.freqParam.numPnts);
    
    % one paramter plot
    sVal  = zeros(results.freqParam.numPnts,1);
    for k = 1:results.freqParam.numPnts
        sVal(k)  = results.sMat{k}(1,1);
    end
    
%     % two parameter plot
%     pos = 1;
%     matVals = results.paramSpace;
%     sVal = zeros(length(matVals),length(freqs));
%     for fCnt = 1:length(freqs)
%         for pCnt = 1:length(matVals)
%             sVal(pCnt,fCnt) = results.sMat{pos}(1,1);
%             pos = pos + 1;
%         end
%     end

else
    [parameterNames, numParameterPnts, parameterVals, sMatrices] = ...
        loadSmatrix(fNameSpara); %#ok<UNRCH>
    sVal  = zeros(numParameterPnts(1),1);
    freqs = zeros(numParameterPnts(1),1);
    for k = 1:numParameterPnts(1)
        freqs(k) = parameterVals(1,k);
        sVal(k)  = sMatrices{k}(1,1);
    end
end

figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs, abs(sVal), 'LineWidth', linewidth);
% surf(freqs * 1e-9, matVals, abs(sVal), 'FaceColor', 'interp');
hold on;


%%%%%%%%%%%%%%%%%%%%% Other stuff %%%%%%%%%%%%%%%%%%%%%%%%

%%
p = [-7 4 3];
ps = getshiftedpolynomgeneral(p,3);
display(ps);

getshiftedpolynom(3, 2, 4)


%%

% fNameSpara = 'C:\work\examples\CST\coaxdiscontinuity\3d_5e+009_100\S_f_1e+009_6e+009_201.txt';
% fNameSpara = 'C:\work\examples\CST\3dtransline\3d_5e+009_100\S_f_1e+009_7.5e+009_201.txt';
% fNameSpara = 'C:\work\examples\CST\3dtransline\3d_2e+009_100\S_f_1e+009_7.5e+009_201.txt';
% fNameSpara = 'C:\work\examples\CST\resonator\3d_6e+009_100\S_f_1e+009_1e+010_201.txt';
% fNameSpara = 'C:\work\examples\CST\dielectric_resonator_filter\lte_fileset\3d_8e+009_100\S_f_4e+009_1.2e+010_201.txt';
fNameSpara = 'C:\work\examples\layerShort\layerShort_6e+009_100\S_f_1e+009_1.1e+010_201.txt';

[parameterNames, numParameterPnts, parameterVals, sMatrices] = ...
    loadSmatrix(fNameSpara);
sVal  = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
    freqs(k) = parameterVals(1,k);
    sVal(k)  = sMatrices{k}(1,1);
end
figHandle = figure;
set(figHandle, 'color', 'w');
plot(freqs, abs(sVal), 'LineWidth', linewidth);


%% EM_WaveSolver results
pathname = 'C:\work\examples\CST\3dtransline\';
filename = 'sParam.s2p';
DUM = TouchStone2DUM(pathname, filename);
plot(DUM.f, abs(DUM.S{1,1}), 'kd', 'LineWidth', linewidth);


%%
dataCell{1}=[1 2 5];
dataCell{2}=[3 4];
dataCell{3}=[6 7 8 9];
currentRow = [0 0 0];
combMat = zeros(24,3);
currentPosInRow = 1;
currentRowNo = 1;

combMat = buildallcombinations(dataCell, currentRow, currentRowNo, ...
    currentPosInRow, combMat)


%%
degree = [3 2];
shift = [2 3];
[mCoeff mPower] = getshiftedmultivariatepolynom(degree, shift)


%%
order = 5;
modelName = 'C:\work\examples\layerShort\layerShort_6e+009_200\';
impedanceFlag       = true;
newFileEndingFlag   = true;
orthoFlag           = true;
saveMatlabFlag      = true;
transposeFlag       = true;
transparentFlag     = false;
realProjMatFlag     = false;
removeDirichletFlag = true;

buildMultiParamROM(modelName, order, transposeFlag,...
    orthoFlag, transparentFlag, realProjMatFlag, removeDirichletFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag, newFileEndingFlag, ...
    saveMatlabFlag, transparentFlag);





