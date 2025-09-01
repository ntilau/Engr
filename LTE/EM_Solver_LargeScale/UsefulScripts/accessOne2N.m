function [value, index] = accessOne2NRelation(table, one, searchDirection)

if nargin  > 2 
% search direction specified    
    if isempty(intersect(searchDirection, [1,2]))
        error('Parameter ''searchDirection'' must be member of the set \{1,2\}');
    elseif searchDirection == 2
        table = table.';
    end
end    
    
index = find(table(:,1) == one);

value = table(index,2);