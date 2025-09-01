function SysMat = readSystemMatrices(modelName, dirMarker)

% read 'matrixParametrization.txt'
SysMat = readMatrixParametrization(modelName);

for matCnt = 1:length(SysMat)
    fname = strcat(modelName, SysMat(matCnt).name, '.mm');
    msg = sprintf('Reading matrix ''%s.mm''...', SysMat(matCnt).name);    
    disp(msg);    
    mat = MatrixMarketReader(fname);
    SysMat(matCnt).val = mat(~dirMarker, ~dirMarker);
end
