function writeModel(model, dirPath)


mkdir(dirPath);
% matrix market format
for sysMatCnt = 1 : length(model.sysMat)
  if ~isempty(model.sysMat{sysMatCnt})
    fName = strcat(dirPath, 'sysMat');
    for paramCnt = 1 : size(model.coeffSequence, 2)
      fName = strcat(fName, '_', num2str(model.coeffSequence(sysMatCnt, paramCnt)));
    end
    fName = strcat(fName, '.mm');
    MatrixMarketWriter(model.sysMat{sysMatCnt}, fName);
  end
end

for rhsCnt = 1 : length(model.rhs)
  if ~isempty(model.rhs{rhsCnt})
    fName = strcat(dirPath, 'rhs');
    for paramCnt = 1 : size(model.coeffSequence, 2)
      fName = strcat(fName, '_', num2str(model.coeffSequence(rhsCnt, paramCnt)));
    end
    fName = strcat(fName, '.mm');
    MatrixMarketWriter(model.rhs{rhsCnt}, fName);
  end
end

for outCnt = 1 : length(model.outputFunctional)
  if ~isempty(model.outputFunctional{outCnt})
    fName = strcat(dirPath, 'outputFunctional');
    for paramCnt = 1 : size(model.coeffSequence, 2)
      fName = strcat(fName, '_', num2str(model.coeffSequence(rhsCnt, paramCnt)));
    end
    fName = strcat(fName, '.mm');
    MatrixMarketWriter(model.outputFunctional{outCnt}, fName);
  end
end

% store parameter dependence
writeParameterDependence(dirPath, model);

% binary format - whole cell array
save([dirPath 'model'], 'model');
