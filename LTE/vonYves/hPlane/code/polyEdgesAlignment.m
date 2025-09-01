function a = polyEdgesAlignment(project, peStartNode, peEndNode)

startY = project.topo.node(peStartNode).y;
startZ = project.topo.node(peStartNode).z;
endY = project.topo.node(peEndNode).y;
endZ = project.topo.node(peEndNode).z;

if abs(startY - endY) > abs(startZ - endZ)
    a = 'y';
else
    a = 'z';
end