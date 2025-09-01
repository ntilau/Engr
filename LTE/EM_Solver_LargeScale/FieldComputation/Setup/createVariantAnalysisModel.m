% creates MODEL struct containing FE-System parameters, pathes, etc.
function Model = createVariantAnalysisModel(path, Flag)
constants;

Model.c0 = c0;
Model.mu0 = mu0;
Model.eps0 = eps0;
Model.eta0 = eta0;

% last char of string PATH must be a (back-)slash
if isempty(regexp(path(end), '[/\\]', 'once'))
    Model.path = strcat(path, '/');
else
    Model.path = path;
end

% set flags
if nargin > 1
    Model.Flag = Flag;
else
    Model.Flag.impedanceFormulation = true;
end
    
Model.resultPath = Model.path;
    
% extract name of model from the directory name
if strcmp(Model.path, '.\') || strcmp(Model.path, './')
    dirRaw = pwd;
    modelNameExplode = textscan(dirRaw, '%s', 'delimiter', '\\');
else
    modelNameExplode = textscan(Model.path, '%s', 'delimiter', '\\');
end
Model.romName = modelNameExplode{1,1}{end};
nameEndPos = regexp(Model.romName, '_[0-9]{1,}(.[0-9]{1,})*e');
Model.name = Model.romName(1:(nameEndPos - 1));

% expansion frequency and number of input/output
fModelParam = strcat(Model.path, 'modelParam.txt');
if exist(fModelParam, 'file')
    [Model.fExp, Model.nPorts] = readModelParameter(fModelParam);
    % expansion wavenumber
    Model.kExp = f2k(Model.fExp);
end

Model.f = Model.fExp;

% read "model.pvar"
fNameModPvar = strcat(Model.path, 'model.pvar');
if exist(fNameModPvar, 'file')
    [freqParam, materialParams] = readPvar(fNameModPvar);
    Model.fCutOff = freqParam.fCutOff;
    Model.materialParams = materialParams;
else
    warning('File \n\t%s\n not found. fCutOff is set to 0 Hz', ...
        fNameModPvar');
    Model.fCutOff = zeros(Model.nPorts, 1);
    Model.materialParams = [];
end














