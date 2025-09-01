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
    'VariantenAnalyse\EM_Solver\UncompressedTest\lte_fileset\VariantPCB_LumpElements_5e+009_1\'];

fMin = 5e9;
fMax = 5e9;
nFreqs = 1;

Flag.impedanceFormulation = true;

Model = createDiscreteSolverModel(path, fMin, fMax, nFreqs, Flag);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% discrete sweep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[sMat, zMat, dof, sol, solveTime] = evaluateFullSystemUncomressed(Model);

sMat{1}
abs(sMat{1})
% % plot reflection coefficient
% plotScatParam(Model.f, sMat, 1, 1);





