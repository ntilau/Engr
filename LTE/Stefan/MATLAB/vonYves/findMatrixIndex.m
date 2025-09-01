% return position of matrix MATNAME in struct SYSMAT
function matPos = findMatrixIndex(matName, SysMat)

for k = 1:length(SysMat)
    if strcmp(SysMat(k).name, matName)
        matPos = k;
        return;
    end
end

error('Matrix ''%s'' not found in struct ''%s''', matName, SysMat);
       