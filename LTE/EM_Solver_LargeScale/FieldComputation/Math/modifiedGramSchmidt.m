function [Q, U] = modifiedGramSchmidt(A, doubleOrthoFlag)
% Modified Gram Schmidt:
% Columns of matrix Q are the orthonormal basis
% Matrix U is upper triangular and contains the expansion coefficients

[r c] = size(A);
Q = A;
U = zeros(c, c);
for colCnt = 1:c
    U(colCnt, colCnt) = norm(Q(:, colCnt));
    Q(:, colCnt) = Q(:, colCnt) / U(colCnt, colCnt);
    for orthoCnt = (colCnt + 1):c
        proj = Q(:, colCnt)' * Q(:, orthoCnt);
        U(colCnt, orthoCnt) = proj;
        Q(:, orthoCnt) = Q(:, orthoCnt) - proj * Q(:, colCnt);
    end
    
    if doubleOrthoFlag
        % orthogonalize a second time
        for orthoCnt = (colCnt + 1):c
            proj = Q(:, colCnt)' * Q(:, orthoCnt);
            U(colCnt, orthoCnt) = U(colCnt, orthoCnt) + proj;
            Q(:, orthoCnt) = Q(:, orthoCnt) - proj * Q(:, colCnt);
        end
    end
    
end



