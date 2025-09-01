function [f1AxesHandle, f2AxesHandle] = plotSolution(xy, solVec, MESH)

% initialize
nx = 200 ;
ny = 200 ;

inc = 1e-12 ;


maxX = max(xy(1,:)) ;
minX = min(xy(1,:)) ;

maxY = max(xy(2,:)) ;
minY = min(xy(2,:)) ;

hx = linspace(minX, maxX, nx) ;
hy = linspace(minY, maxY, ny) ;

hx = hx(2)-hx(1) ;
hy = hy(2)-hy(1) ;

[XX, YY] = meshgrid(minX:hx:maxX, minY:hy:maxY) ;

sharedXX = zeros(size(XX)) ;
sharedYY = zeros(size(YY)) ;
Z = zeros(size(XX)) ;
Z_dummy = zeros(size(XX)) ;

usedPoint = sparse(size(XX, 1), size(XX, 2)) ;
for domCnt = 1:size(MESH, 2)
  
  for faceId = 1:size(MESH{domCnt}.ele, 2)
    
    % find max and min values of current triangle
    maxX = max(xy(1, MESH{domCnt}.ele(2:4, faceId)));
    minX = min(xy(1, MESH{domCnt}.ele(2:4, faceId)));
    maxY = max(xy(2, MESH{domCnt}.ele(2:4, faceId)));
    minY = min(xy(2, MESH{domCnt}.ele(2:4, faceId)));

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
    x1 = xy(1, MESH{domCnt}.ele(2, faceId)); 
    y1 = xy(2, MESH{domCnt}.ele(2, faceId));

    x2 = xy(1, MESH{domCnt}.ele(3, faceId));
    y2 = xy(2, MESH{domCnt}.ele(3, faceId));

    x3 = xy(1, MESH{domCnt}.ele(4, faceId));
    y3 = xy(2, MESH{domCnt}.ele(4, faceId));
    
    xxx = [x1, x2, x3];
    yyy = [y1, y2, y3];
    
    nodeIds = MESH{domCnt}.ele(2:4, faceId);

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

    Z_tmp = getSol(sharedXX, sharedYY, xxx, yyy, nodeIds, solVec) ;
    
    Z = Z + Z_tmp.*Z_dummy ;
    
    clear sharedXX ;
    clear sharedYY ;
    clear Z_dummy ;
    sharedXX = zeros(size(XX)) ;
    sharedYY = zeros(size(YY)) ;
    Z_dummy = zeros(size(XX)) ;
  end
end

tmpZ(1:size(XX,1)^2) = Z(:,1:end) ;

f2Handle = pcolor(XX,YY,Z) ;
set(f2Handle, 'EdgeColor','none', 'FaceColor', 'interp') ;
f2AxesHandle = gca ;
colorbar ;

figure ;
f1Handle = surf(XX,YY,Z) ;
set(f1Handle, 'LineStyle', 'none', 'FaceColor', 'interp') ;
f1AxesHandle = gca ;
colorbar ;