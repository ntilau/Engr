function [Q U] = wcaweImprvd(Fact, mat, startVec, order, Q, U, orthoFlag, ...
    pardisoFlag)
% This WCAWE implementation allows the efficient computation of
% the orthogonal basis by integrating precomputed vectors from the ROM.

if isempty(U) && isempty(Q) && order >= 0
    U(1, 1) = norm(startVec);
    Q(:, 1) = startVec / U(1, 1);
end

for n = (size(U,2)+1) : (order+1)
    v = -mat{2} * Q(:, n - 1);
    for m = 2 : min(length(mat) - 1, n - 1)
        eNmM = zeros(n - m, 1);
        eNmM(n - m) = 1;
        v = v - mat{m+1} * (Q(:,1:(n-m))*(PUwInverse(U,2,m,n)\eNmM));
    end
    % solve LSE
    if pardisoFlag
        [v err] = pardisoSolveLTE(Fact.mtype, Fact.iparm, Fact.pt, ...
            Fact.A_val, Fact.A_ia, Fact.A_ja, Fact.ncol, v, 0);
        if err ~= 0
            error(['Pardiso error during solving: ' err]);
        end
    else
        if isfield(Fact, 'P');
            v = Fact.P * v;
        end
        v = Fact.U \ (Fact.L \ v);
        if isfield(Fact, 'Q');
            v = Fact.Q * v;
        end
    end
    [v projCoeffs] = orthoAgainstSpace(v, Q, n-1, orthoFlag);
    U(1:n,n) = projCoeffs; 
    Q(:,n) = v;
end
