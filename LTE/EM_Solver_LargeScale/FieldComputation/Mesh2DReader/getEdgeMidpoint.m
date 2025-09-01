function edgeMidpoint = getEdgeMidpoint(Mesh, edgeId)

node = Mesh.edge(edgeId,:);

positionStart = Mesh.position(node(:,1),:);
positionEnd = Mesh.position(node(:,2),:);

edgeMidpoint = positionStart + 0.5 * (positionEnd - positionStart);