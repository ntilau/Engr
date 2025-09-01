function pos = getEdgePositions(project, edgeCnt)

y1 = project.topo.node(project.topo.edge(edgeCnt).node(1)).y;
y2 = project.topo.node(project.topo.edge(edgeCnt).node(2)).y;

z1 = project.topo.node(project.topo.edge(edgeCnt).node(1)).z;
z2 = project.topo.node(project.topo.edge(edgeCnt).node(2)).z;


pos = [[y1 z1]; [y2 z2]];