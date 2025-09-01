function [peLength, outerNode] = getPolyEdgeLength(Mesh, peId)

edgeId = Mesh.PolyEdge(peId).edge;
nodeId = unique(Mesh.edge(edgeId, :));
position = Mesh.position(nodeId, :);

[minPos, iMinPos] = min(position);
[maxPos, iMaxPos] = max(position);

peLength = norm(maxPos - minPos);

outerPositionId = unique([iMinPos, iMaxPos]);

if length(outerPositionId) == 3
    % polyEdge is oriented along one coordinate
    % delete index '1' from outerPositionId
    outerPositionId = outerPositionId(find(outerPositionId ~= 1)); %#ok<FNDSB>
end


if length(outerPositionId) ~= 2
    error('Vector OUTERNODE must be of length 2');
end

outerNode = nodeId(outerPositionId);


