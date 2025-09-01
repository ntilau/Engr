function Mesh = setPolyObjectRelations(Mesh)
% set edge-polyEdge-relation
edge2polyEdge = [];
for k = 1:Mesh.nPolyEdges
    nEdges = length(Mesh.PolyEdge(k).edge);
    tmpEdge2polyEdge = zeros(2,nEdges);
    tmpEdge2polyEdge(1,:) = Mesh.PolyEdge(k).edge;
    tmpEdge2polyEdge(2,:) = k;    
    edge2polyEdge = [edge2polyEdge, tmpEdge2polyEdge]; %#ok<AGROW>
end
Mesh.edge2polyEdge = edge2polyEdge;


% set face-polyFace-relation
face2polyFace = [];
for k = 1:Mesh.nPolyFaces
    nFaces = length(Mesh.PolyFace(k).face);
    tmpFace2polyFace = zeros(2,nFaces);
    tmpFace2polyFace(1,:) = Mesh.PolyFace(k).face;
    tmpFace2polyFace(2,:) = k;    
    face2polyFace = [face2polyFace, tmpFace2polyFace]; %#ok<AGROW>
end
% every face must be assigned to a polyFace
if length(face2polyFace) ~= Mesh.nFaces
    error('There must be a unique relation between faces and polyFaces');
end
% sort relation for direct access
[tmpFace, iface] = sort(face2polyFace(1,:));
Mesh.face2polyFace = [tmpFace; face2polyFace(2,iface)];