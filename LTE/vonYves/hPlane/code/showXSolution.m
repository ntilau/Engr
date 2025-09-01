%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot of direction and absolute value of E-field
%
%   function call
%      function showSolution(vec)
%
%   input variables
%      vec     ...solution vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showXSolution(vec)

global project
global vectorialOrder ScalarOrder

% set parameters
inc  = 0.1 ;  % increment for point-in-element-detection
fine = 100 ;  % resolution of meshgrid for direction plot
n    = 4 ;    % resolution of meshgrid for direction plot


% generate a meshgrid over the whole area
for nodeCnt = 1:project.nodeDim
    y(nodeCnt) = project.topo.node(nodeCnt).y;
    z(nodeCnt) = project.topo.node(nodeCnt).z;    
end

length = max(z) - min(z) ;
height = max(y) - min(y) ;

Z = linspace(min(z), max(z), fine) ;
Y = linspace(min(y), max(y), fine) ;

Ex = zeros(fine);

% calculate for all points within each element the values of Ex and Ey and
% store these values in two vectors for plotting
for faceCnt = 1:project.faceDim

    % reset values
    m = 0 ;
    Zshared = 0 ;
    Yshared = 0 ;
    idz = 0 ;
    idy = 0 ;
    
    [startz, endz, starty, endy] = getLoopVal(Z, Y, faceCnt) ;
    
    % collect edges associated to present face
    elemEdge = project.topo.face(faceCnt).edge;
          
    % collect nodes associated to present face
    elemNode = getElemNode(faceCnt);        
    
    % determine nodal coordinates
    y1 = project.topo.node(elemNode(1)).y;
    z1 = project.topo.node(elemNode(1)).z;
    y2 = project.topo.node(elemNode(2)).y;
    z2 = project.topo.node(elemNode(2)).z;
    y3 = project.topo.node(elemNode(3)).y;
    z3 = project.topo.node(elemNode(3)).z;            
        
    for j = startz:endz
        for k = starty:endy
            z = Z(j) ; % z-Nr of the point in element
            y = Y(k) ; % y-Nr of the point in element
            
            % is point in element?
            A1 = 0.5 * abs(det([z  y  1 ; z1 y1 1 ; z2 y2 1])) ;
            A2 = 0.5 * abs(det([z  y  1 ; z2 y2 1 ; z3 y3 1])) ;
            A3 = 0.5 * abs(det([z  y  1 ; z3 y3 1 ; z1 y1 1])) ;
            A  = 0.5 * abs(det([z1 y1 1 ; z2 y2 1 ; z3 y3 1])) ;
            tmpVal = (A1+A2+A3)/A ;
            
            if ((tmpVal < 1+inc)&&(tmpVal > 1-inc)) %if point is in element
                m = m+1;
                Zshared(m) = z ; % store z coordinate
                Yshared(m) = y ; % store y coordinate
                idz(m) = j ;    % store position of z in Z
                idy(m) = k ;    % store position of y in Y
                
            end
        end
    end
    
    % calculate values of basis function in shared points
      
    id    = getIndex(faceCnt) ;   % get index of entries in system matrix for i-th face
    const = vec(id) ;                       % get calculated unknowns for these entries
    [row, col] = size(const) ;
    const = [const; zeros(15-row,1)] ;
    
    [NNz, NNy] = getBasisFunc(z1, z2, z3, y1, y2, y3, Zshared, Yshared) ;
  
    for j = 1:m
        Ey(idz(j), idy(j)) = const'*NNy(:,j) ;
        Ez(idz(j), idy(j)) = const'*NNz(:,j) ;
    end
end

Ey = real(Ey);
Ez = real(Ez);

for i = 1:fine
    for j = 1:fine
        E(i,j) = sqrt(Ez(i,j)^2+Ey(i,j)^2) ;
    end
end


% plot mesh

% for ii = 1 : project.nodeDim
%     ycoord_(ii) = project.topo.node(ii).y ;
%     zcoord_(ii) = project.topo.node(ii).z ;
%     %zcoord(ii) = 0 ;
% end
% for ii = 1: project.faceDim
%     TRI(ii, :) = getElemNode(ii) ;
% end
% figure(1)
% triplot(TRI,ycoord_,zcoord_);
% hold on ;



figure(2);
[zcoord, ycoord] = meshgrid(Y,Z) ;
h = pcolor(ycoord, zcoord, E) ;
set(h, 'EdgeColor', 'none', 'FaceColor', 'interp') ;
view([0 0 -1]) ;
axis([min(min(ycoord)) max(max(ycoord)) min(min(zcoord)) max(max(zcoord))]);
hold on ;
h = quiver(ycoord(1:n:fine,1:n:fine), zcoord(1:n:fine,1:n:fine), Ey(1:n:fine,1:n:fine), Ez(1:n:fine,1:n:fine)) ;
set(h, 'Color', 'black') ;
hold off ;


                
                
            
