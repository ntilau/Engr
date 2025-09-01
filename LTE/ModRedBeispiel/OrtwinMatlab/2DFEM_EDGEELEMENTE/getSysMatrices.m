%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of the System Matrices
%
%   function call
%      function Asys = getSysMatrices(project, order)
%
%   input variables
%      project   ...struct with information about the elements (nodes,
%                  edges, numbering)
%      order     ...order of nodal basis funtion can be chosen to 1 or 2
%      IsItSpase ...use sparse matrices or do not
%
%   output variables
%      S  ...stiffness matrix of generalised eigenvalue problem
%      T  ...mass matrix of generalised eigenvalue problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S, T] = getSysMatrices(project, order, IsItSparse)


% material parameters
epsR = project.material.epsilonRelativ ;
muR = project.material.muRelativ ;

% get number of nodes, edges and elements
[dimNode, dimEdge, dimElem] = getDim(project) ;

% initialize system matrices
switch order %order
    case 1
        sizeMat = dimEdge ;
    case 2
        sizeMat = 2*dimEdge + 2*dimElem ;
    case 3
        sizeMat = 3*dimEdge + 6*dimElem ;
end

if(IsItSparse)
    S = sparse(sizeMat, sizeMat) ;
    T = sparse(sizeMat, sizeMat) ;
    tmpS = sparse(sizeMat, sizeMat) ;
    tmpT = sparse(sizeMat, sizeMat) ;
else
    S = zeros(sizeMat, sizeMat) ;
    T = zeros(sizeMat, sizeMat) ;
    tmpS = zeros(sizeMat, sizeMat) ;
    tmpT = zeros(sizeMat, sizeMat) ;
end


% get master matrices to assemble system matrices 
master = getMasterMat(order) ;


for ii = 1:dimElem
    count = ii ;
    element = project.netz.elem(ii) ;
    
    % calculate jacobian to map reference model
    detJ = calcJacobian(project, count) ;
    
    % calculate gradients for mass matrix
    [gradL2, gradL3] = calcGradients(project, detJ, count) ;

    % assemble element system matrices
    Sel = 1/abs(detJ) * master.S ;
    Tel = abs(detJ) * ( gradL2'*gradL2*master.T1 + ...
                        gradL2'*gradL3*master.T2 + ...
                        gradL3'*gradL3*master.T3 );

    % write element entries in global system matrices
    id = getIndex(ii, project, order) ;
    tmpS(id, id) = Sel ;
    tmpT(id, id) = Tel ;
    S = S + tmpS ;
    T = T + tmpT ;
    
    if(IsItSparse)
        tmpS = sparse(sizeMat, sizeMat) ;
        tmpT = sparse(sizeMat, sizeMat) ;
    else
        tmpS = zeros(sizeMat, sizeMat) ;
        tmpT = zeros(sizeMat, sizeMat) ;
    end  
end %dimElem

S = 1/muR*S ;
T = epsR*T ;