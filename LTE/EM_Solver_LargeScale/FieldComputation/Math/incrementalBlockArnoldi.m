function [Q, R, order] = ...
    incrementalBlockArnoldi(Q, R, A1, rhs, A0Factor, isDoubleOrtho)

if nargin < 6
    isDoubleOrtho = false;
end


% dimension of system of equations, number of right-hand-sides
[dimSoe, nRhs] = size(rhs);
[nQRows, nQCols] = size(Q);

order = nQCols / nRhs;

if nQCols == 0
    % first call to Arnoldi            
    [Q, R] = modifiedGramSchmidt(rhs, isDoubleOrtho);   
    order = order + 1;
else    
    % increase number of krylov vectors    
    hDim = order * nRhs;
    
    R = [R, zeros(hDim, nRhs);
        zeros(nRhs, hDim), zeros(nRhs)];
    
    % determine indices of new columns of Q
    newCol = (order * nRhs + 1):((order + 1) * nRhs);
        
    W = A1 * Q(:,newCol - nRhs);
        
    % create new krylov vectors
    V = pardisoSolveLTE(A0Factor.mtype, A0Factor.iparm, A0Factor.pt, ...
        A0Factor.val, A0Factor.ia, A0Factor.ja, A0Factor.ncol, W, false);
         
    % orthogonalize krylov vectors
    for p = 1:order
        oldCol = ((p - 1) * nRhs + 1):(p * nRhs);
        R(oldCol, newCol) = Q(:,oldCol)' * V;
        V = V - Q(:,oldCol) * R(oldCol, newCol);
    end
    
    if isDoubleOrtho
        % orthogonalize a second time
        for p = 1:order
            oldCol = ((p - 1) * nRhs + 1):(p * nRhs);
            mDeltaR = Q(:,oldCol)' * V;
            V = V - Q(:,oldCol) * mDeltaR;
            R(oldCol, newCol) = R(oldCol,newCol) + mDeltaR;
        end
    end
            
    [Q(:,newCol), R(newCol, newCol)] = ...
        modifiedGramSchmidt(V, isDoubleOrtho);
    
    order = order + 1;
end



