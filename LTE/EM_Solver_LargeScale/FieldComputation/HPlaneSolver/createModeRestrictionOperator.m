% The matrix C contains the modal coefficients of port fields, such that 
% C' * SystemMatrix * C is a compressed matrix with one DOF per port(mode)
function [C, Port] =...
    createModeRestrictionOperator(Model, k0, condScale)

Port = getPortData(Model);

% raw compression matrix
C = speye(Model.nDofsRaw);
iPortLogical = true(Model.nDofsRaw, 1);
% modal coefficients
M = sparse(Model.nDofsRaw, Model.nPorts);

for iPort = 1:Model.nPorts  
        
    nodePosition = Model.Mesh.position(Port(iPort).node,:);  
    startPosition = Model.Mesh.position(Port(iPort).startNode, :);                

    % local port coordinate with origin in startPosition
    xPort = sqrt((startPosition(1) - nodePosition(:,1)).^2 + ...
        (startPosition(2) - nodePosition(:,2)).^2);      
    
    % coefficients of TE10-mode
    E0 = condScale * computeEAmplitude(k0, Port(iPort).width);
    if any(Port(iPort).isPmcBounded)
        % mode normalization: int((sin(Pi * x / a))^2, x=0..a/2)
        E0 = sqrt(2) * E0;
    end
    
    freqScale = - 1j / Model.c0 * E0;
    modeAmplitude =  freqScale * sin(xPort * pi / Port(iPort).width);
    
    M(Port(iPort).node, iPort) = modeAmplitude;                
        
    if Model.pOrder >= 2 
        % hierarchical basis functions are used; higher order DOFs carry
        % only an offset
        edgeMidpoint = getEdgeMidpoint(Model.Mesh, Port(iPort).edge);        
        xPortMidpoint = sqrt((startPosition(1) - edgeMidpoint(:,1)).^2 +...
            (startPosition(2) - edgeMidpoint(:,2)).^2);        
        
        nEdgesOnPort = length(Port(iPort).edge);
        
        secondOrderSol = zeros(nEdgesOnPort, 1);
        firstOrderSol = zeros(nEdgesOnPort, 1);
        for k = 1:nEdgesOnPort
            iEdge = Port(iPort).edge(k);                       
             
            % edge end and start position
            node = Model.Mesh.edge(iEdge,:);
                     
            edgeOuter = Model.Mesh.position(node,:);
            % get first order solution at outer positions
            xPortOuter = sqrt((startPosition(1) - edgeOuter(:,1)).^2 +...
                (startPosition(2) - edgeOuter(:,2)).^2);
            firstOrderSol(k) = freqScale * 0.5 * (...
                sin(xPortOuter(1) * pi / Port(iPort).width) + ...
                sin(xPortOuter(2) * pi / Port(iPort).width));
            secondOrderSol(k) =  freqScale * ...
                sin(xPortMidpoint(k) * pi / Port(iPort).width);                                        
        end         
        
        modeCoeff = secondOrderSol - firstOrderSol;        
        % factor 4 stems from the choice of basis functions -> Ingelstrom
        M(Port(iPort).edge + Model.Mesh.nNodes, iPort) = 4 * modeCoeff; 
        
        % append midpoints and p2-solution to portField-components
        xPort = [xPort; xPortMidpoint]; %#ok<AGROW>
        modeAmplitude = [modeAmplitude; secondOrderSol];  %#ok<AGROW>
    end
    
    iPortLogical(Port(iPort).dof) = false;        
    Port(iPort).field = [xPort, modeAmplitude];            
end

% delete port-related coloums from C, append mode coefficients
C = [C(:,iPortLogical), M];

