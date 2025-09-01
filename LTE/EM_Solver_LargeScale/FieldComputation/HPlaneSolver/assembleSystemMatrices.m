% -------------------------------------------------------
% stiffness (mS), impedance (mZ) and mass matrix (mT) assembly by 
% calculating the contributions of each finite element
% -------------------------------------------------------

function SysMat = assembleSystemMatrices(Model)
%% read element matrices
ElementMatrix = readMasterMatrices(Model);
% mass matrix
MasterT_ss = eval(ElementMatrix.T_ss);
% vectorial mass matrices
MasterT_vv1 = eval(ElementMatrix.T_vv1);
MasterT_vv2 = eval(ElementMatrix.T_vv2);
MasterT_vv3 = eval(ElementMatrix.T_vv3);

discreteGrad = createDiscreteGradient(Model.pOrder);
MasterS_ss1 = discreteGrad * MasterT_vv1 * discreteGrad';
MasterS_ss2 = discreteGrad * MasterT_vv2 * discreteGrad';
MasterS_ss3 = discreteGrad * MasterT_vv3 * discreteGrad';

% allocate system matrices
mT = sparse(Model.nDofsRaw, Model.nDofsRaw);
mS = sparse(Model.nDofsRaw, Model.nDofsRaw);
mZ = sparse(Model.nDofsRaw, Model.nDofsRaw);

for iFace = 1:Model.Mesh.nFaces        
    
    % get element topologic data
    elEdge = Model.Mesh.face(iFace,:);    
    elNode = unique(Model.Mesh.edge(elEdge,:))';
    % positions of element nodes
    elementPosition = Model.Mesh.position(elNode,:); 
    
    % get element material data
    polyFaceId = Model.Mesh.face2polyFace(2,iFace);    
    mtrlId = Model.Geo.polyFace2Material(polyFaceId);    
    epsilon_r = Model.Geo.Material(mtrlId).Property.epsilon_relative.value;
    mu_rInv = 1 / Model.Geo.Material(mtrlId).Property.mu_relative.value;  
    sigma = Model.Geo.Material(mtrlId).Property.sigma.value;
       
    [detJ, gradEtaSqr, gradEtaGradZeta, gradZetaSqr] = ...
        transformElement(elementPosition);
        
    % build element matrices
    S_ss = mu_rInv / detJ * (gradEtaSqr * MasterS_ss1 + ...
        gradEtaGradZeta * MasterS_ss2 + gradZetaSqr * MasterS_ss3);      
    T_ss = epsilon_r * detJ * MasterT_ss; 
    if sigma ~= 0
        Z_ss = 1i * Model.eta0 * sigma * detJ * MasterT_ss;
    end
    
    if Model.pOrder == 1
        globalIndex = elNode;
    elseif Model.pOrder == 2
        globalIndex = [elNode, elEdge + Model.Mesh.nNodes];
    elseif Model.pOrder >= 3
        error('pOrder = %d is not implemented yet', Model.pOrder);
    end       
    
    % add basis function coefficients to system matrices
    mS(globalIndex,globalIndex) = ...
        mS(globalIndex,globalIndex) + S_ss;
    
    mT(globalIndex,globalIndex) = ...
        mT(globalIndex,globalIndex) + T_ss;
    
    if sigma ~= 0
        mZ(globalIndex,globalIndex) = ...
            mZ(globalIndex,globalIndex) + Z_ss;
    end        
end

SysMat(1).name = 'system matrix';
SysMat(1).paramList(1).param{1} = 'k0^0';
SysMat(1).val = mS;

SysMat(2).name = 'k^2 matrix';
SysMat(2).paramList(1).param{1} = 'k0^2';
SysMat(2).val = - mT;

if nnz(mZ) > 0
    SysMat(3).name = 'ABC';
    SysMat(3).paramList(1).param{1} = 'k0';
    SysMat(3).val = mZ;
end




