function id = getIndex(elemCount, project, order)

[dimNode, dimEdge, dimElem] = getDim(project) ;

edgeNum1 = project.netz.elem(elemCount).edge(1) ;
edgeNum2 = project.netz.elem(elemCount).edge(2) ;
edgeNum3 = project.netz.elem(elemCount).edge(3) ;

id(1)  = edgeNum1 ;
id(2)  = edgeNum2 ;
id(3)  = edgeNum3 ;
id(4)  = dimEdge + edgeNum1 ;               
id(5)  = dimEdge + edgeNum2 ;
id(6)  = dimEdge + edgeNum3 ;
id(7)  = 2*dimEdge + elemCount ;           
id(8)  = 2*dimEdge + dimElem + elemCount ; 
id(9)  = 2*dimEdge + 2*dimElem + edgeNum1 ;   
id(10) = 2*dimEdge + 2*dimElem + edgeNum2 ;
id(11) = 2*dimEdge + 2*dimElem + edgeNum3 ;
id(12) = 3*dimEdge + 2*dimElem + elemCount ; 
id(13) = 3*dimEdge + 3*dimElem + elemCount ; 
id(14) = 3*dimEdge + 4*dimElem + elemCount ; 
id(15) = 3*dimEdge + 5*dimElem + elemCount ; 

switch order
    case 1
        id = id(1:3) ;
    case 2
        id = id(1:8) ;
    case 3
        id = id(1:15) ;
end




% if (count < 4)
%     id = 3*(elemCount-1) + count ;
% elseif (count < 9)
%     id = 3*dimElem + 5*(elemCount-1) + (count-3) ;
% elseif (count < 16)
%     id = 8*dimElem + 7*(elemCount-1) + (count-8) ;
% end