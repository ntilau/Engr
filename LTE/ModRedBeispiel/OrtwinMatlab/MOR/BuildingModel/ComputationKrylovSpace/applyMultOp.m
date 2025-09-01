function y = applyMultOp(A, fact, b)
% A is a matrix
% fact is a factorization structure of matrix X with 
% fact.P * X * fact.Q = fact.L * fact.U
% b is a vector
% y = fact^{-1}*A*b

y = A*b;
if ~isempty(fact)
  if ~isempty(fact.P)
    y = fact.P*y;
  end
  y = fact.U\(fact.L\y);
  if ~isempty(fact.Q)
    y = fact.Q*y;
  end
end
