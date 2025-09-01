%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of the System Matrix
%
%   function call
%      function Asys = getSysMatrix(project, order)
%
%   input variables
%      project  ...struct with information about the elements (nodes,
%                  edges, numbering)
%      order    ...order of nodal basis funtion can be chosen to 1 or 2
%
%   output variables
%      Asys     ...returns the system matrix of the linear system A*x=b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S, T] = getSysMatrices(project, order)

num = (order+1)*(order+2)/2 ;  % number of nodal basis functions
dimNode = project.nodeDim ;    % initialize variables
dimEdge = project.edgeDim ;
dimElem = project.elemDim ;

% initialize elementstruct
local = struct('nodes', zeros(1, 3),...
               'edge' , zeros(3, order-1),...
               'face' , zeros(max(0,num-3*(order-1)-3), 1)) ;
               
% get master matrix
[S, T, Sa, Sb, Sc, Tmaster] = getMasterMat(project, order) ;
    
for ii = 1:dimElem
    % set element
    element = project.netz.elem(ii) ;
    
    % get material parameters
    eps_r = project.material(project.netz.elem(ii).matNr).epsilonRelativ ;
    mu_r  = project.material(project.netz.elem(ii).matNr).muRelativ ;
    
    % get values of this element
    [vals] = buildValArray(element, order, local, num, dimNode, dimEdge, dimElem);
    
    % calculate jacobian and its determinant
    [jacobi, detJ] = calcJacobian(project, element) ;
    
    % calculate factors for Sel
    a = (jacobi(1,2)^2+jacobi(2,2)^2) / detJ ;
    b = (-jacobi(2,2)*jacobi(2,1) - jacobi(1,2)*jacobi(1,1)) / detJ ;
    c = (jacobi(1,1)^2 + jacobi(2,1)^2) / detJ ;
  
    % stiffness and mass matrix calculated in local coordinates
    Sel = 1/mu_r * (a*Sa + b*Sb + c*Sc) ;
    Tel = eps_r * detJ * Tmaster ;

    % write calculated values in system matrices
    for jj = 1:num
        for kk = 1:num
            temp = S(vals(jj), vals(kk)) ;
            S(vals(jj), vals(kk)) = temp + Sel(jj,kk) ;
            temp = T(vals(jj), vals(kk)) ;
            T(vals(jj), vals(kk)) = temp + Tel(jj,kk) ;
        end
    end 
end %endfor elements 