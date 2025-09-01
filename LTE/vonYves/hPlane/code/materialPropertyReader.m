% MATERIALPROPERTYREADER(MTR, PROJECTPATH), for struct array MTR, is a struct which
% associates the materials in MTR with their physical parameters.
% String PROJECTPATH is the directory, in which the requested files are
% stored.
% The function collects all material names in MTR and reads the accordant 
% mtrl-files

function mtrProp = materialPropertyReader(mtr, projectPath)

% initialise return value
mtrProp = struct;

% extract all material names and read accordant files
[tmp mtrCnt] = size(mtr);

mtrPath = sprintf('%s\\Materials\\', projectPath); 

for i=1:mtrCnt
    
    % material properties are stored in similar-named files
    fileName = strcat(mtrPath, mtr(i).materialType);    
    
    file = sprintf('%s.mtrl', fileName');
    
    fid = fopen(file);
    
    if fid == -1
        error('couldn''t open file %s', file);
    end
    
    while ~feof(fid)    
        
        % read mesh data blockwise
        [type name count material_property] = blockReader(fid);
        if (~isempty(material_property) && ~isempty(type))
            mtrProp(i).name = name;
            mtrProp(i).property = material_property;
        end
    end 
    
    
    fclose(fid);
end