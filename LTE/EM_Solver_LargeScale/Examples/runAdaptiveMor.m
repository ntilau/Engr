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
    'DielectricPostWG\EM_WaveSolver\DielPostWaveGuide\dielPostWG_2e+008_2'];
fMin = 160e6;
fMax = 240e6;
nFreqs = 101;
morMethod = 'Multipoint';
maxRomOrder = 100;
Flag.doubleOrtho = true;
% set type and threshold value of error criterion 'L1', 'L2' or 'inf'
errorCriterionType = 'L2';
errorCriterionThreshold = 1e-7;

Model = createModelStruct(path, fMin, fMax, nFreqs, Flag, morMethod, ...
    maxRomOrder, errorCriterionType, errorCriterionThreshold);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model order reduction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Model, Rom, RomSolution, fExp] = AdaptiveMultipointMor(Model);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot and save results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fontSize = 18;

plotScatParam(Model.f, RomSolution{Model.iRomConverged}.sMat, 1, 1);

hSecError = plotSectionError(Model, Model.maxSectionError, fontSize);
fName = strcat(Model.resultPath, Model.name, '_sectionError');
savePlot(hSecError, fName, {'epsc', 'fig', 'jpeg'});

hIncrmtlCrit = plotIncrementalCriterion(Model, RomSolution, fontSize);
savePlot(hIncrmtlCrit(1), strcat(Model.resultPath, Model.name, ...
    '_incrementalScatCriterion'), {'epsc', 'fig', 'jpeg'});
savePlot(hIncrmtlCrit(2), strcat(Model.resultPath, Model.name, ...
    '_incrementalImpCriterion'), {'epsc', 'fig', 'jpeg'});





