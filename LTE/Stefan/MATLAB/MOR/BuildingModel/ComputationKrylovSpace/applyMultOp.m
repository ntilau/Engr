function y = applyMultOp(A, Fact, b, pardisoFlag)
% A is a matrix
% If pardiso == false: Fact is a factorization structure of matrix X with
% Fact.P * X * Fact.Q = Fact.L * Fact.U
% b is a vector
% y = Fact^{-1}*A*b

y = A*b;
if ~isempty(Fact)
     if pardisoFlag
        [y err] = pardisoSolveLTE(Fact.mtype, Fact.iparm, Fact.pt, ...
            Fact.A_val, Fact.A_ia, Fact.A_ja, Fact.ncol, y, 0);
        if err ~= 0
            error(['Pardiso error during solving: ' err]);
        end
    else
        if ~isempty(Fact.P)
            y = Fact.P*y;
        end
        y = Fact.U\(Fact.L\y);
        if ~isempty(Fact.Q)
            y = Fact.Q*y;
        end
    end
end
