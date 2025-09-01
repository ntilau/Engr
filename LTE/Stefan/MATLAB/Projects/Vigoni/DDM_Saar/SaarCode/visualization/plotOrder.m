function [axesHandle] = plotOrder(project)

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

for faceCnt = 1:project.faceDim
    tmp = zeros(size(xVect)) ;
    tmp(TRI(faceCnt, :)) = project.hpStrategy.pElementOrder(faceCnt) ;
    trisurf(TRI(faceCnt, :), xVect, yVect, tmp) ;
    hold all ;
end
view([0, 0, 1]) ;
caxis([1 5]) ;
colormap(jet) ;
colorbar ;
axesHandle = gca ;