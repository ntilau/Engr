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
path = ['C:\Users\ykonkel.LTE-W18\Simulation\Projects\LTE\',...
    'rectWG\EM_WaveSolver\RWG_2port\RWG_2.25e+009_3\'];
% 'DielPostFilter\EM_WaveSolver\Lossless\HPlane_3d\DielPost_HPlane3d_2.25e+
% 010_2'];
    
fMin = 1.5e9;
fMax = 3.0e9;
nFreqs = 101;
morMethod = 'Singlepoint';
maxRomOrder = 100;
Flag.doubleOrtho = false;
% set type and threshold value of error criterion 'L1', 'L2' or 'inf'
errorCriterionType = 'L2';
errorCriterionThreshold = 1e-7;

Model = createModelStruct(path, fMin, fMax, nFreqs, Flag, morMethod, ...
    maxRomOrder, errorCriterionType, errorCriterionThreshold);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model order reduction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Model, Rom] = symmetricMorLossless(Model);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compare eigenvalues of original and reduced model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute eigenvalues of the original model in the vicinity of kExp
refEig = computeDominantPoles(Model, Model.kExp^2, 20);
fRef = k2f(sqrt(refEig));

% ROM eigenvalues
romEig = eig(Rom{end}.SysMat(1).val, -Rom{end}.SysMat(2).val);
fRom = k2f(sqrt(romEig));

eigErrorK = calcEigError(refEig, romEig);
eigErrorF = calcEigError(fRef, fRom);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot and save results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fontSize = 18;

plotScatParam(Model.f, Rom{Model.iRomConverged}.sMat, 1, 1);

hIncrmtlCrit = plotIncrementalCriterion(Model, Rom, fontSize);
savePlot(hIncrmtlCrit(1), strcat(Model.resultPath, Model.name, ...
    '_incrementalScatCriterion'), {'epsc', 'fig', 'jpeg'});
savePlot(hIncrmtlCrit(2), strcat(Model.resultPath, Model.name, ...
    '_incrementalImpCriterion'), {'epsc', 'fig', 'jpeg'});





