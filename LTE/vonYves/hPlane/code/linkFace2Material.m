% LINKFACE2MATERIAL creates a table which establishes a relation
% between faces and materials 

function table = linkFace2Material(project)

material = project.geo.material;
[tmp mtrDim] = size(material);


% consider all materials, select the involved faces and create
% the face-material relation
for mtrCnt=1:mtrDim
    polyFacesId = material(mtrCnt).polyFacesId;
    face = project.geo.poly_faces(polyFacesId).face;
    [tmp faceDim] = size(face);
    
    for faceCnt=1:faceDim
        table(face(faceCnt)) = material(mtrCnt).mtrPropId;
    end
end
    

