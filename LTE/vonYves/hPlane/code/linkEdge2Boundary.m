% LINKEDGE2BOUNDARY creates a table which establishes a relation
% between edges and boundary

function table = linkEdge2Boundary(project)

boundary = project.geo.boundary;
[tmp bcDim] = size(boundary);

% initialise link table. Values for not involved edges remain zero
table = zeros(1,project.edgeDim);

% consider all boundaries, select the involved edges and create
% the edge-boundary relation
for bcCnt=1:bcDim
    polyEdgesId = boundary(bcCnt).polyEdgesId;
    edge = project.geo.poly_edges(polyEdgesId).edge;
    [tmp edgeDim] = size(edge);
    
    for edgeCnt=1:edgeDim
        % assign bcCnt (=boundaryId)
        table(edge(edgeCnt)) = bcCnt;
    end
end
    

