% establish orientation of edges and consistent local edge numbering
function Mesh = reorderMeshComponents(Mesh)

% edge points from lower to higher node
Mesh.edge = sort(Mesh.edge, 2);

% local node numbering: equal to global numbering, 
% n1 = min(node), n3 = max(node), n2 = mid(node)

% local edge numbering: edge_k carries the local number of opposite node
for k = 1:Mesh.nFaces    
    % edge numbering via sum of bounding nodes: 
    % max(sum(node)) -> edge_1, min(sum(node)) -> edge_3, etc.
    faceEdge = Mesh.face(k,:);
    faceNodeSum = sum(Mesh.edge(faceEdge, :), 2);
    [faceNodeSum, iNode] = sort(faceNodeSum, 'descend');
    Mesh.face(k,:) = Mesh.face(k, iNode);
end