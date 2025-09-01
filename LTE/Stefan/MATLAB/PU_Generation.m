function PU = PU_Generation( U, w, eta, m )

PU = eye(eta-m);
for t=w:m
    PU = PU * inv(U(t:(eta-m+t-1), t:(eta-m+t-1)));
end


