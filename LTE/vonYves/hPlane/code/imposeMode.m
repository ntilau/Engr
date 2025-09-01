% IMPOSEDIRICHLET eliminates all rows and columns in system matrix 
% which are related to dirichlet values. Further the function add 
% the corresponding contributions to the equation's rhs

function imposeMode

global project E0 omega
global scalarOrder 
global rhsFEM systemMatrix


boundary = project.geo.boundary;
[tmp bcDim] = size(boundary);

for bcCnt=1:bcDim
    bcType = boundary(bcCnt).bcType;
    if strcmp(bcType, 'TRANSFINITE_BC')
        
        polyEdgesId = boundary(bcCnt).polyEdgesId;    
        
        [peStartNode peEndNode] = getPolyEdgesOuterNodes(polyEdgesId);
        % start node 
        nStart = [project.topo.node(peStartNode).y; project.topo.node(peStartNode).z];   
        
        
        % select edges assigned to present poly_edge item
        edge = project.geo.poly_edges(polyEdgesId).edge;        
        [tmp edgeDim] = size(edge);        
        
        % select nodes assigned to present poly_edge
        nodeOnPE = getInnerNodes(polyEdgesId, project);
        
        % ------------------------------------------------------------------
        % eliminate coefficients in system matrix, which are related with 
        % dirichlet bc's and add contribution to rhs
        % ------------------------------------------------------------------
        
        % handle matrix coefficients related to dirichlet nodes        
        if scalarOrder >= 1
            
            % select nodes assigned to present poly_edge item
            
            [tmp nodeDim] = size(nodeOnPE);
            
            for nodeCnt=1:nodeDim
                globalNodeId = project.topo.node(nodeOnPE(nodeCnt)).globalId;
                globIndex = project.geo.index(globalNodeId).scalarDomain;
                
                systemMatrix(globIndex, :) = 0;
                systemMatrix(:,globIndex) = 0;
                systemMatrix(globIndex, globIndex) = 1;                           
                
                d = sqrt((project.topo.node(peStartNode).y - project.topo.node(nodeOnPE(nodeCnt)).y)^2 ...
                    + (project.topo.node(peStartNode).z - project.topo.node(nodeOnPE(nodeCnt)).z)^2);
                
                rhsFEM(globIndex) = - j/omega * E0 * sin(d*pi/project.wg_width);
            end
        end
        
        if scalarOrder >= 2
            for edgeCnt = 1:length(edge)
                globalEdgeId = project.topo.edge(edge(edgeCnt)).globalId;
                globIndex = project.geo.index(globalEdgeId).scalarDomain;
                
                systemMatrix(globIndex, :) = 0;
                systemMatrix(:,globIndex) = 0;
                systemMatrix(globIndex, globIndex) = 1;                                           
                
                eNode = project.topo.edge(edge(edgeCnt)).node;
                n1 = [project.topo.node(eNode(1)).y; project.topo.node(eNode(1)).z];
                n2 = [project.topo.node(eNode(2)).y; project.topo.node(eNode(2)).z];
                % middle of edge
                d = n1 - n2;
                m = n2 + 0.5 * d;
                
                % waveguide coordinate
                s = norm(m - nStart);
                
                modeCoeff = - j/omega * E0 * sin(s*pi/project.wg_width);    
                
                rhsFEM(globIndex) = modeCoeff;                             
            end
        end
    end          
end







