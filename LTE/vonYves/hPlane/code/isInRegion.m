function isIn = isInRegion(project, testPosition)


y = testPosition(1);
z = testPosition(2);

% tolerance 
tol = 0.05;

% initialise return value
isIn = false;

for faceCnt = 1:project.faceDim
      
    % collect nodes associated to present face
    elemNode = getElemNode(project, faceCnt);        
    
    % determine nodal coordinates
    y1 = project.topo.node(elemNode(1)).y;
    z1 = project.topo.node(elemNode(1)).z;
    y2 = project.topo.node(elemNode(2)).y;
    z2 = project.topo.node(elemNode(2)).z;
    y3 = project.topo.node(elemNode(3)).y;
    z3 = project.topo.node(elemNode(3)).z;            
    
    % is point in element?
    % A1-A3: areas of divided triangulars, A: whole element's area
    A1 = 0.5 * abs(det([z  y  1 ; z1 y1 1 ; z2 y2 1])) ;
    A2 = 0.5 * abs(det([z  y  1 ; z2 y2 1 ; z3 y3 1])) ;
    A3 = 0.5 * abs(det([z  y  1 ; z3 y3 1 ; z1 y1 1])) ;
    A  = 0.5 * abs(det([z1 y1 1 ; z2 y2 1 ; z3 y3 1])) ;
    tmpVal = (A1+A2+A3)/A ;
      
    if ((tmpVal < 1+tol) && (tmpVal > 1-tol)) %if point is in element
        isIn = true;
        return;        
    end   
end
