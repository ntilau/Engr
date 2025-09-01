% GETDOMAINDIMENSIONS returns a struct array with index-offsets
% to find a components position in the system matrix. 
% Besides in field 'overallDim' the size of the whole system is stored

function domain = getDomainDimensions(project, scalarOrder)

% initialise return value
domain = struct;

boundary = project.geo.boundary;
[tmp bcCnt] = size(boundary);

% determine dimensions on all ports with transfinite boundary conditions
portCnt = 0;

% count overall number of components on ports
nodesOnPorts = 0;
edgesOnPorts = 0;

for i=1:bcCnt
    bcType = boundary(i).bcType;
    
    if strcmp(bcType, 'TRANSFINITE_BC')                
        portCnt = portCnt + 1;
        
        % number of nodes and edges on present port
        domain.port(portCnt).nodeDim = boundary(i).nodeDim;
        domain.port(portCnt).edgeDim = boundary(i).edgeDim;
        
        % accumulate nodes and edges on all ports
        nodesOnPorts = nodesOnPorts + domain.port(portCnt).nodeDim;
        edgesOnPorts = edgesOnPorts + domain.port(portCnt).edgeDim;
    end
end

% determine number of non-port components
nonPortNodeDim = project.nodeDim - nodesOnPorts;
nonPortEdgeDim = project.edgeDim - edgesOnPorts;


% determine domain dimensions depending on scalar order
switch scalarOrder
    case 0
        domain.nonPort.scalarDim = 0;
        for i=1:portCnt
            domain.port(i).scalarDim = 0;
        end
        
    case 1                                   
        domain.nonPort.scalarDim = nonPortNodeDim;
        for i=1:portCnt
            domain.port(i).scalarDim = domain.port(i).nodeDim;
        end
        
    case 2
        domain.nonPort.scalarDim = nonPortNodeDim + nonPortEdgeDim;
        for i=1:portCnt
            domain.port(i).scalarDim = domain.port(i).nodeDim + domain.port(i).edgeDim;
        end
        
    case 3
        domain.nonPort.scalarDim = nonPortNodeDim + 2*nonPortEdgeDim + project.faceDim;
        for i=1:portCnt
            domain.port(i).scalarDim = domain.port(i).nodeDim + 2*domain.port(i).edgeDim;
        end  
end


% calculate whole sytem dimension
allPortsScalDim = 0;
for i=1:portCnt
    allPortsScalDim = allPortsScalDim + domain.port(i).scalarDim;
end

domain.overallDim = domain.nonPort.scalarDim + allPortsScalDim;

% return the non port dimensions
domain.nonPort.nodeDim = nonPortNodeDim;
domain.nonPort.edgeDim = nonPortEdgeDim;


