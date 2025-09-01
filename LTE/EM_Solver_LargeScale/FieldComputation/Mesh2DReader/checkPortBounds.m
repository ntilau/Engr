function isPmcBounded = checkPortBounds(Model, outerNode, edgeOnPort)

isPmcBounded = false(2,1);

for k = 1:2
    % find edges connected to outer node
    [edge, icol] = find(Model.Mesh.edge == outerNode(k));
    
    % discard edge on port
    nonPortEdge = setdiff(edge, edgeOnPort);
    
    % find polyEdge containing one item of nonPortEdge (there must be
    % exactly one nonPortEdge-to-polyEdge-connection)
    m = 0;
    iPe = [];    
    while isempty(iPe) && m < length(nonPortEdge)
        m = m + 1;
        iPe = find(Model.Mesh.edge2polyEdge(1,:) == nonPortEdge(m));
    end
        
    boundingPeId = Model.Mesh.edge2polyEdge(2, iPe);
    % determine boundary type of polyEdge
    boundaryId = Model.Geo.polyEdge2Boundary(:, 1) == boundingPeId;
    if strcmp(Model.Geo.Boundary(boundaryId).type, 'PMC2D')
        isPmcBounded(k) = true;
    end
end
    
if all(isPmcBounded)
    error('Only one item of outerNode may be of type PMC2D');
end
    
    
    
    
    
    