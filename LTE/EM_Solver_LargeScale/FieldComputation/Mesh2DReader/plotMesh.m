function AxesHandle = plotMesh(Mesh)

tri = zeros(Mesh.nFaces, 3);
for faceCnt = 1:Mesh.nFaces;    
    edge = Mesh.face(faceCnt,:);
    node = unique(Mesh.edge(edge,:));            
    tri(faceCnt, :) = node;
end

figure;
plotHandle = triplot(tri, Mesh.position(:,1), Mesh.position(:,2)) ;
set(plotHandle, 'Color', 'black') ;
AxesHandle = gca ;

axis equal;
axis tight;