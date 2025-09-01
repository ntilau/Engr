function RedModel = projModelABCD(Model, W, V)

% project model
RedModel.A = cell(length(Model.A),1);
for iMat = 1:length(Model.A)
  if ~isempty(Model.A{iMat})
    RedModel.A{iMat} = W * (Model.A{iMat} * V);
  end
end
RedModel.B = cell(length(Model.B),1);
for iMat = 1:length(Model.B)
  if ~isempty(Model.B{iMat})
    RedModel.B{iMat} = W * Model.B{iMat};
  end
end
RedModel.C = cell(length(Model.C),1);
for iMat = 1:length(Model.C)
  if ~isempty(Model.C{iMat})
    RedModel.C{iMat} = Model.C{iMat} * V;
  end
end
RedModel.permutMat = Model.permutMat;