function writeParameterDependence(dirPath, model)


numParams = size(model.coeffSequence, 2);


%% parameter dependence of system matrices
% find number of non empty system matrices
numNonEmpty = 0;
for sysMatCnt = 1 : length(model.sysMat)
  if ~isempty(model.sysMat{sysMatCnt})
    numNonEmpty = numNonEmpty + 1;
  end
end
coeffNonEmpty = zeros(numNonEmpty, numParams);
currentPos = 0;
for sysMatCnt = 1 : length(model.sysMat)
  if ~isempty(model.sysMat{sysMatCnt})
    currentPos = currentPos + 1;
    coeffNonEmpty(currentPos, :) = model.coeffSequence(sysMatCnt, :);
  end
end
fNameParamDependence = [dirPath 'sysMatParamDependence.txt'];
writeCoeffNonEmpty(fNameParamDependence, coeffNonEmpty);


%% parameter dependence of rhs
% find number of non empty rhs vector or matrices
numNonEmpty = 0;
for rhsCnt = 1 : length(model.rhs)
  if ~isempty(model.rhs{rhsCnt})
    numNonEmpty = numNonEmpty + 1;
  end
end
coeffNonEmpty = zeros(numNonEmpty, numParams);
currentPos = 0;
for rhsCnt = 1 : length(model.rhs)
  if ~isempty(model.rhs{rhsCnt})
    currentPos = currentPos + 1;
    coeffNonEmpty(currentPos, :) = model.coeffSequence(rhsCnt, :);
  end
end
fNameParamDependence = [dirPath 'rhsParamDependence.txt'];
writeCoeffNonEmpty(fNameParamDependence, coeffNonEmpty);



%% parameter dependence of outputFunctional
% find number of non empty rhs vector or matrices
numNonEmpty = 0;
for outCnt = 1 : length(model.outputFunctional)
  if ~isempty(model.outputFunctional{outCnt})
    numNonEmpty = numNonEmpty + 1;
  end
end
coeffNonEmpty = zeros(numNonEmpty, numParams);
currentPos = 0;
for outCnt = 1 : length(model.outputFunctional)
  if ~isempty(model.outputFunctional{outCnt})
    currentPos = currentPos + 1;
    coeffNonEmpty(currentPos, :) = model.coeffSequence(outCnt, :);
  end
end
fNameParamDependence = [dirPath 'outputFunctionalParamDependence.txt'];
writeCoeffNonEmpty(fNameParamDependence, coeffNonEmpty);



function writeCoeffNonEmpty(fName, coeffNonEmpty)

fId = fopen(fName, 'w');
if fId == -1
  error(strcat('Could not open file: ', fName));
end
fprintf(fId, '%i %i\n', size(coeffNonEmpty, 1), size(coeffNonEmpty, 2));
for rowCnt = 1 : size(coeffNonEmpty, 1)
  writeIntegerArray(fId, coeffNonEmpty(rowCnt, :));
end
fclose(fId);
