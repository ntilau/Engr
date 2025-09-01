function [Q, R, P] = GramSchmidt(A, M)

[nrows, ncols] = size(A);
Q = zeros(nrows, ncols);
R = zeros(ncols);

if nargin == 1
    % standard Gram-Schmidt
    if nargout > 2
        error('Too many output arguments.');
    end
    R(1,1) = norm(A(:,1));
    Q(:,1) = A(:,1) / R(1,1);
    for iColA = 2:ncols
        q = A(:,iColA);
        for iColQ = 1:(iColA - 1)
            R(iColQ, iColA) = (Q(:,iColQ)' * q);
            q = q - R(iColQ, iColA) * Q(:,iColQ);
        end
        R(iColA, iColA) = norm(q);
        Q(:,iColA) = q / R(iColA, iColA);
    end
elseif nargin == 2
    % M-orthogonal Gram-Schmidt
    p = M * A(:,1);
    R(1,1) = sqrt(A(:,1).' * p);
    P(:,1) = p / R(1,1);
    Q(:,1) = A(:,1) / R(1,1);
    for iColA = 2:ncols
        q = A(:,iColA);        
        for iColQ = 1:(iColA - 1)
            R(iColQ, iColA) = P(:,iColQ).' * q;
            q = q - R(iColQ, iColA) * Q(:,iColQ);
        end
        p = M * q;
        R(iColA, iColA) = sqrt(p.' * q);
        P(:,iColA) = p / R(iColA, iColA);
        Q(:,iColA) = q / R(iColA, iColA);
    end
else
    error('Wrong number of Parameters.');
end

 