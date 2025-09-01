function Model = setHPlaneModelProperties(...
    Model, pOrder, hOrder, matlabRoot, lteRoot)


% polynomial degree of basis functions
Model.pOrder = pOrder;
Model.hOrder = hOrder;

% read project name
File = dir(Model.path);
isFoundM2d = false;
for k = 1:length(File)    
    posMatch = strfind(File(k).name, '.m2d');
    if ~isempty(posMatch) && ~isFoundM2d
        Model.name = File(k).name(1:(posMatch - 1));
        isFoundM2d = true;
    elseif ~isempty(posMatch) && isFoundM2d
        % test-file names ermerge often additional characters
        if length(File(k).name) < length(Model.name)
            % assign shorter name
            Model.name = File(k).name(1:(posMatch - 1));
        end
        warning(['Multiple appearance of *.m2d-file; ''%s'' is chosen ',...
            'to be Model.name'], Model.name);
    end
end

% set pathes to master matrices and materials
Model.masterMatPath = strcat(matlabRoot, ...
    '/FieldComputation/HPlaneSolver/MasterMatrices/');
if ~isdir(Model.masterMatPath)
    error('MasterMatrices path not found');
end

if isdir(strcat(Model.path, 'materials'))
    Model.materialPath = strcat(Model.path, 'materials/');
else
    fprintf(1, ['\nNo directory ''materials'' found in project path.',...
        '\n\t- Second chance: search %%LTE_ROOT%%/DATA/materials...']);
    Model.materialPath = strcat(lteRoot, '/DATA/materials/');
    if ~isdir(Model.materialPath)
        error('Material path not found');
    else
        fprintf(1, '\tFound.\n');
    end
end

if Model.Flag.impedanceFormulation
    Model.formulation = 'Z';
else
    Model.formulation = 'S';
end

Model.resultPath = sprintf('%s%sResults_%sForm_p_%d_h_%d_nFreqs_%d\\', ...
    Model.path, Model.solverType, Model.formulation, Model.pOrder, ...
    Model.hOrder, Model.nFreqs);
if ~isdir(Model.resultPath)
    mkdir(Model.resultPath);
end


