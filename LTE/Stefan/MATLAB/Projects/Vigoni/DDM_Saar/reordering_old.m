function [MESH,xy,nlab,BASE_c] = reordering(xy,xydd,nlab,ele,elab,eledd,domains,NDD,LPEC,Lp)

% This function reorders the global mesh nodes in this way: 
% First: nodes internal to "id" subdomains belonging to elements of the same subdomanin (for id from 1 to NDD)
% Second: nodes belonging to boundaries

% Function reordering:
% [IN]:
%     xy: global mesh node vector
%     xydd: partition node vector
%     nlab: global mesh node labels
%     ele: global mesh element vector
%     elab: global mesh element labels
%     eledd: partition element vector
%     domains: output of meshDD function
%     LPEC: label pec boundaries
%     Lp: label port boundaries
% [OUT]:
%     MESH: structure
%     xy: reoredered global mesh node vector
%     nlab: reordered global mesh node labels
%     BASE_c: last internal node index

NNODE = size(xy,2);
%NDD = size(eledd,2);
NELE = size(ele,2);
nodes = zeros(1,NNODE);
LBOUND = NDD + 1;
for id = 1:NDD
    ctr = eledd(1,id);
    xyedd = xydd(:,eledd(2:ctr+1,id));
    eleint = ele(:,find(domains == id));
    for ie = 1:size(eleint,2)
        ctr = eleint(1,ie);
        n = eleint(2:1+ctr,ie);
        for in = 1:length(n)
            if  not(length(find([LPEC,Lp] == nlab(n(in)))) == 0)
                nodes(n(in)) = LBOUND;
            elseif (nodes(n(in)) == 0) | (nodes(n(in)) == id)
                nodes(n(in)) = id;
            else
                nodes(n(in)) = LBOUND;
            end
        end         
    end
end

[new_nodes,idx] = sort(nodes);
new_xy = xy(:,idx);

new_nlab = nlab(idx);

for in = 1:NNODE
    inv_idx(in) = find(in == idx);
end
for ie = 1:NELE
    ctr = ele(1,ie);
    new_ele(:,ie) = [ctr;inv_idx(ele(2:ctr+1,ie))'];
end


nodes = new_nodes;
clear new_nodes;
xy = new_xy;
clear new_xy;
nlab = new_nlab;
clear new_nlab;
ele = new_ele;
clear new_ele;

BASE_c = length(find(not(nodes == (LBOUND))));
NNODED = 0;
for id = 1:NDD
    tmp = find(domains == id);
    eleD = ele(:,tmp);
    elabD = elab(tmp);
    tmp = find(nodes == id);
    BASE_node = sum(NNODED);
    NNODED(id) = length(tmp);
    MESH{id} = struct('ele',eleD,'elab',elabD,'NNODEi',NNODED(id),'BASE',BASE_node);
end

