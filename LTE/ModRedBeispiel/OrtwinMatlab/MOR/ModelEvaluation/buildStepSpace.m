function [stepSpace paramSpace] = buildStepSpace(materialParams, pos, ...
  stepSpace, paramSpace, currentStepVals, currentParamVals)

paramStep = 0;
if (materialParams(pos).numPnts ~= 1)
  paramStep = (materialParams(pos).max-materialParams(pos).min) / ...
    (materialParams(pos).numPnts-1);
end
if pos == length(materialParams)
  %newStepSpace = [];
  %newParamSpace = [];
  for k = 1:length(materialParams(pos).steps)
    currentStepVals(pos) = materialParams(pos).steps(k);
    %newStepSpace = [newStepSpace, currentStepVals];
    currentParamVals(pos) = materialParams(pos).min + (k-1) * paramStep;
    %newParamSpace = [newParamSpace, currentParamVals];
    
    % new
    stepSpace = [stepSpace, currentStepVals];
    paramSpace = [paramSpace, currentParamVals];
  end
%   stepSpace = [stepSpace, newStepSpace];
%   paramSpace = [paramSpace, newParamSpace];
else
  for k = 1:length(materialParams(pos).steps)
    currentStepVals(pos) = materialParams(pos).steps(k);
    currentParamVals(pos) = materialParams(pos).min + (k-1) * paramStep;
    [stepSpace paramSpace] = buildStepSpace(materialParams, pos+1, ...
      stepSpace, paramSpace, currentStepVals, currentParamVals);
  end
end