% returns int ID of struct POLYOBJECT (PolyNode | PolyEdge | PolyFace)
% where POLYOBJECT(ID).name == SEARCHNAME
function polyObjectId = getPolyObjectId(PolyObject, searchName)

polyObjectId = [];

for k = 1:length(PolyObject)
    if strcmp(PolyObject(k).name, searchName)
        polyObjectId = k;
        break;
    end
end

