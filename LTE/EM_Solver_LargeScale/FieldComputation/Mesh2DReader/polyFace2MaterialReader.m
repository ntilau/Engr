% read file (name).mtr2 which contains materialName-polyFace-relations
function [polyFace2Material, materialName] = polyFace2MaterialReader(Model)

fprintf(1, '\n\t- Set polyFace-material-relations...');

iMtrl = 0;
materialName = {};
polyFace2Material = zeros(Model.Mesh.nPolyFaces, 1);

file = strcat(Model.path, Model.name, '.mtr2');
fid = fopen(file);
if fid == -1
    error('could not open file %s', file); 
end

for k = 1:Model.Mesh.nPolyFaces    
    polyFaceName = fscanf(fid, '%s', 1);
    polyFaceName = makeValidVarName(polyFaceName, 'PolyFace');  
    polyFaceId = getPolyObjectId(Model.Mesh.PolyFace, polyFaceName);
    
    tmpMaterialName =  fscanf(fid, '%s', 1);        
    % check for first occurence of material "tmpMaterialName"
    iMtrlTmp = find(strcmp(tmpMaterialName, materialName));
    if isempty(iMtrlTmp)
        iMtrl = iMtrl + 1;
        materialName{iMtrl} = tmpMaterialName;%#ok<AGROW>
        polyFace2Material(polyFaceId) = iMtrl;
    else
        polyFace2Material(polyFaceId) = iMtrlTmp;
    end
end        
            
fclose(fid);


