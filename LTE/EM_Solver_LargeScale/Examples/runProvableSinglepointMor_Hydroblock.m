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
path = ['C:\Users\ykonkel.LTE-W18\Simulation\Projects\Bosch\',...
    'ESP_Control\EM_WaveSolver\Hydroblock_woPCB_lossless_smallBox\Hydroblock_3e+008_20'];
fMin = 105e6;
fMax = 410e6;
nFreqs = 1001;
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
[Model, Rom, Time] = symmetricMorProvable(Model);
writeProvableMorStatistics(Model, Time);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot and save results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fontSize = 18;
format = {'epsc', 'fig', 'jpeg'};

% load reference data for comparison purpose
Dum = TouchStone2DUM(path, 'sParam_105e6_410e6_1001.s5p');
Dum.sMat = sortNetworkParamsByMatrices(Dum.S);
Dum.zMat = s2z(Dum.sMat);
Dum.Z = sortNetworkParamsByPorts(Dum.zMat);

Error = computeActualRomError(Model, Dum, Rom);

% for iRom = 1:length(Rom)
%     writeEigEstCsvTable(Model, referencePole, Rom{iRom});
% end

% plotScatParam(Model.f, Rom{end}.sMat, 1, 1);
% plotScatParam(Dum.f, Dum.sMat, 1, 1);

rom2plot = getRom2plot(Rom, Model.iRomConverged, 4);
h = plotScatErrorEst(Model, Rom(rom2plot), Error(rom2plot), fontSize);
savePlot(h, [Model.resultPath, Model.name, '_scatErrorEst'], format);

h = plotScatErrorNorm(Rom, Error, fontSize, Model.ErrorCriterion.threshold);
savePlot(h, [Model.resultPath, Model.name, '_scatErrorNorm'], format);

h = plotImpErrorEst(Model, Rom(rom2plot), Error(rom2plot), fontSize);
savePlot(h, [Model.resultPath, Model.name, '_impErrorEst'], format);

h = plotImpErrorNorm(Rom, Error, fontSize);
savePlot(h, [Model.resultPath, Model.name, '_impErrorNorm'], format);

h = plotFastResiduals(Model, Rom(rom2plot), fontSize);
savePlot(h, [Model.resultPath, Model.name, '_fastResidual_1'], format);
h = plotResidualNorm(Model, Rom(1:end-1), fontSize);
savePlot(h, [Model.resultPath, Model.name, '_fastResidualNorm'], format);

h = plotIncrementalCriterion(Model, Rom, fontSize);
savePlot(h(1), [Model.resultPath, Model.name, '_scatCriterion'], format);
savePlot(h(2), [Model.resultPath, Model.name, '_impCriterion'], format);


writeProvableMorStatistics(Model, Time);



