for ii = 1 : project.nodeDim
    ycoord_(ii) = project.topo.node(ii).y ;
    zcoord_(ii) = project.topo.node(ii).z ;
end
for ii = 1: project.faceDim
    TRI(ii, :) = getElemNode(ii) ;
end

triplot(TRI,ycoord_,zcoord_);

hold on;

% kanten auf polyedge 3
edge = project.geo.poly_edges(3).edge

node = project.topo.edge(edge(1)).node;

node_y = [project.topo.node(node(1)).y project.topo.node(node(2)).y ]