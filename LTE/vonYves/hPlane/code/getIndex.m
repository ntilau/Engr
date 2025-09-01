% ID = GETINDEX(FACECNT) returns array ID which contains the indices
% of relevant vectorial basis function coefficients

function id = getIndex(faceCnt)

global project
global scalarOrder

vectorialOrder = 0;

edge = project.topo.face(faceCnt).edge;

id = [];

if scalarOrder >= 1
    globId = getElemNode(faceCnt);
    nodeIndex = project.geo.index(globId).scalarDomain;
    id = nodeIndex(1);
end

if vectorialOrder >= 1
    % first set of edge-related coefficients
    for j = 1:3
        globId = project.topo.edge(edge(j)).globalId;
        edgeIndex = project.geo.index(globId).vectorialDomain;
        id = [id; edgeIndex(1)];
    end
end

if vectorialOrder >= 2
        
    % first set of face-related coefficients
    globId = project.topo.face(faceCnt).globalId;
    faceIndex = project.geo.index(globId).vectorialDomain;
    id = [id; faceIndex(1:2)'];
    
    % second set of edge-related coefficients
    for j = 1:3
        globId = project.topo.edge(edge(j)).globalId;
        edgeIndex = project.geo.index(globId).vectorialDomain;
        id = [id; edgeIndex(2)];
    end
end

if vectorialOrder == 3
        
    % second set of face-related coefficients
    id = [id; faceIndex(3:5)'];
    
     % third set of edge-related coefficients
    for j = 1:3
        globId = project.topo.edge(edge(j)).globalId;
        edgeIndex = project.geo.index(globId).vectorialDomain;
        id = [id; edgeIndex(3)];
    end
 
    % second set of face-related coefficients
    id = [id; faceIndex(6)];
end