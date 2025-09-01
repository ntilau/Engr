%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adapts the dirichlet boundary conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S, T] = attachBC(project, order, S, T, dirichlet)

%initialize variables
dimNode = project.nodeDim ;
dimEdge = project.edgeDim ;
dimElem = project.elemDim ;

for ii = 1:dimEdge
    % get boundary condition
    bcNr = project.netz.edge(ii).boundNr ;
    
    % get numbered position of nodes
    node1 = project.netz.edge(ii).n0 ;  % node1 of edge (ii)
    node2 = project.netz.edge(ii).n1 ;  % node2 of edge (ii)
    
    if (~isempty(find(bcNr==dirichlet)))    % if dirichlet    

        % adapt system matrix
        S(node1, :) = 0 ;
        S(:, node1) = 0 ;
        S(node1, node1) = 1 ;
        S(node2, :) = 0 ;
        S(:, node2) = 0 ;
        S(node2, node2) = 1 ;
        T(node1, :) = 0 ;
        T(:, node1) = 0 ;
        T(node1, node1) = 1e-20 ;
        T(node2, :) = 0 ;
        T(:, node2) = 0 ;
        T(node2, node2) = 1e-20 ;
        
        for jj = 1:(order-1)
            count = dimNode + (jj-1)*dimEdge + ii ;
            S(count, :) = 0 ;        % adapt
            S(:, count) = 0 ;
            S(count, count) = 1 ;    % adapt
            T(count, :) = 0 ;        % adapt
            T(:, count) = 0 ;
            T(count, count) = 1e-20 ;    % adapt
        end
    end %endif
end %endfor