%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts given Topology in a consistent Form such that:
%   + edge(1) is opposite to node with lowest node number
%   + edge(3) is opposite to node with highest node number
%
%   function call
%      function project = convertTopology(proj)
%
%   input variables
%      proj  ...struct with information about the elements
%
%   output variables
%      project ...struct with information about the elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function project = convertTopology(proj)

[dimNode, dimEdge, dimElem] = getDim(proj) ;

% edge direction: lower node number --> higher node number
for ii = 1:dimEdge
    if(proj.netz.edge(ii).n0 > proj.netz.edge(ii).n1)
        %swap nodes of this edge
        tmp = proj.netz.edge(ii).n0 ;
        proj.netz.edge(ii).n0 = proj.netz.edge(ii).n1 ;
        proj.netz.edge(ii).n1 = tmp ;
    end
end

% sort edges: edge(1) must be opposite to node with lowest node number
%             edge(3) must be opposite to node with highest node number

for kk = 1:dimElem
    tmpMat = [proj.netz.edge(proj.netz.elem(kk).edge(1)).n0 proj.netz.edge(proj.netz.elem(kk).edge(1)).n1 ;
              proj.netz.edge(proj.netz.elem(kk).edge(2)).n0 proj.netz.edge(proj.netz.elem(kk).edge(2)).n1 ;
              proj.netz.edge(proj.netz.elem(kk).edge(3)).n0 proj.netz.edge(proj.netz.elem(kk).edge(3)).n1 ] ;
    val_min = min(min(tmpMat)) ;
    val_max = max(max(tmpMat)) ;
    [row_min, col_min] = find(tmpMat == val_min) ;
    [row_max, col_max] = find(tmpMat == val_max) ;
    i_min = findOpenPos(row_min) ;
    i_max = findOpenPos(row_max) ;
    tmpMat(i_min, :) = 0 ;
    tmpMat(i_max, :) = 0 ;
    [row_mid, col_mid] = find(tmpMat) ;
    i_mid = row_mid(1) ;
    tmpEdge(1) = proj.netz.elem(kk).edge(i_min) ;
    tmpEdge(2) = proj.netz.elem(kk).edge(i_mid) ;
    tmpEdge(3) = proj.netz.elem(kk).edge(i_max) ;
    proj.netz.elem(kk).edge = tmpEdge ;
end
project = proj ;