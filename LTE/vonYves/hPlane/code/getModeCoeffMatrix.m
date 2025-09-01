% C = GETCOEFFMATRIX returns matrix C which contains the modal coefficients
% of the TE10-Mode for each waveguide port.
function [C, portSol] = getModeCoeffMatrix(project, scalarOrder, omega, E0)

% define number of variables in distinct domains
nonPortVarDim = project.geo.domain.nonPort.scalarDim;
overallVarDim = project.geo.domain.overallDim;

boundary = project.geo.boundary;
[tmp bcDim] = size(boundary);

port = project.geo.domain.port;
[tmp portDim] = size(port);

% matrix C has block structure. Left upper block is an identity matrix,
% right lower block A is a coefficient matrix containing the modal functions
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
        
        % determine outer nodes of poly_edge item
        [peStartNode peEndNode] = getPolyEdgesOuterNodes(project, polyEdgesId);  
        
        % determine alignment of poly_edge
        alignment = polyEdgesAlignment(project, peStartNode, peEndNode);     
        
        % poly_edge direction with respect to global coordinates
        globalPeOrientation = sign((project.topo.node(peEndNode).(alignment) - ...
            project.topo.node(peStartNode).(alignment)));
                        
        % select edges assigned to present poly_edge item
        edge = project.geo.poly_edges(polyEdgesId).edge;        
               
        % select nodes assigned to present poly_edge
        nodeOnPE = getInnerNodes(project, polyEdgesId);
        
        portVarDim = project.geo.domain.port(portCnt).scalarDim;
        
        A = zeros(portVarDim,1);
        
        % start node 
        nStart = [project.topo.node(peStartNode).y; project.topo.node(peStartNode).z];   
        
        for nodeCnt = 1:length(nodeOnPE)
            d = sqrt((project.topo.node(peStartNode).y - project.topo.node(nodeOnPE(nodeCnt)).y)^2 ...
                + (project.topo.node(peStartNode).z - project.topo.node(nodeOnPE(nodeCnt)).z)^2);

            modeCoeff = - j/omega * E0 * sin(d*pi/project.wg_width);

            A(nodeCnt, 1) = modeCoeff;
        end
        
        if scalarOrder >= 2
            for edgeCnt = 1:length(edge)
                eNode = project.topo.edge(edge(edgeCnt)).node;
                n1 = [project.topo.node(eNode(1)).y; project.topo.node(eNode(1)).z];
                n2 = [project.topo.node(eNode(2)).y; project.topo.node(eNode(2)).z];
                % middle of edge
                d = n1 - n2;
                m = n2 + 0.5 * d;
                
                % waveguide coordinate
                sm = norm(m - nStart);
                s1 = norm(n1 - nStart);
                s2 = norm(n2 - nStart);                                         
                            
                modeCoeff = - j/omega * E0 * ...
                    (sin(sm*pi/project.wg_width) - (sin(s1*pi/project.wg_width) + sin(s2*pi/project.wg_width)) / 2);
                
                A(edgeCnt + length(nodeOnPE), 1) = 4 * modeCoeff;
                
            end
        end
        
               
        % insert A-block in C-matrix
        C(CRowIndex:(CRowIndex + portVarDim - 1), CColIndex) = A;
        
        CRowIndex = CRowIndex + portVarDim - 1;
        portSol{portCnt} = C(:,CColIndex);
        clear A;
    end
end
        
        
