function [Qnew, Rnew] = gramSchmidt(Qold, Rold, Qnew)

nColsOld = size(Qold, 2);
nColsNew = nColsOld + size(Qnew, 2);

Rnew = Rold;
for k = (nColsOld + 1) : nColsNew    
    kNew = k - nColsOld;
    v = Qnew(:,kNew);
    for n=1:k-1
        Rnew(n,k) = v' * Qold(:,n);
        v = v - Rnew(n,k)' * Qold(:,n);
    end
    Rnew(k,k) = norm(v);
    Qold(:,k) = v / Rnew(k,k);
end

Qnew = Qold;


