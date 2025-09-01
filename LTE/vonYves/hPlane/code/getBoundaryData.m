% GETBOUNDARYDATA(BOUNDARY, MESH) adds the poly_edges id's to 
% the boundary struct, since it allows a direct subscript.
% Besides the number of edges and nodes per boundary item is stored 

function bc = getBoundaryData(boundary, mesh)

% initialise return value
bc = boundary;

[tmp bcDim] = size(boundary);

% on pec boundary: #nodes = #edges + 1,
% on tf boundary: #nodes = #edges - 1
nodeCorrect = 0;

% loop over all boundary-items
for bcCnt=1:bcDim
    
    bcType = bc(bcCnt).bcType;
    
    if strcmp(bcType, 'PEC2D')
        nodeCorrect = 1;
    elseif strcmp(bcType, 'TRANSFINITE_BC')
        nodeCorrect = -1;
    end
               
    % extract polyEdgesName of present boundary-item
    polyEdgesName = boundary(bcCnt).polyEdgesName;
    
    % loop over all poly_edges in mesh
    for peCnt=1:mesh.poly_edgesDim
        
        % determine if polyEdgesName from boundary-item matches 
        % polyEdgesName of mesh.poly_edges-item
        if strcmp(mesh.poly_edges(peCnt).itemName, polyEdgesName)
                     
            % count all edges in this poly_edge item
            [tmp edgeDim] = size(mesh.poly_edges(peCnt).edge);
            
            % assign poly_edges-id to boundary item
            bc(bcCnt).polyEdgesId = peCnt;         
            
            % assign calculated sizes 
            bc(bcCnt).edgeDim = edgeDim;            
            bc(bcCnt).nodeDim = edgeDim + nodeCorrect;
        end
    end
end

        
        
        