function pos = findOpenPos(posVec)

if (isempty(find(posVec == 1)))
    pos = 1 ;
elseif (isempty(find(posVec == 2)))
    pos = 2 ;
else
    pos = 3 ;
end