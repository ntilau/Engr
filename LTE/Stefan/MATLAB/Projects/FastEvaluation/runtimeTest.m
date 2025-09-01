function x1 = runtimeTest(A, b)

x1 = A \ b;
[L U] = lu(A);
% x2 = forwardBack(L, U, b);
for k = 1 : size(A, 1)
%   x2 = forwardBack(L, U, b);
  x2 = U \ (L \ b);
end 
display(norm(x1 - x2));


% function x2 = forwardBack(L, U, b)
% 
% x2 = U \ (L \ b);

