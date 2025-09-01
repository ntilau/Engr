% ELEMENTMATRIXREADER reads element matrices which are stored in 
% maple-created files. The function returns a struct array with fields
% named like the corresponding file name

function matrixFiles = elementMatrixReader(project, scalarOrder)

% list all files in direction matrixDir
matrixDir = sprintf('..\\masterMatrices\\%s\\order_%d', project.name, scalarOrder);

allFiles = dir(matrixDir);
[fileCnt tmp] = size(allFiles);

for i=1:fileCnt
    % skip '.' and '..'
    if (~strcmp(allFiles(i).name, '.') && ~strcmp(allFiles(i).name, '..'))
        
        % field name consists only of file name without file extension
        fieldName = substr(allFiles(i).name, 0, strfind(allFiles(i).name, '.')-1);
        
        fid = fopen(sprintf('%s\\%s', matrixDir, allFiles(i).name));
        if (fid == -1)
            error('Couldn''t open file %s', allFiles(i).name);
        else
            matrixFiles.(fieldName) = fgetl(fid);
            fclose(fid);
        end
    end
end

