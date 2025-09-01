function redModel = projectModelVS(model, Q)
% project model onto space Q and return the reduced model


redModel.sysMat = cell(1, length(model.sysMat));
for k = 1 : length(model.sysMat)
  if ~isempty(model.sysMat{k})
    redModel.sysMat{k} = Q' * model.sysMat{k} * Q;
    clear sysMat{k};
  end
end

if iscell(model.outputFunctional)
  redModel.outputFunctional = cell(length(model.outputFunctional), 1);
  for k = 1 : length(model.outputFunctional)
    if ~isempty(model.outputFunctional{k})
      redModel.outputFunctional{k} = model.outputFunctional{k} * Q;
    end
  end
else
  redModel.outputFunctional = model.outputFunctional * Q;
end

if iscell(model.rhs)
  redModel.rhs = cell(length(model.rhs), 1);
  for k = 1 : length(model.rhs)
    if ~isempty(model.rhs{k})
      redModel.rhs{k} = Q' * model.rhs{k};
    end
  end
else
  redModel.rhs = Q' * model.rhs;
end

redModel.coeffSequence = model.coeffSequence;
