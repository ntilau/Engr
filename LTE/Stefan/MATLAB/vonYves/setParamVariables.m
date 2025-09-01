% assign parameter values to parameter names
function setParamVariables(param)
for p = 1:length(param)
    assignin('caller', param(p).name, param(p).val);
end

