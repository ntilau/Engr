% save system matrices and vectors ready for MOR-purpose
function saveEFormulationModel(Model, SysMat, dirMarker, rhs, k0)

% E = -j * omega * A -> scale SOE with 1/k0
freqScale = 1 / k0;
fExp = k2f(k0);

iPortIdentMat = findMatrixIndex(SysMat, 'portIdent_0');
if ~isempty(iPortIdentMat)   
    for k = 1:Model.nPorts
        % prepare matrix parametrization for frequency sweeps 
        iMat = findMatrixIndex(SysMat, sprintf('portIdent_%d', k - 1));
        SysMat(iMat).paramList(1).param{1} = sprintf(...
            ['k0 * ((fCutOff(%d) / f)^2 - 1)^0.5 /',...
            '((fCutOff(%d) / fExp)^2 - 1)^0.5'], k, k);        
    end
end

for k = 1:length(SysMat)        
    mmwrite(strcat(Model.resultPath, SysMat(k).name, '.mm'), ...
        freqScale * SysMat(k).val);
end

writeFullVector(dirMarker, strcat(Model.resultPath, 'dirMarker.fvec'));

for iPort = 1:Model.nPorts
    if Model.Flag.impedanceFormulation
        scaledRhs = - 1 / Model.c0 * Model.mu0 * freqScale * rhs(:,iPort);
    else
        scaledRhs = 2j / Model.c0 * Model.mu0 * freqScale * rhs(:,iPort);
    end
    writeFullVector(full(scaledRhs), ...
        sprintf('%srhs_%d.fvec', Model.resultPath, iPort - 1));
    writeFullVector(full(rhs(:,iPort) / norm(rhs(:,iPort))), ...
        sprintf('%sleftVec_%d.fvec', Model.resultPath, iPort - 1));
end

writeMatrixParametrization(Model, SysMat);

nMaterialParams = 0;
writeModelParamFile(Model, fExp, nMaterialParams, ...
    Model.Flag.impedanceFormulation, Model.nPorts);

% restriction: port materials must exhibit vacuum-properties
fCutOff = k2f(pi ./ (Model.Geo.portWidth));
writeModelPvarFile(Model, fCutOff, nMaterialParams);


