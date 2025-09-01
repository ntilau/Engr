function [SysMat, dof] = readSystemMatrices(modelName, dirMarker)

% read 'matrixParametrization.txt'
SysMat = readMatrixParametrization(modelName);

for matCnt = 1:length(SysMat)
    fname = strcat(modelName, SysMat(matCnt).name, '.mm');
    msg = sprintf('Reading matrix ''%s.mm''...', SysMat(matCnt).name);    
    disp(msg);    
    mat = MatrixMarketReader(fname);
    
    % if no dirichlet marker is passed
    if nargin < 2 && matCnt == 1        
        dirMarker = false(size(mat, 1), 1);
    end
    SysMat(matCnt).val = mat(~dirMarker, ~dirMarker);
end

dof = size(SysMat(1).val, 1);
