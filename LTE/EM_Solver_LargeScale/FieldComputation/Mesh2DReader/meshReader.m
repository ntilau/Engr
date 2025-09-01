% MESHREADER reads  the 2D Mesh file (FILENAMERAW).m2d
function Mesh = meshReader(fileNameRaw)

fprintf(1, '\n\t- Read m2d-mesh-file...');

% initialise return value
Mesh = struct;

file = sprintf('%s.m2d', fileNameRaw);
fid = fopen(file);
if fid == -1
    error('couldn not open file %s', file);  %#ok<SPERR>
end

while ~feof(fid)    
    
    % read Mesh data blockwise
    [type name count block] = blockReader(fid);
    if (~isempty(block) && ~isempty(type))
        Mesh.(type) = block;

        % number of items in block             
        itemCntFieldName = strcat('n', upper(type(1)), type(2:end), 's');
        Mesh.(itemCntFieldName) = count;
    end
end 
        
fclose(fid);









        
        


