function Port = getPortData(Model)

Port = struct([]);

for k = 1:Model.nPorts
    boundaryId = Model.Geo.port2Boundary(k);
    polyEdgeId = Model.Geo.Boundary(boundaryId).polyEdgeId;
    % edges and nodes on port
    edge = Model.Mesh.PolyEdge(polyEdgeId).edge;
    node = unique(Model.Mesh.edge(edge,:));
    
    portWidth = Model.Geo.portWidth(k);
    
    % remove outer nodes, which belong to dirichlet 
    [tmp, outerNode] = getPolyEdgeLength(Model.Mesh, polyEdgeId);
    
    % check whether structure's symmetrie is utilized
    Port(k).isPmcBounded = checkPortBounds(Model, outerNode, edge); 
          
    node = setdiff(node, outerNode(~Port(k).isPmcBounded))';
    
    Port(k).node = node;
    Port(k).edge = edge;
    
    
    if any(Port(k).isPmcBounded)
        Port(k).width = 2 * portWidth;
        % local coordinate must start at a pec-bound
        Port(k).startNode = outerNode(~Port(k).isPmcBounded);    
    else
        Port(k).width = portWidth;
        Port(k).startNode = outerNode(1);        
    end
    
    if Model.pOrder == 1
        Port(k).dof = node;        
    elseif Model.pOrder == 2
        Port(k).dof = [node, edge + Model.Mesh.nNodes];        
    elseif Model.pOrder >= 3
        error('pOrder = %d is not implemented yet', Model.pOrder);
    end          
end
    
     

