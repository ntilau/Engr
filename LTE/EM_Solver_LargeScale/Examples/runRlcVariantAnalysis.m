% clc;
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
addpath(strcat(matlabRoot, '/UsefulScripts'));
addpath(strcat(matlabRoot, '/idEM'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set simulation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path = ['C:\Users\ykonkel.LTE-W18\Simulation\Projects\LTE\', ...
    'VariantenAnalyse\EM_Solver\LumpRlc\lte_fileset\',...
    'VariantPCB_LumpElements_5e+009_2\'];
Model = createVariantAnalysisModel(path);
Model.rhsBlockSize = 50;

[Variant, port2Variant, Port] = rlcVariantAnalysis(Model);
[sMatNaive, zMatNaive] = naiveRlcVariantSimulation(Model);

nVariants = length(Variant);

for k = 1:nVariants
%     fprintf('\nVariant no. %d (naive)', k);
%     abs(sMatNaive{k})
%     fprintf('\nVariant no. %d (sophisticated)', k);
%     abs(sMatVar{k})        
    fprintf('\nVariant %d: DeltaS = %1.3e, ',...
        k, norm(norm(abs(Variant(k).sMat - sMatNaive{k}))));    
end
fprintf('\n');

% postprocessing
for k = 3;%1:nVariants
    iPort = 2:3;
    iRlc = 1;
    C = 10e-12; % F
    zMatRenorm = convertPort2LumpRlc(Variant(k).zMat, iPort, iRlc, C);
    sMatRenorm = z2s(zMatRenorm);
    Zc = 1 / (1j * 2 * pi * Model.f * C);
    sMatRenorm2 = renormalizeSmatrix(Variant(k).sMat, ...
        [50, Port(3).impedance, Port(4).impedance], ...
        [Zc, Port(3).impedance, Port(4).impedance]);
    
    [abs(sMatRenorm), angle(sMatRenorm) * 180 ./ pi]
    [abs(sMatRenorm2(2:3,2:3)), angle(sMatRenorm2(2:3,2:3)) * 180 ./ pi]    
end




