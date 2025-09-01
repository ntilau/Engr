function [Q U] = wcawe(fact, mat, startVec, order)

U(1,1) = norm(startVec);
Q(:,1) = startVec / U(1,1);

for n = 2:(order + 1)
  v = -mat{2} * Q(:,n-1);
  for m = 2:min(length(mat) - 1, n - 1)
    eNmM = zeros(n-m,1);
    eNmM(n-m) = 1;
    v = v - mat{m+1} * (Q(:,1:(n-m)) * (PUw(U, 2, m, n) * eNmM));
  end
  v = fact.Q * (fact.U \ (fact.L \ (fact.P * v)));
  for alpha = 1:(n-1)
    U(alpha,n) = Q(:,alpha)' * v;
    v = v - U(alpha,n) * Q(:,alpha);
  end
  U(n,n) = norm(v);
  Q(:,n) = v / U(n,n);
end
