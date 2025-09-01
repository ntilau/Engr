% GETINDEX(FACECNT) returns array ID with 

function id = getXIndex(faceCnt)

global project
global vectorialOrder

node = getElemNode(faceCnt);


switch vectorialOrder
    case 1
        vecDim = 1;
    case 2
        vecDim = 2;
    case 3
        vecDim = 3;
end

idCnt = 0;
for i = 1:vecDim
    for j = 1:3
        idCnt = idCnt + 1;        
        globId = project.topo.node(node(j)).globalId;
        scalarIndex = project.geo.index(globId).scalarDomain;
        id(idCnt) = scalarIndex(i);
    end
end
