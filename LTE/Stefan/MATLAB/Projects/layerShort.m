close all;
clear;

addpath(genpath('C:\work\Matlab'));
set(0,'DefaultFigureWindowStyle','docked');
fontsize = 24;
linewidth = 2.5;
c0 = 299792.458e3;


%% Shift expansion point - multiple parameters
% modelName = 'C:\work\examples\layerShort\layerShort_6e+009_EPSILON_RELATIVE_Box2_(8,0)_300_shifted\';
% sys0 = mmread(strcat(modelName,'system matrix.mm'));
% k2_mat = mmread(strcat(modelName,'k^2 matrix.mm'));
% mEps = mmread(strcat(modelName,'EPSILON_RELATIVE_Box2.mm'));
% f0 = 6e9;
% k0 = 2*pi*f0/c0;
% epsExp = 8;
% sys0 = sys0 + k0^2*k2_mat + k0^2*mEps;
% MatrixMarketWriter(sys0, [modelName,'system matrix.mm']);
% MatrixMarketWriter(-k2_mat -mEps, [modelName,'k^2 matrix.mm']);
% MatrixMarketWriter(-mEps, [modelName,'EPSILON_RELATIVE_Box2.mm']);



%% Order reduction - multiple parameters
order = 10;
modelName = 'C:\work\examples\layerShort\layerShort_6e+009_EPSILON_RELATIVE_Box2_(8,0)_300_shifted\';
impedanceFlag       = true;
linFreqParamFlag    = false;
newFileEndingFlag   = true;
orthoFlag           = true;
saveMatlabFlag      = true;
transposeFlag       = true;
transparentFlag     = false;
realProjMatFlag     = false;
removeDirichletFlag = true;
pardisoFlag         = true;

% buildRedModelInterpolation(modelName, order, linFreqParamFlag, transposeFlag,...
%     orthoFlag, transparentFlag, realProjMatFlag, removeDirichletFlag, ...
%     pardisoFlag);
% buildRedModelInterpEfficientOld(modelName, order, linFreqParamFlag, ...
%     transposeFlag, orthoFlag, transparentFlag, realProjMatFlag, ...
%     removeDirichletFlag, pardisoFlag);
buildRedModel(modelName, order, linFreqParamFlag, transposeFlag, orthoFlag, ...
    transparentFlag, realProjMatFlag, removeDirichletFlag, pardisoFlag);
fNameSpara = modelEvaluation(modelName, impedanceFlag, newFileEndingFlag, ...
    saveMatlabFlag, transparentFlag);
% fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag, ...
%     newFileEndingFlag, saveMatlabFlag, pardisoFlag);
% fNameSpara = [modelName 'S_f_70000000_140000000_700001.txt'];

if saveMatlabFlag
    Results = load(fNameSpara);
    freqs = linspace(Results.freqParam.fMin, Results.freqParam.fMax, ...
        Results.freqParam.numPnts);
    matVals = Results.paramSpace;
    
    if (length(matVals) == 1 || isempty(matVals))
        % one paramter plot
        sVal  = zeros(Results.freqParam.numPnts,1);
        for k = 1:Results.freqParam.numPnts
            sVal(k)  = Results.sMat{k}(1,1);
        end
        figHandle = figure;
        set(figHandle, 'color', 'w');
        plot(freqs, abs(sVal), 'LineWidth', linewidth);
        hold on;
    else
        % two parameter plot
        pos = 1;
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
        hold on;
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


%% Shift expansion point - single parameter
% modelName = 'C:\work\examples\layerShort\layerShort_6e+009_200_shifted\';
% sys0 = mmread(strcat(modelName,'system matrix.mm'));
% k2_mat = mmread(strcat(modelName,'k^2 matrix.mm'));
% f0 = 6e9;
% k0 = 2*pi*f0/c0;
% sys0 = sys0 + k0^2*k2_mat;
% MatrixMarketWriter(sys0, strcat(modelName,'system matrix.mm'));
% MatrixMarketWriter(-k2_mat, [modelName,'k^2 matrix.mm']);


%% Order reduction - single parameter
order = 23;
modelName = 'C:\work\examples\layerShort\layerShort_6e+009_200_shifted\';
impedanceFlag       = true;
linFreqParamFlag    = false;
newFileEndingFlag   = true;
orthoFlag           = true;
saveMatlabFlag      = true;
transposeFlag       = true;
transparentFlag     = false;
realProjMatFlag     = false;
removeDirichletFlag = true;
pardisoFlag         = true;

% buildRedModelInterpolation(modelName, order, linFreqParamFlag, transposeFlag,...
%     orthoFlag, transparentFlag, realProjMatFlag, removeDirichletFlag, ...
%     pardisoFlag);
% buildRedModelInterpEfficientOld(modelName, order, linFreqParamFlag, ...
%     transposeFlag, orthoFlag, transparentFlag, realProjMatFlag, ...
%     removeDirichletFlag, pardisoFlag);
% fNameSpara = modelEvaluation(modelName, impedanceFlag, newFileEndingFlag, ...
%     saveMatlabFlag, transparentFlag);
fNameSpara = solveUnredModel(modelName, impedanceFlag, linFreqParamFlag, ...
    newFileEndingFlag, saveMatlabFlag, pardisoFlag);
% fNameSpara = [modelName 'S_f_70000000_140000000_700001.txt'];

if saveMatlabFlag
    Results = load(fNameSpara);
    freqs = linspace(Results.freqParam.fMin, Results.freqParam.fMax, ...
        Results.freqParam.numPnts);
    matVals = Results.paramSpace;
    
    if (length(matVals) == 1 || isempty(matVals))
        % one paramter plot
        sVal  = zeros(Results.freqParam.numPnts,1);
        for k = 1:Results.freqParam.numPnts
            sVal(k)  = Results.sMat{k}(1,1);
        end
        figHandle = figure;
        set(figHandle, 'color', 'w');
        plot(freqs, abs(sVal), 'LineWidth', linewidth);
        hold on;
    else
        % two parameter plot
        pos = 1;
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
        hold on;
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


%% load C++ results
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


%% Test new Pardiso interface

modelName = 'C:\work\examples\layerShort\layerShort_6e+009_200_shifted\';
mSys = mmread(strcat(modelName,'system matrix.mm'));
b = zeros(size(mSys,1),1);
b(1) = 1;

if nnz(imag(mSys))
    mtype = 6;  % complex symmetric indefinite matrix
else
    mtype = -2;  % real symmetric indefinite matrix
end

% Fill-reduction analysis and symbolic factorization
[iparm,pt,err,A_val,A_ia,A_ja,ncol] = pardisoReorderLTE(mtype, mSys); 
tic
% Numerical factorization
err=pardisoFactorLTE(mtype,iparm,pt,A_val,A_ia,A_ja,ncol);
fprintf(' error = %i\n',err); 
toc
% allocate memory for real solution vector
% x = zeros(size(b));
tic
% Forward and Backward solve
releasememory=0;
[x,err]=pardisoSolveLTE(mtype,iparm,pt,A_val,A_ia,A_ja,ncol, b, releasememory);
fprintf(' error = %i\n',err);
toc
% Test residual
display(norm(mSys * x - b) / norm(b));

error=pardisoReleaseMemory(mtype,iparm,pt,A_val,A_ia,A_ja,ncol);

x2 = mSys\b;
display(norm(x-x2) / norm(x));


%% Test modified and unmodified GramSchmidt
dim = 200;
A = randn(100000,dim);

tic;
Q1 = zeros(size(A));
Q1(:,1) = A(:,1)/norm(A(:,1));
for colCnt = 1:size(A,2)
    v = A(:,colCnt) - Q1(:,1:(colCnt-1)) * (Q1(:,1:(colCnt-1))'*A(:,colCnt));
    v = v - Q1(:,1:(colCnt-1)) * (Q1(:,1:(colCnt-1))'*v);
    Q1(:,colCnt) = v / norm(v);
end
toc;    

oTest = Q1'*Q1;
oTest2 = oTest-eye(dim);
max(max(abs(oTest2)))
        
tic;
Q2 = zeros(size(A));
Q2(:,1) = A(:,1)/norm(A(:,1));
for colCnt = 1:size(A,2)
    v = A(:,colCnt);
    for qVecCnt = 1:(colCnt-1)
        v = v - Q2(:,qVecCnt) * (Q2(:,qVecCnt)'*v);
    end
    Q2(:,colCnt) = v / norm(v);
end
toc;    

oTest = Q2'*Q2;
oTest2 = oTest-eye(dim);
max(max(abs(oTest2)))
