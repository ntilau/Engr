function orientation = getPolyEdgesLocalOrientation(project, startNode, endNode)

startY = project.topo.node(startNode).y;
startZ = project.topo.node(startNode).z;
endY = project.topo.node(endNode).y;
endZ = project.topo.node(endNode).z;

% get midpoint of poly_edge
m = 0.5 * ([startY + endY; startZ + endZ]);

% rotary matrix (counter clockwise rotation)
phi = .25 * pi;
R = [cos(phi), -sin(phi); sin(phi), -cos(phi)];

% rotate midpoint of poly_edge 
testPosition = R * m + [startY; startZ];

% check whether testPosition is element of field region
isIn = isInRegion(project, testPosition);

if isIn
    % orientation of poly_edge is contrary to local y-direction
    orientation = -1;
else
    orientation = 1;
end
