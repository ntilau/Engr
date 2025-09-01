function fieldSysMat = imposeTransfiniteBc
% IMPOSEDIRICHLET eliminates all rows and columns in system matrix 
% which are related to dirichlet values. Further the function add 
% the corresponding contributions to the equation's rhs

global project 
global scalarOrder vectorialOrder 
global systemMatrix rhs

fieldSysMat = systemMatrix;

boundary = project.geo.boundary;
[tmp bcDim] = size(boundary);

for bcCnt=1:bcDim
    bcType = boundary(bcCnt).bcType;
    if strcmp(bcType, 'TRANSFINITE_BC')
        
        dirichletValueX = boundary(bcCnt).dirichletValueX;
        dirichletValueYZ = boundary(bcCnt).dirichletValueYZ;
        
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
            vectorialDomainIndex = project.geo.index(globalEdgeId).vectorialDomain;
            
            % determine sizes
            [tmp scalarIndexDim] = size(scalarDomainIndex);
            [tmp vectorialIndexDim] = size(project.geo.index(globalEdgeId).vectorialDomain);      
            
            % scalar basis functions related edges
            for i=1:scalarIndexDim
                % in scalar domain only nodes carry dirichlet values unequal 
                % to zero -> no contribution to rhs      
                fieldSysMat(scalarDomainIndex(i), :) = 0;
                fieldSysMat(:, scalarDomainIndex(i)) = 0;
                fieldSysMat(scalarDomainIndex(i), scalarDomainIndex(i)) = 1;
                rhs(scalarDomainIndex(i), 1) = 0;
            end
            
            % vectorial basis functions related edges        
            for i=1:vectorialIndexDim
                % dirichlet values on higher order related components are always equal to zero
                % and thus make no contribution to rhs                            
                if (i == 1)
                    edgeLength = getEdgeLength(edge(edgeCnt));
                    edgeOrientation = getEdgeOrientation(edge(edgeCnt));
                    dirValYZ = edgeOrientation * dirichletValueYZ / edgeLength;
                else
                    dirValYZ = 0;
                end
                
                % shift affected col to rhs
                rhs = rhs - fieldSysMat(:,vectorialDomainIndex(i)) * dirValYZ;
                fieldSysMat(vectorialDomainIndex(i), :) = 0;
                fieldSysMat(:, vectorialDomainIndex(i)) = 0;
                fieldSysMat(vectorialDomainIndex(i), vectorialDomainIndex(i)) = 1;
                rhs(vectorialDomainIndex(i), 1) = dirValYZ;
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
                
                % shift affected col to rhs
                rhs = rhs - fieldSysMat(:,globIndex) * dirichletValueX;          
                
                fieldSysMat(globIndex, :) = 0;
                fieldSysMat(:,globIndex) = 0;
                fieldSysMat(globIndex, globIndex) = 1;
                rhs(globIndex) = dirichletValueX;
            end
        end 
    end
end