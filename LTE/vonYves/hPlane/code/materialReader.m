% MATERIALREADER(FILENAME), for string FILENAME, is a struct which
% associates the poly_faces with their materials

function material = materialReader(projectPath, projectName)

% initialise return value
material = struct;

% initialise material id
mtrId = 0;

file = strcat(projectPath, projectName, '.mtr2');

fid = fopen(file);

if fid == -1
    error('couldn''t open file %s', file);
end

while ~feof(fid)
    
    % increment material id
    mtrId = mtrId + 1;
    
    % read data
    polyFacesName = fscanf(fid, '%s', 1);
    
    if ~isempty(polyFacesName)
        
        % polyFacesName may be no valid variable name
        polyFacesName = makeValidVarName(polyFacesName, 'POLY_FACES');
        
        material(mtrId).polyFacesName = polyFacesName;
        
        materialType =  fscanf(fid, '%s', 1);     
        material(mtrId).materialType = materialType;
    end
end
            
fclose(fid);
