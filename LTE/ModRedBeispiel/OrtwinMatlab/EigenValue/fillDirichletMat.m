function matDir = fillDirichletMat( mat, d ) % Function definition line

% fill eigenvectors with zeros at dirichlet position
[rm cm] = size(mat);
r = length(d);

dirHit = 0;
for k = 1:r
    if(~d(k))
        matDir(k,:) = mat(k-dirHit,:);
    else
        matDir(k,:) = zeros(1,cm);
        dirHit = dirHit+1;
    end
end


