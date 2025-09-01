% MESHREADER(FILENAME) is a struct with all the information 
% given by m2d-files
% The file FILENAME.m2d is read blockwise by the function BLOCKREADER(FID)
% and each block is stored in a field named by the block type
%
% If the file associated with FID containes more than one mesh with
% distinct names, MESHREADER has to be modified. In this version the
% blocks read at last will overwrite blocks of the same type. In most
% (all?) cases, only one block per type is defined in one file

function mesh = meshReader(projectPath, projectName)

% initialise return value
mesh = struct;

file = strcat(projectPath, projectName, '.m2d');

fid = fopen(file);

if fid == -1
    error('couldn''t open file %s', file);
end

while ~feof(fid)    
    
    % read mesh data blockwise
    [type name count block] = blockReader(fid);
    if (~isempty(block) && ~isempty(type))
        mesh.(type) = block;
        
        % number of items in block
        itemCntFieldName = strcat(type, 'Dim');
        mesh.(itemCntFieldName) = count;
    end
end 
        
fclose(fid);
