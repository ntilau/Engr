% GETFACEDATA(MESH), for struct MESH, 
% returns a struct array which only contains topological data for faces
% The fields are
% edge -> array with edge id's, 
% globalId -> unique identifier

% To guarantee, that local numbering conforms to global numbering,
% sort edges in descending order in terms of the sum of nodeId's.
% Thus in local numbering edge(1) is the opponent of node(1) etc.



function face = getFaceData(mesh, currentId)

face = struct;

% add containers
for i=1:mesh.faceDim    

    %increment globalId
    currentId = currentId + 1;
    
    % collect edges in an array
    edge(1) = mesh.face(i).edge1Id;
    edge(2) = mesh.face(i).edge2Id;    
    edge(3) = mesh.face(i).edge3Id;

    % sort edge array
    nodeSum(1) = mesh.edge(edge(1)).node1Id + mesh.edge(edge(1)).node2Id;
    nodeSum(2) = mesh.edge(edge(2)).node1Id + mesh.edge(edge(2)).node2Id;
    nodeSum(3) = mesh.edge(edge(3)).node1Id + mesh.edge(edge(3)).node2Id;
    
    for j=1:3
        [tmp maxIndex] = max(nodeSum);
        sortedEdge(j) = edge(maxIndex);
        % set max to zero
        nodeSum(maxIndex) = 0;
    end
    
    face(i).edge = sortedEdge;
    
    % containers for global indices
    face(i).globalId = currentId;
end


