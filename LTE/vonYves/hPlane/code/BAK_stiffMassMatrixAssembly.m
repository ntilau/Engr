% -------------------------------------------------------
% stiffness and mass matrix assembly by calculating the contributions
% of each finite element
% -------------------------------------------------------

function stiffMassMatrixAssembly

global project 
global scalarDim 
global stiffMatrix massMatrix



% -------------------------------------------------------
% read element matrices
% -------------------------------------------------------
ElementMatrix = elementMatrixReader;

% scalar mass matrix
MasterT_ss = eval(ElementMatrix.T_ss);
% vectorial mass matrices
MasterT_vv1 = eval(ElementMatrix.T_vv1);
MasterT_vv2 = eval(ElementMatrix.T_vv2);
MasterT_vv3 = eval(ElementMatrix.T_vv3);

% ------------------------------------------------------- 
% create discrete gradient operator
% -------------------------------------------------------
discreteGrad = getGradientOperator;
discreteGradTransp = discreteGrad';

% -------------------------------------------------------
% assembly system matrix
% -------------------------------------------------------
for faceCnt = 1:project.faceDim
    
    % collect edges associated to present face
    elemEdge = project.topo.face(faceCnt).edge;
    % collect nodes associated to present face    
    elemNode = getElemNode(faceCnt);
    
    % determine nodal coordinates
    y1 = project.topo.node(elemNode(1)).y;
    z1 = project.topo.node(elemNode(1)).z;
    y2 = project.topo.node(elemNode(2)).y;
    z2 = project.topo.node(elemNode(2)).z;
    y3 = project.topo.node(elemNode(3)).y;
    z3 = project.topo.node(elemNode(3)).z; 

    % --------------------------------------------------------------    
    % evaluate element matrices
    % --------------------------------------------------------------
    
    % calculate determinante of jacobian 
    detJ = abs(z1 * y3 - z1 * y2 - y1 * z3 + y1 * z2 + y2 * z3 - y3 * z2);
    
    % calculate gradients of local coordinates (proportional to 1/(detJ^2))
    gradEta2 = z1 ^ 2 - 2 * z1 * z3 + z3 ^ 2 + y1 ^ 2 - 2 * y1 * y3 + y3 ^ 2;
    gradEtaGradZeta = z2 * z1 - z2 * z3 - z1 ^ 2 + z1 * z3 - y1 ^ 2 + y1 * y3 + y2 * y1 - y2 * y3;
    gradZeta2 = z2 ^ 2 - 2 * z2 * z1 + z1 ^ 2 + y1 ^ 2 - 2 * y2 * y1 + y2 ^ 2;    
        
    % create T_vv matrix
    T_vv = 1 / detJ * (gradEta2 * MasterT_vv1 + gradEtaGradZeta * MasterT_vv2 + gradZeta2 * MasterT_vv3);     
    
    % --------------------------------------------------------------    
    % calculate other matrices by applying the discrete gradient operator
    % --------------------------------------------------------------    
    S_ss(1:scalarDim,1:scalarDim) = discreteGrad * T_vv * discreteGradTransp;    
    
    % multiply basis element matrices with their analytical calculated
    % x-coefficient   
    T_ss(1:scalarDim,1:scalarDim) = detJ * MasterT_ss; 
    
    % --------------------------------------------------------------    
    % find system matrix indices for all components
    % --------------------------------------------------------------        
    for i=1:3
        globalNodeId = project.topo.node(elemNode(i)).globalId;
        nodeIndex(i).scalar = project.geo.index(globalNodeId).scalarDomain;
        
        globalEdgeId = project.topo.edge(elemEdge(i)).globalId;
        
        scalarDomain = project.geo.index(globalEdgeId).scalarDomain; 
        
        [tmp scalDomSize] = size(scalarDomain);
        % replenish scalarDomain vector with ones, avoiding an index-error
        scalarDomain = [project.geo.index(globalEdgeId).scalarDomain];
        edgeIndex(i).scalar = scalarDomain;      
   
    end
    
    globalFaceId = project.topo.face(faceCnt).globalId;
    faceIndex.scalar = project.geo.index(globalFaceId).scalarDomain;
     
     
    % --------------------------------------------------------------    
    % assembly
    % --------------------------------------------------------------  
   
    % outer loop over all matrix-rows
    for i=1:scalarDim
        
        % -------------------------------------------------------
        % identify the global indices corresponding 
        % to the local numbering
        % -------------------------------------------------------
        switch i            
            case 1
                scalRow = nodeIndex(i).scalar(1);
%                 vecRow = edgeIndex(i).vectorial(1);
            case 2
                scalRow = nodeIndex(i).scalar(1);
%                 vecRow = edgeIndex(i).vectorial(1);
            case 3
                scalRow = nodeIndex(i).scalar(1);
%                 vecRow = edgeIndex(i).vectorial(1);
                
            case 4
                scalRow = edgeIndex(i-3).scalar(1);
%                 vecRow = faceIndex.vectorial(1);
            case 5
                scalRow = edgeIndex(i-3).scalar(1);
%                 vecRow = faceIndex.vectorial(2);
            case 6
                scalRow = edgeIndex(i-3).scalar(1);
%                 vecRow = edgeIndex(i-5).vectorial(2);
            case 7
                scalRow = edgeIndex(i-6).scalar(2);
%                 vecRow = edgeIndex(i-5).vectorial(2);
            case 8
                scalRow = edgeIndex(i-6).scalar(2);
%                 vecRow = edgeIndex(i-5).vectorial(2);
            case 9
                scalRow = edgeIndex(i-6).scalar(2);
%                 vecRow = faceIndex.vectorial(3);   
            case 10
                scalRow = faceIndex.scalar(1); 
%                 vecRow = faceIndex.vectorial(4);  
            otherwise
                error('row index-error in systemMatrixAssembly.m');
        end
                                                                       
        
        % inner loop over all matrix-columns
        for j=1:scalarDim            
            
            switch j            
                case 1
                    scalCol = nodeIndex(j).scalar(1);
%                     vecCol = edgeIndex(j).vectorial(1);
                case 2
                    scalCol = nodeIndex(j).scalar(1);
%                     vecCol = edgeIndex(j).vectorial(1);
                case 3
                    scalCol = nodeIndex(j).scalar(1);
%                     vecCol = edgeIndex(j).vectorial(1);
                    
                case 4
                    scalCol = edgeIndex(j-3).scalar(1);
%                     vecCol = faceIndex.vectorial(1);
                case 5
                    scalCol = edgeIndex(j-3).scalar(1);
%                     vecCol = faceIndex.vectorial(2);
                case 6
                    scalCol = edgeIndex(j-3).scalar(1);
%                     vecCol = edgeIndex(j-5).vectorial(2);
                case 7
                    scalCol = edgeIndex(j-6).scalar(2);
%                     vecCol = edgeIndex(j-5).vectorial(2);
                case 8
                    scalCol = edgeIndex(j-6).scalar(2);
%                     vecCol = edgeIndex(j-5).vectorial(2);
                case 9
                    scalCol = edgeIndex(j-6).scalar(2);
%                     vecCol = faceIndex.vectorial(3);   
                case 10
                    scalCol = faceIndex.scalar(1); 
%                     vecCol = faceIndex.vectorial(4);  
                otherwise
                    error('column index-error in systemMatrixAssembly.m');
            end       
 
            
            % make entry in system matrix
            % add vectorial basis function coefficients to stiffness matrix
%             stiffMatrix(vecRow,vecCol) = stiffMatrix(vecRow,vecCol) + Sx_vv(i,j) + S_vv(i,j);
            stiffMatrix(scalRow,scalCol) = stiffMatrix(scalRow,scalCol) + S_ss(i,j);
            % add couple matrix coeffiecients to stiffness matrix
%             stiffMatrix(scalRow,vecCol) = stiffMatrix(scalRow,vecCol) - S_sv(i,j);
%             stiffMatrix(vecRow,scalCol) = stiffMatrix(vecRow,scalCol) - S_vs(i,j);
           
            % add scalar and vectorial basis function coefficients to mass matrix          
            massMatrix(scalRow,scalCol) = massMatrix(scalRow,scalCol) - T_ss(i,j);
%             massMatrix(vecRow,vecCol) = massMatrix(vecRow,vecCol) - T_vv(i,j);
            
            
        end % inner col-loop
    end % outer row-loop 
end % element loop

    