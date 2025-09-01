function T_vv = massMatrixAssembly(T_vv1, T_vv2, T_vv3, detJ)

global project

tic
% collect edges associated to present face
elemEdge = project.topo.face(faceCnt).edge;
% collect nodes associated to present face    
elemNode = getElemNode(faceCnt);

% determine nodal coordinates
y1 = project.topo.node(elemNode(1)).y;
z1 = project.topo.node(elemNode(1)).z;
y2 = project.topo.node(elemNode(2)).y;
z2 = project.topo.node(elemNode(2)).z;
y3 = project.topo.node(elemNode(3)).y;
z3 = project.topo.node(elemNode(3)).z; 
toc

gradEta2 = z1 ^ 2 - 2 * z1 * z3 + z3 ^ 2 + y1 ^ 2 - 2 * y1 * y3 + y3 ^ 2;
gradEtagradZeta = z2 * z1 - z2 * z3 - z1 ^ 2 + z1 * z3 - y1 ^ 2 + y1 * y3 + y2 * y1 - y2 * y3;
gradZeta2 = z2 ^ 2 - 2 * z2 * z1 + z1 ^ 2 + y1 ^ 2 - 2 * y2 * y1 + y2 ^ 2;

T_vv = 