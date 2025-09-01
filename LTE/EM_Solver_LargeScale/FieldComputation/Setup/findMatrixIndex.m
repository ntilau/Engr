% return position of matrix MATNAME in struct SYSMAT
function matPos = findMatrixIndex(SysMat, matName)

matPos = [];
hasFoundMatName = false;
for k = 1:length(SysMat)
    if strcmp(SysMat(k).name, matName)
        if ~hasFoundMatName
            matPos = k;
        else
            error('Multiple occurence of matrix with name %s', matName);
        end
        hasFoundMatName = true;        
    end
end

