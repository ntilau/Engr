% creates MODEL struct containing FE-System parameters, pathes, etc.
function Model = createModelStruct(path, fMin, fMax, nFreqs, Flag, ...
    solverType, maxRomOrder, errorCriterionType, errorCriterionThreshold)

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

% bandwidth (Hz) and samples
Model.fMin = fMin;
Model.fMax = fMax;
Model.nFreqs = nFreqs;

% linear sampling in frequency band
Model.f = linspace(Model.fMin, Model.fMax, Model.nFreqs);

% set flags
if nargin > 4
    Model.Flag = Flag;
end

if nargin > 5
    Model.solverType = solverType;
end

% model order reduction properties
if nargin > 6
    % max number of full solutions
    Model.maxRomOrder = maxRomOrder;
        
    if nargin > 7
        Model.ErrorCriterion.type = errorCriterionType;
    else
        Model.ErrorCriterion.type = 'L2';
    end
    
    if nargin > 8
        Model.ErrorCriterion.threshold = errorCriterionThreshold;
    else
        Model.ErrorCriterion.threshold = 1e-7;
    end
    
    % % use an integer multiple of nFreqs for mor-evaluation-points nFreqsRom
    % if ~isfield(Model, 'fFactor')
    %     Model.fFactor = 1;
    % end
    % nFreqsRom = Model.fFactor * (Model.nFreqs - 1) + 1;
    
    % create a directory where mor-results will be stored
    
    Model.resultPath = sprintf('%s%sResults_pMax_%d_nFreqs_%d\\', ...
        Model.path, Model.solverType, Model.maxRomOrder, nFreqs);
    if ~isdir(Model.resultPath)
        mkdir(Model.resultPath);
    end    
    
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
end













