function [Q H] = Arnoldi(fact, mat, startVec, order)

Q(:,1) = startVec / norm(startVec);
H = zeros(order+1,order+1);
for orderCnt = 1:order
  v = fact.Q * (fact.U \ (fact.L \ (fact.P * mat * Q(:,orderCnt))));
  for j = 1:orderCnt
    H(j,orderCnt) = Q(:,j)' * v;
    v = v - H(j,orderCnt) * Q(:,j);
  end
  H(orderCnt + 1,orderCnt) = norm(v);
  Q(:,orderCnt + 1) = v / H(orderCnt + 1,orderCnt);
end
