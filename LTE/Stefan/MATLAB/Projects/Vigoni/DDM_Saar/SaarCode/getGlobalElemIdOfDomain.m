function [globalPos] = getGlobalElemIdOfDomain(dd, MESH, ele)

elemsOfD = MESH{dd}.ele(1:4, :);% + MESH{dd}.BASE ;
elemsOfD(1,:) = [];

elemsOfAllD = ele;
elemsOfAllD(1,:) = [];

for ii = 1:size(elemsOfD, 2)
    for jj = 1:size(elemsOfAllD, 2)
        if size(union(elemsOfD(:, ii), elemsOfAllD(:, jj)), 1) == 3
            globalPos(ii) = jj;
        end
    end
end