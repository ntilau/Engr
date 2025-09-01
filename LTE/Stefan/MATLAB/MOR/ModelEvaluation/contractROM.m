function oneParamModel = contractROM(sysMat, sysMatRedNames, parPnt)

% determine order of parameter dependence
order = sum(sysMatRedNames(length(sysMat), :));
numParams = size(sysMatRedNames, 2);
oneParamModel = cell(order + 1, 1);
for matCnt = 1 : order + 1
  oneParamModel{matCnt} = zeros(size(sysMat{1}, 1));
end
for sysMatCnt = 1 : length(sysMat)
  order = sum(sysMatRedNames(sysMatCnt, :));
  scale = 1;
  for parCnt = 1 : numParams
    scale = scale * parPnt(parCnt) ^ sysMatRedNames(sysMatCnt, parCnt);
  end
  oneParamModel{order + 1} = oneParamModel{order + 1} + scale * sysMat{sysMatCnt};
end
