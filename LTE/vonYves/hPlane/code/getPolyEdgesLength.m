% [PELENGTH, OUTERPOS, OUTEREDGE] = GETPOLYEDGESLENGTH(PEID) returns the length of
% poly_edges item PEID, the positions OUTERPOS of the outer nodes and the
% id's of OUTEREDGE


function [peLength, outerPos, outerEdge] = getPolyEdgesLength(peId)

global project

edge = project.geo.poly_edges(peId).edge;

[tmp edgeDim] = size(edge);

% initialise min,max with big values

minY = 1e6;
maxY = -1e6;
minZ = 1e6;
maxZ = -1e6;

outerPos = [minY minZ; maxY maxZ];    
outerEdge = [-1 -1];


% find poly_edge-orientation in y,z-plane
startPos = getEdgePositions(edge(1));
deltaY = startPos(1,1) - startPos(2,1);
deltaZ = startPos(1,2) - startPos(2,2);

% find outer nodes of poly_edges item
if abs(deltaY) > abs(deltaZ)
    % search for minY and maxY (first column of pos-matrix)
    colIndex = 1;
else
    colIndex = 2;
end
    
for edgeCnt=1:edgeDim
    
    pos = getEdgePositions(edge(edgeCnt));
    
    if pos(1,colIndex) < outerPos(1,colIndex)
        outerPos(1,1) = pos(1,1);
        outerPos(1,2) = pos(1,2);
        outerEdge(1) = edge(edgeCnt);
    end
    
    if pos(2,colIndex) < outerPos(1,colIndex)
        outerPos(1,1) = pos(2,1);
        outerPos(1,2) = pos(2,2);
        outerEdge(1) = edge(edgeCnt);        
    end
    
    if pos(1,colIndex) > outerPos(2,colIndex)
        outerPos(2,1) = pos(1,1);
        outerPos(2,2) = pos(1,2);
        outerEdge(2) = edge(edgeCnt);        
    end
    
    if pos(2,colIndex) > outerPos(2,colIndex)
        outerPos(2,1) = pos(2,1);
        outerPos(2,2) = pos(2,2);
        outerEdge(2) = edge(edgeCnt);        
    end
end

peLength = sqrt( (outerPos(1,1) - outerPos(2,1))^2 + (outerPos(1,2) - outerPos(2,2))^2 );

