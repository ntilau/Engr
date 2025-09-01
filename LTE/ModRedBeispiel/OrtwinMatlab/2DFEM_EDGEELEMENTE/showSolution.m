%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot of direction and absolute value of E-field
%
%   function call
%      function showSolution(val, vec, project, order)
%
%   input variables
%      val     ...eigenvalue to plot
%      vec     ...corresponding eigenvector to eigenvalue
%      project ...information about topology
%      order   ...order of vector basis function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showSolution(val, vec, project, order)

% set parameters
inc  = 0.1 ;  % increment for point-in-element-detection
fine = 100 ;  % resolution of meshgrid for direction plot
n    = 4 ;    % resolution of meshgrid for direction plot

% get number of nodes, edges and elements
[dimNode, dimEdge, dimElem] = getDim(project) ;

% generate a meshgrid over the whole area
for ii = 1:dimNode
    x(ii) = project.netz.node(ii).x ;
    y(ii) = project.netz.node(ii).y ;
end
width = max(x) ;
height = max(y) ;

X = linspace(0, width, fine) ;
Y = linspace(0, height, fine) ;

% calculate for all points within each element the values of Ex and Ey and
% store these values in two vectors for plotting
for ii = 1:dimElem

    % reset values
    m = 1 ;
    Xshared = 0 ;
    Yshared = 0 ;
    idx = 0 ;
    idy = 0 ;
    
    [startx, endx, starty, endy] = getLoopVal(project, X, Y, ii) ;
    
    x1 = project.netz.node(project.netz.edge(project.netz.elem(ii).edge(3)).n0).x ; %1
    x2 = project.netz.node(project.netz.edge(project.netz.elem(ii).edge(1)).n0).x ; %2
    x3 = project.netz.node(project.netz.edge(project.netz.elem(ii).edge(1)).n1).x ; %3
    y1 = project.netz.node(project.netz.edge(project.netz.elem(ii).edge(3)).n0).y ; %1
    y2 = project.netz.node(project.netz.edge(project.netz.elem(ii).edge(1)).n0).y ; %2
    y3 = project.netz.node(project.netz.edge(project.netz.elem(ii).edge(1)).n1).y ; %3 
    
    for jj = startx:endx
        for kk = starty:endy
            x = X(jj) ; % x-Nr of the point in element
            y = Y(kk) ; % y-Nr of the point in element
            
            % is point in element?
            A1 = 0.5 * abs(det([x  y  1 ; x1 y1 1 ; x2 y2 1])) ;
            A2 = 0.5 * abs(det([x  y  1 ; x2 y2 1 ; x3 y3 1])) ;
            A3 = 0.5 * abs(det([x  y  1 ; x3 y3 1 ; x1 y1 1])) ;
            A  = 0.5 * abs(det([x1 y1 1 ; x2 y2 1 ; x3 y3 1])) ;
            tmpVal = (A1+A2+A3)/A ;
            
            if((tmpVal < 1+inc)&&(tmpVal > 1-inc)) %if point is in element
                Xshared(m) = x ; % store x coordinate
                Yshared(m) = y ; % store y coordinate
                idx(m) = jj ;    % store position of x in X
                idy(m) = kk ;    % store position of y in Y
                m = m+1;
            end
        end
    end
    
    % calculate values of basis function in shared points
    id    = getIndex(ii, project, order) ; % get index of entries in system matrix for iith element
    const = vec(id) ;                      % get calculated unknowns for these entries
    [row, col] = size(const) ;
    const = [const; zeros(15-row,1)] ;
    
    [NNx, NNy] = getBasisFunc(x1, x2, x3, y1, y2, y3, Xshared, Yshared,m) ;
  
    for jj = 1:(m-1)
        Ey(idx(jj), idy(jj)) = const'*NNy(:,jj) ;
        Ex(idx(jj), idy(jj)) = const'*NNx(:,jj) ;
    end
end
for ii = 1:fine
    for jj = 1:fine
        E(ii,jj) = sqrt((Ex(ii,jj))^2+(Ey(ii,jj))^2) ;
    end
end
figure;
[xcoord, ycoord] = meshgrid(X,Y) ;
h = pcolor(xcoord, ycoord, E) ;
set(h, 'EdgeColor', 'none', 'FaceColor', 'interp') ;
view([0 0 -1]) ;
axis([min(min(xcoord)) max(max(xcoord)) min(min(ycoord)) max(max(ycoord))]);
hold on ;
h = quiver(xcoord(1:n:fine,1:n:fine), ycoord(1:n:fine,1:n:fine), Ex(1:n:fine,1:n:fine), Ey(1:n:fine,1:n:fine)) ;
set(h, 'Color', 'black') ;
hold off ;


                
                
            
