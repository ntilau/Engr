function [Mesh]=pde2qfFETT(p,e,t,reglab,edgelab)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts a Mesh from PDE Tools to Quick Fem data structure 
%
%  p,e,t - are the exported matrices from atlab PDE-tool
%
%  reglab is a vector with as many entries as there are PDE tools region.
%  For each region it specifies the label
%
%  edgelab is a vector with as many entries as there are PDE tools edges.
%  For each edge it specifies the label to be given to nodes AND edges
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   (C) 1997-2008 PELOSI - COCCIOLI - SELLERI
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Np  =   size(p,2);  %node number
Nt  =   size(t,2);  %triangle number
Ne  =   size(e,2);  %border edge number
 
%Edge matrix construction
%Node connection matrix
EdM   =   sparse(Np,Np);
for i=1:Np      %point index
%     for j=1:Nt  %element index
t1 = logical(t(1, :) == i) ;
t2 = logical(t(2, :) == i) ;
t3 = logical(t(3, :) == i) ;

EdM(i, t(2, t1)) = 1 ;
EdM(i, t(3, t1)) = 1 ;
EdM(i, t(1, t2)) = 1 ;
EdM(i, t(3, t2)) = 1 ;
EdM(i, t(1, t3)) = 1 ;
EdM(i, t(2, t3)) = 1 ;
%         t1  =   t(1,j);
%         t2  =   t(2,j);
%         t3  =   t(3,j);
%         if(t1==i)
%             EdM(i,t2)   =   1;
%             EdM(i,t3)   =   1;
%         elseif(t2==i)
%             EdM(i,t1)   =   1;
%             EdM(i,t3)   =   1;
%         elseif(t3==i)
%             EdM(i,t1)   =   1;
%             EdM(i,t2)   =   1;
%         end
%     end
end

%edge matrix construction
k   =   0;
[row, col, val] = find(EdM) ;
idx = logical(row < col) ;
row = row(idx) ;
col = col(idx) ;

for i=1:length(row)     %vertex index
    k   =   k+1;
    %this choice deal the edge orientation
    EdM(row(i), col(i))    =   k;
    EdM(col(i), row(i))    =   -k;
end
 
%element matrix definition
Mesh.ele(1,:)   =   ones(1,Nt)*3;
Mesh.ele(2:4,:) =   t(1:3,:);
Mesh.elab       =   reglab(t(4,:));

%edges matrix definition
Mesh.spig(1,:)  =   ones(1,Nt)*3;
for i=1:Nt
    t1  =   t(1,i);     %
    t2  =   t(2,i);     %point indexes
    t3  =   t(3,i);     %
    Mesh.spig(2,i)  =   EdM(t1,t2);
    Mesh.spig(3,i)  =   EdM(t2,t3);
    Mesh.spig(4,i)  =   EdM(t3,t1);
end
 
Ns = max(max(EdM));

%edgelbl matrix definition
Mesh.slab=zeros(1,Ns);
for i=1:Ne
    i_p1 =   e(1,i);                     %start point index
    i_p2 =   e(2,i);                     %end point index
    i_border    =   e(5,i);              %border index
    RL_border   =   e(6,i);              %border between regions...
    RR_border   =   e(7,i);              %
    if (RL_border*RR_border==0)
        v_border    =   edgelab(i_border);   %border type
        i_edge      =   abs(EdM(i_p1,i_p2)); %edge index
        Mesh.slab(i_edge) =   v_border;   
    end
end
 
%nodes matrix definition
Mesh.xy(1:2,:) =   (p(:,:));             %nodes coloumn 1 and 2 are the 'p' matrix itself 
Mesh.nlab      =   zeros(1,Np); 
for i=1:Ne
    iStart    =   e(1,i);                %start point index of the edge
    iEnd      =   e(2,i);                %end point index of the edge
    i_border  =   e(5,i);                %geometry border index 
    if (edgelab(i_border)>0)
        Mesh.nlab(iStart) = edgelab(i_border);
    end
    if(edgelab(i_border)>0)
        Mesh.nlab(iEnd)   = edgelab(i_border);
    end
end
