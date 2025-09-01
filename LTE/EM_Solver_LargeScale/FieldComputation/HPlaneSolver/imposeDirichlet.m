% IMPOSEDIRICHLET eliminates all rows and columns in system matrix 
% which are related to dirichlet values. Further the function adds 
% the corresponding contributions to the equation's rhs

function [SysMat, dirIndex] = imposeDirichlet(Model, SysMat)

Boundary = Model.Geo.Boundary;

% logical matrix for dirichlet indices
dirIndex = false(Model.nDofsRaw,1);

for iBound = 1:Model.Geo.nBoundaries
    bcType = Boundary(iBound).type;
    if strcmp(bcType, 'PEC2D')
        
        polyEdgeId = Boundary(iBound).polyEdgeId;    
        
        % select edges assigned to present poly_edge item
        edge = Model.Mesh.PolyEdge(polyEdgeId).edge;  
        node = unique(Model.Mesh.edge(edge, :))';
        
        if Model.pOrder == 1
            globalIndex = node;
        elseif Model.pOrder == 2
            globalIndex = [node, edge + Model.Mesh.nNodes];
        elseif Model.pOrder >= 3
            error('pOrder = %d is not implemented yet', Model.pOrder);
        end
              
        % set matrix coefficients related to dirichlet nodes                          
        dirIndex(globalIndex) = true;    
        
        for k = 1:length(SysMat)            
            SysMat(k).val(globalIndex,:) = 0;
            SysMat(k).val(:,globalIndex) = 0;
        end            
        
        iStiffMat = findMatrixIndex(SysMat, 'system matrix');
        for iIndex = globalIndex
            SysMat(iStiffMat).val(iIndex,iIndex) = 1;
        end
    end          
end