function vecDir = fillDirichletVec( vec, d ) % Function definition line

[r c] = size(vec);

if ~(c~=1 | r~=1)
    error('Input vector d is a matrix,  not a vector.');
end

% fill vector with zeros at dirichlet position
vecDir = zeros(r+length(d),1);
dirHit = 0;
for k = 1:length(d)
    if(~d(k))
        vecDir(k) = vec(k-dirHit);
    else
        vecDir(k) = inf;
        dirHit = dirHit+1;
    end
end
