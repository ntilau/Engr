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
    'DielPostFilter\HPlane\HPlaneResults_ZForm_p_2_h_0_nFreqs_201'];
fMin = 15e9;
fMax = 30e9;
nFreqs = 201;
morMethod = 'ProvableSinglepoint';
maxRomOrder = 100;

Flag.doubleOrtho = false;
Flag.writeResults = true;


% set type and threshold value of error criterion 'L1', 'L2' or 'inf'
errorCriterionType = 'L2';
errorCriterionThreshold = 1e-1;

Model = createModelStruct(path, fMin, fMax, nFreqs, Flag, morMethod, ...
    maxRomOrder, errorCriterionType, errorCriterionThreshold);

% set threshold for relative eigenfrequency errors
Model.eigThreshold = 1e-2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model order reduction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Model, Rom] = symmetricMorProvable(Model);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot and save results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fontSize = 18;

% load reference data for comparison purpose
fNameRefParams = strcat(path, '/S_HPlane_f_1.5e+010_3e+010_pts201.txt');
Dum = lteMorScatParamReader(fNameRefParams, 50);
Dum.zMat = s2z(Dum.sMat);
Dum.Z = sortNetworkParamsByPorts(Dum.zMat);

Error = computeActualRomError(Model, Dum, Rom);

% for iRom = 1:length(Rom)
%     writeEigEstCsvTable(Model, referencePole, Rom{iRom});
% end

plotScatParam(Model.f, Rom{end}.sMat, 1, 1);
plotScatParam(Dum.f, Dum.sMat, 1, 1);

rom2plot = [7,9,15,17];
h = plotScatErrorEst(Model, Rom(rom2plot), Error(rom2plot), fontSize);
h = plotImpErrorEst(Model, Rom(rom2plot), Error(rom2plot), fontSize);
h = plotFastResiduals(Model, Rom(rom2plot), fontSize);
h = plotResidualNorm(Model, Rom, fontSize);

% #residuals
% #errorNorms


hErrorNorm = plotImpErrorNorm(Model, Rom, Dum.zMat, fontSize);

hIncrmtlCrit = plotIncrementalCriterion(Model, Rom, fontSize);
% savePlot(hIncrmtlCrit(1), strcat(Model.resultPath, Model.name, ...
%     '_incrementalScatCriterion'), {'epsc', 'fig', 'jpeg'});
% savePlot(hIncrmtlCrit(2), strcat(Model.resultPath, Model.name, ...
%     '_incrementalImpCriterion'), {'epsc', 'fig', 'jpeg'});





