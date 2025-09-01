function Material = materialReader(materialPath, materialName)

fprintf(1, '\n\t- Read mtrl-material-files...');

nMaterials = length(materialName);
Material = struct;

for k = 1:nMaterials
           
    file = sprintf('%s%s.mtrl', materialPath, materialName{k});    
    fid = fopen(file);    
    if fid == -1
        error('couldn''t open file %s', file); %#ok<SPERR>
    end
    
    while ~feof(fid)    
        
        % read mesh data blockwise
        [type name count material_property] = blockReader(fid);
        if (~isempty(material_property) && ~isempty(type))
            Material(k).name = materialName{k};
            Material(k).Property = material_property;
        end
    end        
    fclose(fid);
end