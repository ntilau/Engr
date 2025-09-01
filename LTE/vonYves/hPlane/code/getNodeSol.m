function nodeSol = getNodeSol(solution)

global project

node = project.topo.node;

nodeSol = [];
for nodeCnt=1:project.nodeDim
    globId = node(nodeCnt).globalId;
    globIndex = project.geo.index(globId).scalarDomain;
    
    nodeSol(nodeCnt) = solution(globIndex);
end