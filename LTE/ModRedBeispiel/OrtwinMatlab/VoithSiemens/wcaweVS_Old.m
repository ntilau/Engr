function [Q U] = wcaweVS_Old(fact, model, order)

Q = zeros(size(model.sysMat{1}, 1), order + 1);
U = zeros(order + 1, order + 1);
sol1 = fact.Q * (fact.U \ (fact.L \ (fact.P * model.rhs{1})));
U(1, 1) = norm(sol1);
Q(:, 1) = sol1 / U(1, 1);

for n = 2 : (order + 1)
  v = zeros(size(fact.L, 1), 1);
  if nnz(model.sysMat{2})
    v = -model.sysMat{2} * Q(:, n - 1);
  end
  % correction terms previous vectors
  for m = 2 : min(length(model.sysMat) - 1, n - 1)
    eNmM = zeros(n - m, 1);
    eNmM(n - m) = 1;
    if ~nnz(v)
      v = -model.sysMat{m + 1} * (Q(:, 1 : (n - m)) * (PUw(U, 2, m, n) * eNmM));
    else
      v = v - model.sysMat{m + 1} * (Q(:, 1 : (n - m)) * (PUw(U, 2, m, n) * eNmM));
    end
  end
  % correction terms rhs
  for m = 1 : min(length(model.rhs) - 1, n - 1)
    if (m + 1) <= length(model.rhs)
      pu2 = PUw(U, 1, m, n);
      if nnz(model.rhs{m + 1})
        if ~nnz(v)
          v = pu2(1, n - m) * model.rhs{m + 1};
        else
          v = v + pu2(1, n - m) * model.rhs{m + 1};
        end
      end
    end
  end
  if nnz(v)
    v = fact.Q * (fact.U \ (fact.L \ (fact.P * v)));
    for alpha = 1 : (n - 1)
      U(alpha, n) = Q(:, alpha)' * v;
      v = v - U(alpha, n) * Q(:, alpha);
    end
    U(n, n) = norm(v);
    Q(1 : length(v), n) = v / U(n, n);
  else
    U(n, n : size(U, 2)) = ones(1, size(U, 2) - n + 1);
  end
end
