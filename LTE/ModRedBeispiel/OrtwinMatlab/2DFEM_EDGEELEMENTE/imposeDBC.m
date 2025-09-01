%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Imposing Dirichlet Boundary Conditions in Generalised Eigenvalue Problem
%
%   function call
%      function [S_, T_] = imposeDBC(proj, S, T, order)
%
%   input variables
%      proj  ...struct with information about the elements (nodes,
%                  edges, numbering)
%      S     ...stiffness system matrix
%      T     ...mass system matrix
%      order ...order of nodal basis funtion can be chosen to 1 or 2
%
%   output variables
%      S_  ...stiffness system matrix with imposed Dirichlet BC
%      T_  ...mass system matrix with imposed Dirichlet BC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S, T] = imposeDBC(proj, S, T, order)

% get number of nodes, edges and elements
[dimNode, dimEdge, dimElem] = getDim(proj) ;

% find edges with dirichlet values and shift the corresponding eigenvalues
% to infinity.
for ii = 1:dimElem
    for jj = 1:3
        edgeNum = proj.netz.elem(ii).edge(jj) ;
        boundNum = proj.netz.edge(edgeNum).boundNr ;
    
        if boundNum  % if dirichlet
            boundVal = proj.boundary(boundNum).dirVal ;
            switch order
                case 1
                    boundPos = edgeNum ;
                case 2
                    boundPos = [edgeNum dimEdge+edgeNum] ;
                case 3
                    boundPos = [edgeNum dimEdge+edgeNum 2*dimEdge+2*dimElem+edgeNum] ;
            end
            S(boundPos, :) = 0 ;
            S(:, boundPos) = 0 ;
            T(boundPos, :) = 0 ;
            T(:, boundPos) = 0 ;
            for kk = 1:order
                S(boundPos(kk), boundPos(kk)) = 1 ;
                T(boundPos(kk), boundPos(kk)) = 1e-12 ;
            end
        end
    end
end
