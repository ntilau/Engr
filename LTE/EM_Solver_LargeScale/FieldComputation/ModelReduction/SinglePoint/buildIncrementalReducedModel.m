function Rom = buildIncrementalReducedModel(...
    Model, SysMat, OldRom, Q, X0, rhs, lhs) %#ok<INUSD,INUSL>

[nRows, nCols] = size(Q);
oldCols = 1:(nCols - Model.nPorts);
newCols = (nCols - Model.nPorts + 1):nCols;

for k = 1:length(SysMat)
    Rom.SysMat(k).name = SysMat(k).name;
    Rom.SysMat(k).paramList = SysMat(k).paramList;
    Rom.SysMat(k).val = zeros(nCols);
    % left upper block remains 
    if ~isempty(OldRom)
        Rom.SysMat(k).val(oldCols,oldCols) = OldRom.SysMat(k).val;
    end    
    % right upper block
    Rom.SysMat(k).val(oldCols, newCols) = Q(:,oldCols).' * ...
        SysMat(k).val * Q(:,newCols);
    % left lower block
    Rom.SysMat(k).val(newCols, oldCols) = ...
        Rom.SysMat(k).val(oldCols, newCols).';
    % new diag block
    Rom.SysMat(k).val(newCols, newCols) = Q(:,newCols).' * ...
        SysMat(k).val * Q(:,newCols);       
end

% iterate over fields containing system vectors
vectField = {'lhs', 'rhs', 'X0'};
for k = 1:length(vectField)
    Rom.(vectField{k}) = zeros(nCols, Model.nPorts);
    if ~isempty(OldRom)
        Rom.(vectField{k})(oldCols,:) = OldRom.(vectField{k});
    end
    Rom.(vectField{k})(newCols,:) = Q(:,newCols).' * eval(vectField{k});
end

Rom.dim = size(Q, 2);
Rom.order = Rom.dim / size(rhs, 2);

Rom.sparamFilename = ...
    generateNetworkparamFilename('S', Model, Rom.order);
Rom.zparamFilename = ...
    generateNetworkparamFilename('Z', Model, Rom.order);



    