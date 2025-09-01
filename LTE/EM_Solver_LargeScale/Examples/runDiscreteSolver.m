clc;
close all;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% include function directories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [status, matlabRoot] = system('echo %MATLAB_ROOT%');
[status, lteRoot] = system('echo %LTE_ROOT%');
matlabRoot = strcat(lteRoot, '/MATLAB/EM_Solver_LargeScale');

addpath(genpath(strcat(matlabRoot, '/FieldComputation')));
addpath(strcat(matlabRoot, '/String'));
addpath(strcat(matlabRoot, '/idEM'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set simulation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% path 'system matrix.mm', 'k^2 matrix.mm' 'rhs_0.fvec' etc
path = ['C:\Users\ykonkel.LTE-W18\Simulation\Projects\LTE\',...
    'DielPostFilter\HPlane\HPlaneResults_ZForm_p_2_h_0_nFreqs_101\'];

fMin = 15e9;
fMax = 30e9;
nFreqs = 101;

Flag.impedanceFormulation = true;

Model = createDiscreteSolverModel(path, fMin, fMax, nFreqs, Flag);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% discrete sweep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[sMat, zMat, dof, sol, solveTime] = evaluateFullSystem(Model);

% plot reflection coefficient
plotScatParam(Model.f, sMat, 1, 1);





