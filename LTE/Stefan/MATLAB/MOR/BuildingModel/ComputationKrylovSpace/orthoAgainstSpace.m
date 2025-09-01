function [v projCoeffs] = orthoAgainstSpace(v, Q, spaceDim, orthoFlag)
% Orthogonalize vector v against column space of Q(:,1:spaceDim) and return 
% normalized vector 
% It is assumed: Q(:,1:spaceDim)' * Q(:,1:spaceDim) = I
% Algorithm: Modified Gram-Schmidt

projCoeffs = zeros(spaceDim+1,1);
for colCnt = 1:spaceDim
    proj = Q(:,colCnt)'*v;
    v = v - Q(:,colCnt)*proj;
    projCoeffs(colCnt) = projCoeffs(colCnt) + proj;
end
if orthoFlag
    % orthogonalize once again
    for colCnt = 1:spaceDim
        proj = Q(:,colCnt)'*v;
        v = v - Q(:,colCnt)*proj;
        projCoeffs(colCnt) = projCoeffs(colCnt) + proj;
    end
end    
projCoeffs(spaceDim+1) = norm(v);
v = v/projCoeffs(spaceDim+1);
