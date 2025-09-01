function [A, scale] = scaleMatrix(A)

d = sqrt(1 ./ diag(A));
[m, n] = size(A);

if m ~= n
    error('Matrix A has to be square');
end

if issparse(A)
    scale = spdiags(d, 0, m, n);
else    
    scale = diag(d);
end

A = scale * A * scale;