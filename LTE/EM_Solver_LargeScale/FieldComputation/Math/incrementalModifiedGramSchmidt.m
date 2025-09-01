function [Qnew, Rnew] = ...
    incrementalModifiedGramSchmidt(Qold, Rold, Qnew, doubleOrthoFlag)

nColsOld = size(Qold, 2);
nColsNew = nColsOld + size(Qnew, 2);

Rnew = Rold;
for k = (nColsOld + 1) : nColsNew    
    kNew = k - nColsOld;
    v = Qnew(:,kNew);
    for n = 1:(k-1)
        Rnew(n,k) = Qold(:,n)' * v;
        v = v - Rnew(n,k) * Qold(:,n);
    end
    
    if nargin > 3 && doubleOrthoFlag        
        for n = 1:(k-1)
            deltaR = Qold(:,n)' * v;
            Rnew(n,k) = Rnew(n,k) + deltaR;
            v = v - deltaR * Qold(:,n);
        end
    end
    
    Rnew(k,k) = norm(v);
    Qold(:,k) = v / Rnew(k,k);
    
end

Qnew = Qold;


