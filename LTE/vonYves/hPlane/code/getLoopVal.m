function [startz, endz, starty, endy] = getLoopVal(Z, Y, faceIndex)

global project

node = getElemNode(faceIndex);

node1z = project.topo.node(node(1)).z ;
node2z = project.topo.node(node(2)).z ;
node3z = project.topo.node(node(3)).z ;
nodez  = [node1z node2z node3z] ;

node1y = project.topo.node(node(1)).y ;
node2y = project.topo.node(node(2)).y ;
node3y = project.topo.node(node(3)).y ;
nodey  = [node1y node2y node3y] ;

maxz = max(nodez);
maxy = max(nodey) ;
minz = min(nodez) ;
miny = min(nodey) ;

id1z = find(Z<=maxz) ;
id2z = find(Z>=minz) ;
idz = intersect(id1z, id2z) ;
endz = max(idz) ;
startz = min(idz) ;

id1y = find(Y<=maxy) ;
id2y = find(Y>=miny) ;
idy = intersect(id1y, id2y) ;
endy = max(idy) ;
starty = min(idy) ;