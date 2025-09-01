function [AxesHandle] = plotMesh(project)

xVect = project.topo.node(:, 1) ;
yVect = project.topo.node(:, 2) ;

for faceCnt = 1:project.faceDim
    
    edgeId1 = project.topo.face(faceCnt,1) ;
    edgeId2 = project.topo.face(faceCnt,2) ;
    edgeId3 = project.topo.face(faceCnt,3) ;

    nodeId1 = project.topo.edge(edgeId3, 1) ; % lowest node number
    nodeId2 = project.topo.edge(edgeId3, 2) ; % mid node number
    nodeId3 = project.topo.edge(edgeId1, 2) ; % highest node number
    
    TRI(faceCnt, :) = [nodeId1 nodeId2 nodeId3] ;

end
figure ;
plotHandle = triplot(TRI, xVect, yVect) ;
set(plotHandle, 'Color', 'black') ;
AxesHandle = gca ;