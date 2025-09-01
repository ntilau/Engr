function l = getEdgeLength(edgeCnt)

global project

y1 = project.topo.node(project.topo.edge(edgeCnt).node(1)).y;
y2 = project.topo.node(project.topo.edge(edgeCnt).node(2)).y;

z1 = project.topo.node(project.topo.edge(edgeCnt).node(1)).z;
z2 = project.topo.node(project.topo.edge(edgeCnt).node(2)).z;

l = sqrt((y1 - y2)^2 + (z1 - z2)^2);
