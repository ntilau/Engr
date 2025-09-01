close all;
clc;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% include function directories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [status, matlabRoot] = system('echo %MATLAB_ROOT%');
% [status, lteRoot] = system('echo %LTE_ROOT%');
% matlabRoot = strcat(lteRoot, '/MATLAB/EM_Solver_LargeScale');
matlabRoot = strcat('../../EM_Solver_LargeScale/');

addpath(genpath(strcat(matlabRoot, '/FieldComputation')));
addpath(strcat(matlabRoot, '/String'));
addpath(strcat(matlabRoot, '/idEM'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set simulation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% path to *.m2d, *.bc2, *.mtr files
path = ['C:\Users\ykonkel.LTE-W18\Simulation\Projects\LTE\',...
    'DielPostFilter\HPlane\HalfModel\symmetric\'];

% bandwidth (Hz) and samples
fMin = 15e9;
fMax = 30e9;
nFreqs = 1;

pOrder = 2;
hOrder = 0;

% set diverse flags
Flag.usePardiso = false;
Flag.computeFreqSweep = true;
Flag.saveRawModel = false;
Flag.impedanceFormulation = true;
Flag.showMovie = false;

Model = createModelStruct(path, fMin, fMax, nFreqs, Flag, 'HPlane');
Model = setHPlaneModelProperties(...
    Model, pOrder, hOrder, matlabRoot, lteRoot);

if Flag.saveRawModel
    % determine index of expansion frequency (= freq. of saved model)
    Model.iFExp = ceil(nFreqs/2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute fields of H-plane structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[sMat, zMat] = hPlaneSolver(Model);

% plot reflection coefficient
plotScatParam(Model.f, sMat, 1, 1);



