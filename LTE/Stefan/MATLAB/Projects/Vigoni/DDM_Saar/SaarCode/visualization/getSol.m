function Z = getSol(x, y, xxx, yyy, nodeIds, phi)

% global coordinates of triangle
nodeId1 = nodeIds(1);
nodeId2 = nodeIds(2);
nodeId3 = nodeIds(3);

x1 = xxx(1);
y1 = yyy(1);
x2 = xxx(2);
y2 = yyy(2);
x3 = xxx(3);
y3 = yyy(3);

% calculate shape functions
N1 = (y2 - y3) / (x2 .* y3 - x3 .* y2 - y1 .* x2 + y1 .* x3 + x1 .* y2 - x1 .* y3) .* x - (x2 - x3) / (x2 .* y3 - x3 .* y2 - y1 .* x2 + y1 .* x3 + x1 .* y2 - x1 .* y3) .* y + (x2 .* y3 - x3 .* y2) / (x2 .* y3 - x3 .* y2 - y1 .* x2 + y1 .* x3 + x1 .* y2 - x1 .* y3);
N2 = -(-y3 + y1) / (x2 .* y3 - x3 .* y2 - y1 .* x2 + y1 .* x3 + x1 .* y2 - x1 .* y3) .* x + (-x3 + x1) / (x2 .* y3 - x3 .* y2 - y1 .* x2 + y1 .* x3 + x1 .* y2 - x1 .* y3) .* y - (x1 .* y3 - y1 .* x3) / (x2 .* y3 - x3 .* y2 - y1 .* x2 + y1 .* x3 + x1 .* y2 - x1 .* y3);
N3 = -(y2 - y1) / (x2 .* y3 - x3 .* y2 - y1 .* x2 + y1 .* x3 + x1 .* y2 - x1 .* y3) .* x - (-x2 + x1) / (x2 .* y3 - x3 .* y2 - y1 .* x2 + y1 .* x3 + x1 .* y2 - x1 .* y3) .* y + (x1 .* y2 - y1 .* x2) / (x2 .* y3 - x3 .* y2 - y1 .* x2 + y1 .* x3 + x1 .* y2 - x1 .* y3);

c  = [phi(nodeId1) phi(nodeId2) phi(nodeId3)] ;

Z = c(1)*N1 + c(2)*N2 + c(3)*N3 ;
