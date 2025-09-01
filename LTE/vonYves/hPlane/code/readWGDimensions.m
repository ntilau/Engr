% READWGDIMENSIONS returns struct array with fields
%     - height  ... y-dimension
%     - width   ... x-dimension

function wg = readWGDimensions(projectPath)

% list all files in direction xCoeffDir
file = strcat(projectPath, '\\dimensions.dat');

        
fid = fopen(file);
if (fid == -1)
    error('Couldn''t open file %s', file);
else
    wg.height = fscanf(fid, '%f', 1);
    wg.width = fscanf(fid, '%f', 1);
    fclose(fid);
end
