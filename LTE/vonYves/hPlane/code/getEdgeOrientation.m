function edgeOrientation = getEdgeOrientation(edgeCnt, globalPeOrientation, alignment)

global project

node = project.topo.edge(edgeCnt).node;

y1 = project.topo.node(node(1)).y;
y2 = project.topo.node(node(2)).y;
z1 = project.topo.node(node(1)).z;
z2 = project.topo.node(node(2)).z;

globalEdgeOrientation = sign(project.topo.node(node(2)).(alignment) - project.topo.node(node(1)).(alignment));

if (globalEdgeOrientation == globalPeOrientation)
    edgeOrientation = 1;
else
    edgeOrientation = -1;
end

