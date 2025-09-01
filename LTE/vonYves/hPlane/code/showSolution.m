%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot of direction and absolute value of E-field
%
%   function call
%      function showSolution(solutionMatrix, showMesh)
%
%   input variables
%       solutionMatrix      ...column-vectors of phase-shifted solution
%       showMesh         ...if flag is set, triangulation will be plotted
%
%   output values
%       frames          ...frames for creating a movie
%       h               ...figure-handle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [frames, h] = showSolution(solutionMatrix, showMesh)

global project scalarOrder
global E0


% set parameters
inc  = 0.001 ;  % increment for point-in-element-detection
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

% determine number of frames
[tmp nrOfFrames] = size(solutionMatrix);

% initialise 3-dimensional arrays for electrical field components
Ey = zeros(fine, fine, nrOfFrames);
Ez = zeros(fine, fine, nrOfFrames);
E = zeros(fine, fine, nrOfFrames);

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
    
    
    % ---------------------------------------------------------    
    % calculate values of basis function in shared points for
    % each frames
    % ---------------------------------------------------------
    % get index of entries in system matrix for i-th element
    id = getIndex(faceCnt);  
    
    % calculate basis functions for actual element
    [NNz, NNy] = getBasisFunc(z1, z2, z3, y1, y2, y3, Zshared, Yshared);
    
    for frameCnt = 1:nrOfFrames
        
        % get calculated unknowns for these entries
        const = solutionMatrix(id,frameCnt) ;                       
        [row, col] = size(const) ;
        const = [const; zeros(15-row,1)] ;                
        
        for j = 1:m
            Ey(idz(j),idy(j),frameCnt) = real(const'*NNy(:,j));
            Ez(idz(j),idy(j),frameCnt) = real(const'*NNz(:,j));
            E(idy(j),idz(j),frameCnt) = sqrt( Ey(idz(j),idy(j),frameCnt)^2 + Ez(idz(j),idy(j),frameCnt)^2 );
        end
    end
end


% create mesh
[zcoord, ycoord] = meshgrid(Z,Y) ;

% set axis preferences
spaceFactor = max([length height]);
minZ = min(min(zcoord)) - 0.05 * spaceFactor;
minY = min(min(ycoord)) - 0.05 * spaceFactor;
maxZ = max(max(zcoord)) + 0.05 * spaceFactor;
maxY = max(max(ycoord)) + 0.05 * spaceFactor;


% determine caxis preferences
maxEMagnitude = max(max(max(E)));
% figure(1);
    
% plot mesh
if showMesh
    for ii = 1 : project.nodeDim
        ycoord_(ii) = project.topo.node(ii).y ;
        zcoord_(ii) = project.topo.node(ii).z ;
    end
    for ii = 1: project.faceDim
        TRI(ii, :) = getElemNode(ii) ;
    end

    triplot(TRI,ycoord_,zcoord_);
end

% ---------------------------------------------------------    
% plot all frames
% ---------------------------------------------------------
% Ey = Ey/maxEMagnitude/10000;
% Ez = Ez/maxEMagnitude/10000;


figHandle = figure;

for frameCnt = 1:nrOfFrames
    
    axes('PlotBoxAspectRatio', [abs(maxY - minY) abs(maxZ - minZ) 1]);
    axis([minY maxY minZ maxZ]);
    caxis([0 maxEMagnitude]);
    
    hold on;
    
    % color plot of E-magnitude
    h = pcolor(ycoord, zcoord, E(:,:,frameCnt));
    set(h, 'EdgeColor', 'none', 'FaceColor', 'interp') ;       
   
    frames(frameCnt) = getframe;
      
    hold off;    
end


                
                
            
