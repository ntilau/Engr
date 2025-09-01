function [startNode, endNode] = getPolyEdgesOuterNodes(project, peId)

edge = project.geo.poly_edges(peId).edge;

[tmp edgeDim] = size(edge);

% initialise min,max with big values

minY = 1e6;
maxY = -1e6;
minZ = 1e6;
maxZ = -1e6;

outerPos = [minY minZ; maxY maxZ];    

% find poly_edge-orientation in y,z-plane
startPos = getEdgePositions(project, edge(1));
deltaY = startPos(1,1) - startPos(2,1);
deltaZ = startPos(1,2) - startPos(2,2);

% find outer nodes of poly_edges item
if abs(deltaY) > abs(deltaZ)
    % search for minY and maxY (first column of pos-matrix)
    colIndex = 1;
else
    % search for minZ and maxZ (second column)
    colIndex = 2;
end
    
for edgeCnt=1:edgeDim
    
    pos = getEdgePositions(project, edge(edgeCnt));
    
    if pos(1,colIndex) < outerPos(1,colIndex)
        outerPos(1,1) = pos(1,1);
        outerPos(1,2) = pos(1,2);
        startNode = project.topo.edge(edge(edgeCnt)).node(1);
    end
    
    if pos(2,colIndex) < outerPos(1,colIndex)
        outerPos(1,1) = pos(2,1);
        outerPos(1,2) = pos(2,2);
        startNode = project.topo.edge(edge(edgeCnt)).node(2);
     end
    
    if pos(1,colIndex) > outerPos(2,colIndex)
        outerPos(2,1) = pos(1,1);
        outerPos(2,2) = pos(1,2);
        endNode = project.topo.edge(edge(edgeCnt)).node(1);        
    end
    
    if pos(2,colIndex) > outerPos(2,colIndex)
        outerPos(2,1) = pos(2,1);
        outerPos(2,2) = pos(2,2);
        endNode = project.topo.edge(edge(edgeCnt)).node(2);                
    end
end

% check wether the direction start->end is similar to positiv 
% y-direction on port/poly_edge
orientation = getPolyEdgesLocalOrientation(project, startNode, endNode);

if orientation == -1
    % swap startNode, endNode
    tmp = startNode;
    startNode = endNode;
    endNode = tmp;
end










