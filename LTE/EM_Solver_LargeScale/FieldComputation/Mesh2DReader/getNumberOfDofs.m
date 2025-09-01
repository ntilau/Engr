function nDofsRaw = getNumberOfDofs(Model)

switch Model.pOrder
    case 1
        nDofsRaw = Model.Mesh.nNodes;
    case 2
        nDofsRaw = Model.Mesh.nNodes + Model.Mesh.nEdges;
    case 3
        nDofsRaw = Model.Mesh.nNodes + 2 * Model.Mesh.nEdges + ...
            Model.Mesh.nFaces;
    otherwise
        error('Method not implemented for p = %d', Model.pOrder);
end
        