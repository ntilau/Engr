function plotFEM_solution(solutionFEM, project, order)

if order == 1
    for ii = 1 : project.nodeDim
        ycoord(ii) = project.topo.node(ii).y ;
        zcoord(ii) = project.topo.node(ii).z ;
        globID = project.topo.node(ii).globalId;
        sysMat_ID(ii) = project.geo.index(globID).scalarDomain;
    end
    for ii = 1: project.faceDim
        TRI(ii, :) = getElemNode(ii) ;
    end

    trisurf(TRI, ycoord, zcoord, solutionFEM(sysMat_ID));
end


if order == 2
    ycoord = zeros(project.nodeDim + project.edgeDim, 1);
    xcoord = zeros(project.nodeDim + project.edgeDim, 1);
    
    nodeDim = project.nodeDim;
    for ii = 1 : project.nodeDim
        ycoord(ii) = project.topo.node(ii).y ;
        zcoord(ii) = project.topo.node(ii).z ;
        globID = project.topo.node(ii).globalId;
        sysMat_ID(ii) = project.geo.index(globID).scalarDomain;
    end
    
    for n = 1:project.edgeDim
        node = project.topo.edge(n).node;
        n1 = [project.topo.node(node(1)).y; project.topo.node(node(1)).z];
        n2 = [project.topo.node(node(2)).y; project.topo.node(node(2)).z];
        
        n12 = n2 - n1;
        
        m = n1 + 0.5 * n12;
        ycoord(nodeDim + n) = m(1);
        zcoord(nodeDim + n) = m(2);   
        globID = project.topo.edge(n).globalId;
        sysMat_ID(nodeDim + n) = project.geo.index(globID).scalarDomain;
        
        
    end
    for ii = 1: project.faceDim
        TRI(ii, :) = getElemNode(ii);
    end
    for ii = 1: project.faceDim
        TRI(project.faceDim + ii, :) = project.topo.face(ii).edge;
    end
     
    figure;
    d = TRI(1,[1 2 3 1])';
    plot(xcoord(d), ycoord(d));
    
    figure;
    triplot(TRI(1:project.faceDim, :) , ycoord(1:project.nodeDim), zcoord(1:project.nodeDim));
    
    figure;
    triplot(TRI(project.faceDim + 1:end, :) , ycoord(nodeDim+1:end), zcoord(nodeDim+1:end));  
    
    figure;
    trisurf(TRI(1:project.faceDim, :) , ycoord(1:project.nodeDim), zcoord(1:project.nodeDim), solutionFEM(sysMat_ID(1:nodeDim)));

    hold on;
    trisurf(TRI(project.faceDim + 1:end, :) , ycoord(nodeDim+1:end), zcoord(nodeDim+1:end), solutionFEM(sysMat_ID(nodeDim + 1:end)));  
    
    
%     figure;
%     triplot(TRI, ycoord, zcoord);
    
%     trisurf(TRI, ycoord, zcoord, solutionFEM(sysMat_ID));
end






