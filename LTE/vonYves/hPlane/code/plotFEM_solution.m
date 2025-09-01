function F = plotFEM_solution(solutionFEM, project, order)


Nsample = 18;

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
    
    
    for angleCnt = 1:Nsample
        angle = (angleCnt - 1) * 360 / Nsample;
        rad = pi/180 * angle;
        s = exp(2*j*rad) * solutionFEM;
        trisurf(tri, ycoord, zcoord, s(sysMat_ID));
        view(0,90);
        F(angleCnt) = getframe;
    end
end





if order == 2
    for ii = 1 : project.nodeDim
        tri.node(ii).y = project.topo.node(ii).y ;
        tri.node(ii).z = project.topo.node(ii).z ;
        tri.node(ii).globId = project.topo.node(ii).globalId;
        tri.node(ii).sysMatId = project.geo.index(tri.node(ii).globId).scalarDomain;
        tri.node(ii).solution = solutionFEM(tri.node(ii).sysMatId);       
    end
    
    for ii = 1:project.edgeDim
        node = project.topo.edge(ii).node;
        n1.coord = [project.topo.node(node(1)).y; project.topo.node(node(1)).z];
        n2.coord = [project.topo.node(node(2)).y; project.topo.node(node(2)).z];
        n1.sol = tri.node(node(1)).solution;
        n2.sol = tri.node(node(2)).solution;    
        
        node_sol = (n1.sol + n2.sol) / 2;
        
        n12 = n2.coord - n1.coord;        
        m = n1.coord + 0.5 * n12;
        
        tri.node(project.nodeDim + ii).y = m(1);
        tri.node(project.nodeDim + ii).z = m(2) ;
        tri.node(project.nodeDim + ii).globId = project.topo.edge(ii).globalId;
        tri.node(project.nodeDim + ii).sysMatId = project.geo.index(tri.node(project.nodeDim + ii).globId).scalarDomain;
        tri.node(project.nodeDim + ii).solution = 0.25 * solutionFEM(tri.node(project.nodeDim + ii).sysMatId) + node_sol;
    end

    
    for fCnt = 1:project.faceDim
        edge = project.topo.face(fCnt).edge;
        node = getElemNode(fCnt);
       
        tri.face((fCnt - 1) * 4 + 1, :).node = [node(1) project.nodeDim + edge(3)  project.nodeDim + edge(2)];
        tri.face((fCnt - 1) * 4 + 2, :).node = [node(2) project.nodeDim + edge(1) project.nodeDim + edge(3)];
        tri.face((fCnt - 1) * 4 + 3, :).node = [node(3) project.nodeDim + edge(2) project.nodeDim + edge(1)];
        tri.face((fCnt - 1) * 4 + 4, :).node = [project.nodeDim + edge(1) project.nodeDim + edge(2) project.nodeDim + edge(3)];
    end
    
    for nodeCnt = 1:length(tri.node)
        y(nodeCnt) = tri.node(nodeCnt).y;
        z(nodeCnt) = tri.node(nodeCnt).z;
        sysMatId(nodeCnt) = tri.node(nodeCnt).sysMatId;
        solution(nodeCnt) = tri.node(nodeCnt).solution;
    end
    
    for triCnt = 1:length(tri.face)
         face(triCnt,:) = (tri.face(triCnt).node);
    end
    
%     figure;
%     triplot(face, y, z);

    figure;
    
    for angleCnt = 1:Nsample
        angle = (angleCnt - 1) * 360 / Nsample;
        rad = pi/180 * angle;
        s = exp(2*j*rad) * solution;
        trisurf(face, y, z, s);
        zlim([-1e-7 1e-7]);
%         view(0,90);
        F(angleCnt) = getframe;
    end
end






