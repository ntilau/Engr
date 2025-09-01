close all;
clear all;
clc;

format long;

constants;


% Define pathes
[status,result] = system('echo %LTE_ROOT%');
mainFolder = [ result(1:end-1) '\MATLAB\' ];
drivenPath = [ mainFolder 'multiPointMOR\drivenMOR'];
wgPath = [mainFolder 'multiPointMOR\wgMOR'];
IOPath = [mainFolder 'IO'];

addpath(drivenPath, wgPath, IOPath);

% Run project definition script
projects


%% Generate port names
% read boundary condition file
bcName = [ projectPath projectName '.bc' ];
bcOriginalStructure = bcRead(bcName);
% read formulation file
frmName = [ projectPath projectName '.frm' ];
frmOriginalStructure = frmRead(frmName);

% compose port names
portCount=1;
for k = 1:length(bcOriginalStructure),
    if bcOriginalStructure(k).bcType == 1,
        portName{portCount} = [projectName bcOriginalStructure(k).name];
        portCount = portCount+1;
    end
end

%% Generate and load linear system data
% ------------------------------------------------------------------
% em_wavemodelreduction
disp(' ')
disp('Generate raw model ...');

system(['cd ' projectPath ' & EM_waveModelReduction ' projectName ' ' ...
                  computationFreqStr ' ' basisOrder  ' +saveRawModel '] );
% --------------------------------------------------------------------

modelFolder = [ projectName '_' computationFreqStr '_' basisOrder '\'] ;
modelName = [ projectPath modelFolder ];

% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[fSystem, paramNames, paramValInExp, numPortsParamFile, abcFlag] = ...
readModParaTxt(fNameModRedTxt);          

% Expansion frequency vector
fExp= linspace(freqParam.fMin, freqParam.fMax, expansionNumb);


%% Generate 2D <-> 3D correspondence
disp(' ')
disp('Generate 2D <-> 3D correspondence ...');


for k = 1:numPorts,
    P{k} = pGeneration(projectPath, modelFolder, portName{k});
end



       
%% Generate reduced 2D Problem
%--------------------------------------------------------------------------
fExp2D = fExp;
disp(' ')
disp('Generate reduced 2D Problem ...');

for k = 1:numPorts,
%     generateReducedModel2DComplex(projectPath, portName{k}, fExp2D, numModes);
    generateReducedModel2D(projectPath, portName{k}, fExp2D, numModes);
%     generateReducedModel2D_2(projectPath, portName{k}, fExp2D, numModes);
end



%% Generate reduced 3D Model
fExp3D = fExp;
disp(' ')
disp('Generate reduced 3D Problem ...');

Q = generateReducedModel3D(projectPath, modelFolder, portName, fExp3D, P, numModes, numPorts );


%% Generate right hand side reduced matrices 


rhsMatrixGeneration(P, Q, projectPath, portName, numPorts);



%% Evaluate complete framework
fEval= linspace(freqParam.fMin, freqParam.fMax, freqParam.numPnts);
close all;
fNameSparaMulti = evaluateCompleteFramework( projectPath, modelFolder, portName, fEval, numModes, numPorts );



%% Load scattering matrix and plot data

addpath(projectPath);
plotWgArndt




