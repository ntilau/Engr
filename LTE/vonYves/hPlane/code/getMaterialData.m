% GETMATERIALDATA(MATERIAL, MESH, MATERIAL_PROPERTY) adds the poly_faces id's 
% and the material_property id's to 
% the material struct, since it allows a direct subscript.
% Besides the number of faces per material item is stored 


function returnMtr = getMaterialData(material, mesh, mtrProp)

% initialise return value
returnMtr = material;

% determine loop counter
[tmp mtrCnt] = size(material);
[tmp propCnt] = size(mtrProp);

for i=1:mtrCnt
    
    % add polyFacesId
    polyFacesName = material(i).polyFacesName;
    
    for j=1:mesh.poly_facesDim
        if strcmp(mesh.poly_faces(j).itemName, polyFacesName)
            returnMtr(i).polyFacesId = j;
            
            % count all faces in this poly_face item
            [tmp faceCnt] = size(mesh.poly_faces(j).face);
            returnMtr(i).faceCnt = faceCnt;
        end
    end
    
    % add materialPropertyId
    mtrType = material(i).materialType;
    
    for k=1:propCnt
        if strcmp(mtrProp(k).name, mtrType)
            returnMtr(i).mtrPropId = k;          
        end
    end    
    
end

        
        
        