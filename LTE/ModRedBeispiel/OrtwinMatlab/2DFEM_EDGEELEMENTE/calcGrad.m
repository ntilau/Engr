%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of discrete Gradient Operator to build a basis for all
% Gradients
%
%   function call
%      function G = calcGrad(project, order)
%
%   input variables
%      project   ...struct with information about the elements (nodes,
%                  edges, numbering)
%      order     ...order of nodal basis funtion can be chosen to 1 or 2
%
%   output variables
%      G  ...discrete gradient operator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function G = calcGrad(project, order)

% get number of nodes, edges and elements
[dimNode, dimEdge, dimElem] = getDim(project) ;

% initialise local counter
k = 0 ;

% get size of matrix
switch order
    case 1
        sizeMat = dimEdge ;
    case 2
        sizeMat = 2*dimEdge + 2*dimElem ;
    case 3
        sizeMat = 3*dimEdge + 6*dimElem ;
end

% initialise sparse discrete gradient matrix
G = sparse(sizeMat,1) ;
%mark = sparse(sizeMat,1) ;

% 1st order gradients
% find all inner nodes
for ii = 1:dimNode
    if (project.netz.node(ii).boundNr==0)
        k = k+1 ;
        for jj = 1:dimEdge
            if (project.netz.edge(jj).n0 == ii)
                G(jj,k) = -1 ;
            elseif (project.netz.edge(jj).n1 == ii)
                G(jj,k) = 1 ;
            end
        end
    end
end

%  2nd order and 3rd order gradients (explicit available)
if (order > 1)
    for ii = 1:dimEdge
        k=k+1 ;
        G(dimEdge+ii,k) = 1 ;
    end
    if (order > 2)
        for ii = 1:dimEdge
            k = k+1 ;
            G(2*dimEdge+2*dimElem+ii, k) = 1 ;
        end
        for ii = 1:dimElem
            k = k+1 ;
            G(3*dimEdge+2*dimElem+ii, k) = 1 ;
        end
    end
end
