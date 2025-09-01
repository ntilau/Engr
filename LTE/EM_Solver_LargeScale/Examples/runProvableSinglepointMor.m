clc;
close all;
clear;

% Before running this script, set MATLABROOT and PATH to your local pathes.
% A reference project for testing can be found at the preset PATH.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add function pathes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[status, lteRoot] = system('ECHO %LTE_ROOT%');
matlabRoot = strcat(lteRoot, 'MATLAB/EM_Solver_LargeScale/');

addpath(genpath(strcat(matlabRoot, '/FieldComputation')));
addpath(strcat(matlabRoot, '/String'));
addpath(strcat(matlabRoot, '/idEM'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set model simulation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path of model under consideration
path = ['C:\Users\ykonkel.LTE-W18\Simulation\Projects\LTE\', ...
    'DielPostFilter\EM_WaveSolver\Lossless\HPlane_3d\DielPost_HPlane3d_2.25e+010_2'];
fMin = 15e9;
fMax = 30e9;
nFreqs = 51;
morMethod = 'ProvableSinglepoint';
maxRomOrder = 50;

Flag.doubleOrtho = false;
Flag.writeResults = true;


% set type and threshold value of error criterion 'L1', 'L2' or 'inf'
errorCriterionType = 'L2';
errorCriterionThreshold = 1e-7;

Model = createModelStruct(path, fMin, fMax, nFreqs, Flag, morMethod, ...
    maxRomOrder, errorCriterionType, errorCriterionThreshold);

% set threshold for relative eigenfrequency errors
Model.eigThreshold = 1e-3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model order reduction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Model, Rom] = symmetricMorProvable(Model);
rom2plot = getRom2plot(Rom, Model.iRomConverged, 5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compare fast and naive residuals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = rom2plot
    Rom{k}.RNaive = computeNaiveResiduals(Model, Rom{k}, Model.Q);
    resdlErrorAbs(:,k) = ...
        abs(Rom{k}.R(1).absolute - Rom{k}.RNaive(1).absolute);    
    resdlErrorRel(:,k) = ...
        abs(Rom{k}.R(1).relative - Rom{k}.RNaive(1).relative);    
end
figure;
semilogy(Model.f, resdlErrorAbs);
figure;
semilogy(Model.f, resdlErrorRel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot and save results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fontSize = 18;

% load reference data for comparison purpose
fNameRefParams = strcat(path, '/Sfull_f_1.5e+010_3e+010_pts101.txt');
Dum = lteMorScatParamReader(fNameRefParams, 50);
Dum.zMat = s2z(Dum.sMat);
Dum.Z = sortNetworkParamsByPorts(Dum.zMat);

Error = computeActualRomError(Model, Dum, Rom);

% for iRom = 1:length(Rom)
%     writeEigEstCsvTable(Model, referencePole, Rom{iRom});
% end

plotScatParam(Model.f, Rom{end}.sMat, 1, 1);
plotScatParam(Dum.f, Dum.sMat, 1, 1);


h = plotScatErrorEst(Model, Rom(rom2plot), Error(rom2plot), fontSize);
h = plotImpErrorEst(Model, Rom(rom2plot), Error(rom2plot), fontSize);
h = plotFastResiduals(Model, Rom(rom2plot), fontSize);
h = plotResidualNorm(Model, Rom, fontSize);

hErrorNormZ = plotImpErrorNorm(Rom, Error, fontSize);
hErrorNormS = plotScatErrorNorm(Rom, Error, fontSize);
hIncrmtlCrit = plotIncrementalCriterion(Model, Rom, fontSize);





