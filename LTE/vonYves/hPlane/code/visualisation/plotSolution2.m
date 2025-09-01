function plotSolution2(project, phi)

% initialize
nx = 200 ;
ny = 200 ;

inc = 1e-12 ;

maxX = max(project.topo.node(:,1)) ;
minX = min(project.topo.node(:,1)) ;

maxY = max(project.topo.node(:,2)) ;
minY = min(project.topo.node(:,2)) ;

hx = linspace(minX, maxX, nx) ;
hy = linspace(minY, maxY, ny) ;

hx = hx(2)-hx(1) ;
hy = hy(2)-hy(1) ;

[XX, YY] = meshgrid(minX:hx:maxX, minY:hy:maxY) ;

%%%%%%%test%%%%%%%%%%%
tmpXX(1:size(XX,1)^2) = XX(:,1:end) ;
tmpYY(1:size(YY,1)^2) = YY(:,1:end) ;
%%%%%%%test end%%%%%%%

sharedXX = zeros(size(XX)) ;
sharedYY = zeros(size(YY)) ;
Z = zeros(size(XX)) ;
Z_dummy = zeros(size(XX)) ;

usedPoint = sparse(size(XX, 1), size(XX, 2)) ;

for faceId = 1:project.faceDim
    
    % find max and min values of current triangle
    maxX = max(project.topo.node(project.topo.edge(project.topo.face(faceId,:),:),1)) ;
    minX = min(project.topo.node(project.topo.edge(project.topo.face(faceId,:),:),1)) ;
    maxY = max(project.topo.node(project.topo.edge(project.topo.face(faceId,:),:),2)) ;
    minY = min(project.topo.node(project.topo.edge(project.topo.face(faceId,:),:),2)) ;

    % find all XX and YY that share the current triangle
    id1x = find(XX(1,:) < maxX) ;
    id2x = find(XX(1,:) > minX) ;
    idx = intersect(id1x, id2x) ;
    endx = max(idx) ;
    startx = min(idx) ;

    id1y = find(YY(:,1) < maxY) ;
    id2y = find(YY(:,1) > minY) ;
    idy = intersect(id1y, id2y) ;
    endy = max(idy) ;
    starty = min(idy) ;
    
    % global coordinates of triangle
    edgeId1 = project.topo.face(faceId,1) ;
    edgeId3 = project.topo.face(faceId,3) ;

    nodeId1 = project.topo.edge(edgeId3, 1) ;
    nodeId2 = project.topo.edge(edgeId3, 2) ; 
    nodeId3 = project.topo.edge(edgeId1, 2) ; 
    
    x1 = project.topo.node(nodeId1, 1) ; 
    y1 = project.topo.node(nodeId1, 2) ;

    x2 = project.topo.node(nodeId2, 1) ; 
    y2 = project.topo.node(nodeId2, 2) ;

    x3 = project.topo.node(nodeId3, 1) ; 
    y3 = project.topo.node(nodeId3, 2) ;
    

    % calculate values in current triangle
    for ii = startx:endx
        for jj = starty:endy

            x = XX(jj,ii) ;
            y = YY(jj,ii) ; 

            % is point in element?
            A1 = 0.5 * abs(det([x  y  1 ; x1 y1 1 ; x2 y2 1])) ;
            A2 = 0.5 * abs(det([x  y  1 ; x2 y2 1 ; x3 y3 1])) ;
            A3 = 0.5 * abs(det([x  y  1 ; x3 y3 1 ; x1 y1 1])) ;
            A  = 0.5 * abs(det([x1 y1 1 ; x2 y2 1 ; x3 y3 1])) ;
            tmpVal = (A1+A2+A3)/A ;

            if((tmpVal < 1+inc)&&(tmpVal > 1-inc)) %if point is in element

                if usedPoint(jj, ii) == 0
                
                sharedXX(jj,ii) = XX(jj,ii) ;
                sharedYY(jj,ii) = YY(jj,ii) ;
                
                Z_dummy(jj,ii) = 1 ;
                
                usedPoint(jj, ii) = 1 ;             
                
                end
                
            end
        end
    end

    Z_tmp = getSol(sharedXX, sharedYY, faceId, project, phi, project.pOrder) ;%hpStrategy.pElementOrder(faceId)) ;
    Z = Z + Z_tmp.*Z_dummy ;
    
    clear sharedXX ;
    clear sharedYY ;
    clear Z_dummy ;
    sharedXX = zeros(size(XX)) ;
    sharedYY = zeros(size(YY)) ;
    Z_dummy = zeros(size(XX)) ;
end

tmpZ(1:size(XX,1)^2) = Z(:,1:end) ;

figure ;
surf(XX,YY,Z) ;

figure ;
h = pcolor(XX,YY,Z) ;
set(h, 'EdgeColor','none') ;

% figure(3) ;
% scatter(tmpXX, tmpYY, 18, tmpZ, 's', 'filled') ;