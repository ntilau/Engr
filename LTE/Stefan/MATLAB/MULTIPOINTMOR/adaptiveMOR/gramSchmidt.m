function [Qnew, Rnew] = gramSchmidt(Qold, Rold, Qnew, sysSize )

Rnew=Rold;
kEnde = sysSize + length(Qnew(1,:));
kOldLength = sysSize;

for k = sysSize+1 : kEnde,
    kNew = k-kOldLength;
    v = Qnew(:,kNew);
    for l=1:k-1,
        Rnew(l,k) = v'*Qold(:,l);
        v = v - Rnew(l,k)'*Qold(:,l);
    end
    Rnew(k,k) = norm(v);
    Qold(:,k) = v/Rnew(k,k);
end


Qnew=Qold;


