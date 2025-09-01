
function imposeTransfiniteElements

global project 
global scalarOrder vectorialOrder 
global systemMatrix rhs

% define number of variables in distinct domains
nonPortVarDim = project.geo.domain.nonPort.scalarDim + project.geo.domain.nonPort.vectorialDim;
overallVarDim = project.geo.domain.overallDim;

boundary = project.geo.boundary;
[tmp bcDim] = size(boundary);

port = project.geo.domain.port;
[tmp portDim] = size(port);

% matrix C has block structure. Left upper block is the identity matrix,
% right lower block A is a coefficient matrix for expressing the modal
% functions
C = sparse(1:nonPortVarDim, 1:nonPortVarDim, 1, overallVarDim, nonPortVarDim + portDim);

% define row start index and column start index of C-matrix where A-blocks should be inserted
CRowIndex = nonPortVarDim;
CColIndex = nonPortVarDim;

portCnt = 0;
for bcCnt=1:bcDim
    bcType = boundary(bcCnt).bcType;
    if strcmp(bcType, 'TRANSFINITE_BC')
                
        CRowIndex = CRowIndex + 1;
        CColIndex = CColIndex + 1;
        portCnt = portCnt + 1;
        
        polyEdgesId = boundary(bcCnt).polyEdgesId;    
        
        % select edges assigned to present poly_edge item
        edge = project.geo.poly_edges(polyEdgesId).edge;        
        [tmp edgeDim] = size(edge);       
        
        % in case of TE10-mode as only propagating wave,
        % A is a coefficient vector which matches only 
        % first order vectorial basis functions on the ports
        portVarDim = project.geo.domain.port(portCnt).scalarDim + project.geo.domain.port(portCnt).vectorialDim;
        portScalarDim = project.geo.domain.port(portCnt).scalarDim;
        
        A = sparse(portVarDim,1);
        
        for edgeCnt=1:edgeDim
            
            edgeLength = getEdgeLength(edge(edgeCnt));
            edgeOrientation = getEdgeOrientation(edge(edgeCnt));
            
            A(portScalarDim + edgeCnt, 1) = edgeOrientation * E0 / edgeLength;
        end
        
        % insert A-block in C-matrix
        C(CRowIndex:(CRowIndex + portVarDim - 1), CColIndex) = A;
    end
end
        
        
