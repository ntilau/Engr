% GETEDGEDATA(MESH), for struct MESH, 
% returns a struct array which only contains topological data for edges.
% The fields are
% node -> sorted array [lowId highId] which contains the node-id's
% globalId -> unique identifier for each mesh component

function edge = getEdgeData(mesh, currentId)

% initialise return value
edge = struct;

for i=1:mesh.edgeDim
    
    %increment globalId
    currentId = currentId + 1;
    
    % assign positions
    node(1) = mesh.edge(i).node1Id;
    node(2) = mesh.edge(i).node2Id;
    
    % sort array node, since edge orientation is set
    % to point from lower to higher nodeId  
    node = sort(node);
    
    edge(i).node = node;
    
    % container for global indices
    edge(i).globalId = currentId;
end


