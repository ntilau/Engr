function detJ = jacobianDet(faceCnt)

global project

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

% calculate determinante of jacobian 
detJ = z1 * y3 - z1 * y2 - y1 * z3 + y1 * z2 + y2 * z3 - y3 * z2;
