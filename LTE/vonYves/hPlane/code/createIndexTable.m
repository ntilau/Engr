function table = createIndexTable(project, scalarOrder)

% initialise table struct array with size 'componentDim'
table(project.componentDim) = struct('scalarDomain', []);

domain = project.geo.domain;
boundary = project.geo.boundary;

[tmp bcDim] = size(boundary);
portCnt = 0;

% assign system matrix indices
feIndex = 0;
portIndex = 0;
compIndex = 0;



nonPortOffset = domain.nonPort.scalarDim;
portOffset = 0;

% first index all components on the transfinite boundary
for bcCnt=1:bcDim
    bcType = boundary(bcCnt).bcType;
    
    if strcmp(bcType, 'TRANSFINITE_BC')
        
        % portCnt indicates the present port
        portCnt = portCnt + 1;
        % portIndex ensures the consecutive numbering on one port depending
        % on basis function orders
        portIndex = nonPortOffset + portOffset;
        % compIndex represents the consecutive numbering of one component
        % the component numbering occurs independently of basis function
        % orders
        compIndex = portIndex;
        
        % detect edges and nodes on present boundary
        polyEdgesId = boundary(bcCnt).polyEdgesId;                
        edge = project.geo.poly_edges(polyEdgesId).edge; 
        % outer nodes on poly_edge are assigned to poly_edges in vicinity
        node = getInnerNodes(project, polyEdgesId);
        
        [tmp edgeDim] = size(edge);
        [tmp nodeDim] = size(node);
        
        % scalar basis functions related components
        
        % -------------------------------------------
        % set indices for nodes on present boundary
        % -------------------------------------------
        if scalarOrder >= 1    
            for nodeCnt=1:nodeDim
                globalNodeId = project.topo.node(node(nodeCnt)).globalId;

                % check if indices are set
                if isempty(table(globalNodeId).scalarDomain)
                    compIndex = compIndex + 1;
                    table(globalNodeId).scalarDomain = compIndex;
                end
            end
        end
            
        
        % update compIndex
        compIndex = portIndex + domain.port(portCnt).nodeDim;
        
        
        % -------------------------------------------
        % set indices for edges on present boundary
        % -------------------------------------------
        
        % scalar basis functions related components
        for edgeCnt=1:edgeDim
            
            % determine global edge id
            globalEdgeId = project.topo.edge(edge(edgeCnt)).globalId;
            
            % positions in system matrix
            pos = [];
            if isempty(table(globalEdgeId).scalarDomain)
                compIndex = compIndex + 1;
                if scalarOrder >= 2
                    pos(1) = compIndex;
                end
                if scalarOrder >= 3
                    pos(2) = compIndex + edgeDim;
                end
                table(globalEdgeId).scalarDomain = pos;
            end
        end
        
        % update compIndex
        compIndex = portIndex + domain.port(portCnt).scalarDim;
        
        
        % update portOffset            
        portOffset = portOffset + domain.port(portCnt).scalarDim;
        
    end
end
    
    
% ------------------------------------------------------------------------
% index the remaining non-port components
% ------------------------------------------------------------------------

% reset compIndex
compIndex = 0;

% scalar basis functions related components
compIndex = feIndex;
for i=1:project.nodeDim
    
    globId = project.topo.node(i).globalId;
    if isempty(table(globId).scalarDomain)
        compIndex = compIndex + 1;
        if scalarOrder
            table(globId).scalarDomain = compIndex;
        end
    end
end

% update feIndex
feIndex = feIndex + domain.nonPort.nodeDim;
compIndex = feIndex;
for i=1:project.edgeDim
    
    globId = project.topo.edge(i).globalId;
    
    % positions in system matrix
    pos = [];             
    
    if isempty(table(globId).scalarDomain)
        compIndex = compIndex + 1;    
        if scalarOrder >= 2
            pos(1) = compIndex;
        end
        if scalarOrder >= 3
            pos(2) = compIndex + domain.nonPort.edgeDim;
        end
        table(globId).scalarDomain = pos;
    end
end    

% update feIndex
feIndex = feIndex + 2*domain.nonPort.edgeDim;
compIndex = feIndex;

for i=1:project.faceDim
    
    globId = project.topo.face(i).globalId;
    if isempty(table(globId).scalarDomain)
        compIndex = compIndex + 1;
        if scalarOrder >= 3
            table(globId).scalarDomain = compIndex;
        end
    end
end    



