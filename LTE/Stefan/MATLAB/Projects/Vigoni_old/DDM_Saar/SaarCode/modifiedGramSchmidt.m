function u = modifiedGramSchmidt(Q, u)
% input: Q - orthonormal matrix
%        u - vector to be orthonormalized against col space of Q

[numRows numCols] = size(Q);
for colCnt = 1:numCols
    proj = Q(:, colCnt)' * u;
    u = u - Q(:, colCnt) * proj;
end
u = u / norm(u);
