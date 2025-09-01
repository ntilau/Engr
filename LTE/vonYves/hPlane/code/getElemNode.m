% NODE = GEGTELEMNODE(FACECNT) returns array NODE, where the indices
% correspond with the local numbering:
% node(i) is opponent of edge(i) 
% Order of ...face(k).edge(j) corresponds to the sum of node-id's
%   (see also getFaceData.m)

function node = getElemNode(project, faceCnt)

node(2) = project.topo.edge(project.topo.face(faceCnt).edge(1)).node(1);
node(3) = project.topo.edge(project.topo.face(faceCnt).edge(1)).node(2);
node(1) = project.topo.edge(project.topo.face(faceCnt).edge(2)).node(1);
