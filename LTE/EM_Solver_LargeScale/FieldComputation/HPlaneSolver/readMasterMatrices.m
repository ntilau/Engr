% ELEMENTMATRIXREADER reads element matrices which are stored in 
% maple-created files. The function returns a struct array with fields
% named like the corresponding file name

function Matrix = readMasterMatrices(Model)

% list all files in direction matrixDir
matrixDir = sprintf('%sorder_%d', Model.masterMatPath, Model.pOrder);

allFiles = dir(matrixDir);

if isempty(allFiles)
    error('The directory %s does not exist.', matrixDir);
elseif length(allFiles) <= 2
    % only '.' and '..'
    error('No files in directory %s.', matrixDir);
end

fileCnt = length(allFiles);

for i=1:fileCnt
    % skip '.' and '..'
    if (~strcmp(allFiles(i).name, '.') && ~strcmp(allFiles(i).name, '..'))
        
        % remove file extension from file name
        fieldName = substr(allFiles(i).name, 0, ...
            strfind(allFiles(i).name, '.')-1);
        
        fid = fopen(sprintf('%s\\%s', matrixDir, allFiles(i).name));
        if (fid == -1)
            error('Couldn''t open file %s', allFiles(i).name);
        else
            Matrix.(fieldName) = fgetl(fid);
            fclose(fid);
        end
    end
end

