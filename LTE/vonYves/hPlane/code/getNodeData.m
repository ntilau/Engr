% GETNODEDATA(MESH), for struct MESH, 
% returns a struct array which only contains topological data for nodes
% The fields are
% y -> y-position in cartesian coordinates
% z -> z-position in cartesian coordinates
% globalId -> unique identifier for each mesh component



function node = getNodeData(mesh, currentId)

% initialise return value
node = struct;

for i=1:mesh.nodeDim
    currentId = currentId + 1;
    
    % assign positions
    node(i).y = mesh.position(i).y;
    node(i).z = mesh.position(i).z;
    
    % container for global indices
    node(i).globalId = currentId;
end

