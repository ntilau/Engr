% select VALUE from TABLE where IDCOL == ID
function [value, index] = accessM2N(table, id, idCol, direction)

if nargin  >= 3
    if isempty(idCol)        
        idCol = 1;
    end
    
    if nargin >= 4
        % search direction specified
        if isempty(intersect(direction, [1,2]))
            error('Parameter ''direction'' must be a member of the set \{1,2\}');
        elseif direction == 2
            table = table.';
        end
    end
end    
    
index = find(table(:,idCol) == id);

if idCol == 1
    valCol = 2;
else
    valCol = 1;
end
value = table(index,valCol);