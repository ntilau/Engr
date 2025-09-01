function paramSpace = buildParamSpace(params, pos, paramSpace, currentParamVals)

paramStep = 0;
if (params{pos}.numPnts ~= 1)
  paramStep = (params{pos}.max - params{pos}.min) / (params{pos}.numPnts - 1);
end
if pos == length(params)
  for k = 1 : length(params{pos}.pnts)
    currentParamVals(pos) = params{pos}.min + (k - 1) * paramStep;
    
    % new
    paramSpace = [paramSpace, currentParamVals];
  end
else
  for k = 1 : 1 : length(params{pos}.pnts)
    currentParamVals(pos) = params{pos}.min + (k - 1) * paramStep;
    paramSpace = buildParamSpace(params, pos + 1, paramSpace, currentParamVals);
  end
end