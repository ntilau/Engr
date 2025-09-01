function plotFEM_solution(solutionFEM, project, order)

if order == 1
    for ii = 1 : project.nodeDim
        ycoord(ii) = project.topo.node(ii).y ;
        zcoord(ii) = project.topo.node(ii).z ;
        globID = project.topo.node(ii).globalId;
        sysMat_ID(ii) = project.geo.index(globID).scalarDomain;
    end
    for ii = 1: project.faceDim
        tri(ii, :) = getElemNode(ii) ;
    end

    trisurf(tri, ycoord, zcoord, solutionFEM(sysMat_ID));
end





if order == 2
    for ii = 1 : project.nodeDim
        tri.node(ii).y = project.topo.node(ii).y ;
        tri.node(ii).z = project.topo.node(ii).z ;
        tri.node(ii).globId = project.topo.node(ii).globalId;
        tri.node(ii).sysMatId = project.geo.index(globID).scalarDomain;
    end
    
    for ii = 1:project.edgeDim
        node = project.topo.edge(ii).node;
        n1 = [project.topo.node(node(1)).y; project.topo.node(node(1)).z];
        n2 = [project.topo.node(node(2)).y; project.topo.node(node(2)).z];
        
        n12 = n2 - n1;        
        m = n1 + 0.5 * n12;
        
        tri.node(project.nodeDim + ii).y = m(1);
        tri.node(project.nodeDim + ii).z = m(2) ;
        tri.node(project.nodeDim + ii).globId = project.topo.edge(ii).globalId;
        tri.node(project.nodeDim + ii).sysMatId = project.geo.index(globID).scalarDomain;
    end

    
    for fCnt = 1:project.faceDim
        edge = project.topo.face(fCnt).edge;
        node = getElemNode(fCnt);
       
        tri.face((fCnt - 1) * 4 + 1, :).node = [node(1) project.nodeDim + edge(3)  project.nodeDim + edge(2)];
        tri.face((fCnt - 1) * 4 + 1, :).node = [node(2) project.nodeDim + edge(1) project.nodeDim + edge(3)];
        tri.face((fCnt - 1) * 4 + 1, :).node = [node(3) project.nodeDim + edge(2) project.nodeDim + edge(1)];
        tri.face((fCnt - 1) * 4 + 1, :).node = [project.nodeDim + edge(1) project.nodeDim + edge(2) project.nodeDim + edge(3)];
    end
    
    figure;
    d = tri(2,[1 2 3 1])';
    plot(ycoord(d), zcoord(d));
    hold on;
    
    figure;
    triplot(tri(1:project.faceDim, :) , ycoord(1:project.nodeDim), zcoord(1:project.nodeDim));
    
    figure;
    triplot(tri(project.faceDim + 1:end, :) , ycoord(nodeDim+1:end), zcoord(nodeDim+1:end));  
    
    figure;
    trisurf(tri(1:project.faceDim, :) , ycoord(1:project.nodeDim), zcoord(1:project.nodeDim), solutionFEM(sysMat_ID(1:nodeDim)));

    hold on;
    trisurf(tri(project.faceDim + 1:end, :) , ycoord(nodeDim+1:end), zcoord(nodeDim+1:end), solutionFEM(sysMat_ID(nodeDim + 1:end)));  
    
    
%     figure;
%     triplot(tri, ycoord, zcoord);
    
%     trisurf(tri, ycoord, zcoord, solutionFEM(sysMat_ID));
end






