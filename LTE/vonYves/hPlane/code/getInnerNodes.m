% GETINNERNODES(POLYEDGESID) returns a node array with all inner 
% nodes on poly_edge item POLYEDGESID, but the outer nodes

function innerNode = getInnerNodes(project, polyEdgesId)

edge = project.geo.poly_edges(polyEdgesId).edge;
[tmp edgeDim] = size(edge);

node = [];
for edgeCnt=1:edgeDim
    node = [node project.topo.edge(edge(edgeCnt)).node];
end

% remove entries in node, which emerge only one time
[tmp nodeDim] = size(node);

node = sort(node);

inCnt = 0;
nodeCnt = 1;
while nodeCnt < nodeDim
    if node(nodeCnt) == node(nodeCnt + 1)
        inCnt = inCnt + 1;
        innerNode(inCnt) = node(nodeCnt);
        nodeCnt = nodeCnt + 2;
    else 
        nodeCnt = nodeCnt +1;
    end    
end
