% IMPOSEDIRICHLET eliminates all rows and columns in system matrix 
% which are related to dirichlet values. Further the function add 
% the corresponding contributions to the equation's rhs

function [stiffMatrix, massMatrix, dirIndex] = ...
  imposeDirichlet(project, scalarOrder, stiffMatrix, massMatrix)

boundary = project.geo.boundary;
[tmp bcDim] = size(boundary);

% logical matrix for dirichlet indices
dirIndex = sparse(size(stiffMatrix));

for bcCnt=1:bcDim
    bcType = boundary(bcCnt).bcType;
    if strcmp(bcType, 'PEC2D')
        
        polyEdgesId = boundary(bcCnt).polyEdgesId;    
        
        % select edges assigned to present poly_edge item
        edge = project.geo.poly_edges(polyEdgesId).edge;        
        [tmp edgeDim] = size(edge);          
        
        % ------------------------------------------------------------------
        % eliminate coefficients in system matrix, which are related with 
        % dirichlet bc's and add contribution to rhs
        % ------------------------------------------------------------------
        
        % handle matrix coefficients related to dirichlet edges
        for edgeCnt=1:edgeDim
            
            globalEdgeId = project.topo.edge(edge(edgeCnt)).globalId;
            % extract system matrix indices for present edge
            scalarDomainIndex = project.geo.index(globalEdgeId).scalarDomain;
            
            % determine sizes
            [tmp scalarIndexDim] = size(scalarDomainIndex);
            
            % scalar basis functions related edges
            for i=1:scalarIndexDim  
                dirIndex(scalarDomainIndex(i), :) = 1;
                dirIndex(:, scalarDomainIndex(i)) = 1;     
                
                stiffMatrix(scalarDomainIndex(i), :) = 0;
                stiffMatrix(:, scalarDomainIndex(i)) = 0;
                stiffMatrix(scalarDomainIndex(i), scalarDomainIndex(i)) = 1;
                
                massMatrix(scalarDomainIndex(i), :) = 0;
                massMatrix(:, scalarDomainIndex(i)) = 0;
            end
            
        end
        
        % handle matrix coefficients related to dirichlet nodes        
        if scalarOrder >= 1
            
            % select nodes assigned to present poly_edge item
            node = [];
            for edgeCnt=1:edgeDim        
                node = [node project.topo.edge(edge(edgeCnt)).node];            
            end      
            
            node = unique(node);        
            
            [tmp nodeDim] = size(node);
            
            for nodeCnt=1:nodeDim
                globalNodeId = project.topo.node(node(nodeCnt)).globalId;
                globIndex = project.geo.index(globalNodeId).scalarDomain;
                                
                dirIndex(globIndex, :) = 1;
                dirIndex(:, globIndex) = 1;     
                
                stiffMatrix(globIndex, :) = 0;
                stiffMatrix(:,globIndex) = 0;
                stiffMatrix(globIndex, globIndex) = 1;
                
                massMatrix(globIndex, :) = 0;
                massMatrix(:,globIndex) = 0;
            end
        end
    end          
end