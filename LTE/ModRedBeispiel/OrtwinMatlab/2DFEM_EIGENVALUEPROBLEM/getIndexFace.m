function id = getIndexFace(elemCount, project, order)

[dimNode, dimEdge, dimElem] = getDim(project) ;

switch order
    case 1
        id = edgeNum ;
    case 2
%         id(1) = edgeNum ;                         % edge
%         id(2) = dimEdge + edgeNum ;               % edge
        id(1) = 2*dimEdge + elemCount ;           % face
        id(2) = 2*dimEdge + dimElem + elemCount ; % face
    case 3
%         id(1) = edgeNum ;                           % edge
%         id(2) = dimEdge + edgeNum ;                 % edge
        id(1) = 2*dimEdge + elemCount ;             % face
        id(2) = 2*dimEdge + dimElem + elemCount ;   % face
%         id(3) = 2*dimEdge + 2*dimElem + edgeNum ;   % edge
        id(3) = 3*dimEdge + 2*dimElem + elemCount ; % face
        id(4) = 3*dimEdge + 3*dimElem + elemCount ; % face
        id(5) = 3*dimEdge + 4*dimElem + elemCount ; % face
        id(6) = 3*dimEdge + 5*dimElem + elemCount ; % face
end