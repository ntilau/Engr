% READAMPLITUDEFACTOR returns the coeffient c_ss, which represents 
% the x-dependency of the e-field at the ports

function xCoeff = readAmplitudeFactor(projectName)

% list all files in direction xCoeffDir
xCoeffDir = sprintf('..\\analyticXCoeffs\\%s', projectName);

allFiles = dir(xCoeffDir);
[fileCnt tmp] = size(allFiles);

for i=1:fileCnt
    % skip '.' and '..'
    if strcmp(allFiles(i).name, 'c_ss.dat')
        
        % field name consists only of file name without file extension
        fieldName = substr(allFiles(i).name, 0, strfind(allFiles(i).name, '.')-1);
        
        fid = fopen(sprintf('%s\\%s', xCoeffDir, allFiles(i).name));
        if (fid == -1)
            error('Couldn''t open file %s', allFiles(i).name);
        else
            xCoeff = eval(fgetl(fid));
            fclose(fid);
        end
    end
end