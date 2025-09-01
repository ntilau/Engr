% Examination of WCAWE for polynomial matrix equations

clear all;
close all;

dim = 10;
order = 6;

% initial problem: (s*A1 + s^2*A2 + s^3*A3)*x = b
b0 = randn(dim,1);
b1 = randn(dim,1);
b2 = randn(dim,1);
% b1 = zeros(dim,1);
% b2 = zeros(dim,1);
A1 = randn(dim);
A2 = randn(dim);
A3 = randn(dim);
% load WCAWE_TestDat
% A2 = zeros(dim);
% A3 = zeros(dim);

% ordinary AWE
W(:,1) = b0;
W(:,2) = b1 - A1*W(:,1);
W(:,3) = b2 - A1*W(:,2) - A2*W(:,1);
for k = 4:order
    W(:,k) = -A1*W(:,k-1) - A2*W(:,k-2) - A3*W(:,k-3);
end
% display(W);
[Q, R] = qr(W,0);


% WCAWE
V_(:,1) = b0;
V(:,1) = V_(:,1)/norm(V_(:,1));
U(1,1) = norm(V_(:,1));
V_(:,2) = b1 * U(1,1)^-1 - A1*V(:,1);
% [V U] = qr(V_,0);
  
% modified Gram Schmidt
q = 2;
for k = 1:(q - 1)
  proj = V(:,k)' * V_(:,q);
  V_(:,q) = V_(:,q) - proj * V(:,k);
  U(k, q) = proj;
end
normQ = norm(V_(:,q));
V(:,q) = V_(:,q) / normQ;
U(q, q) = normQ;
  
% PU1b1 = inv(U(1:2,1:2));
PU1b1 = inv(U(1:2,1:2));
V_(:,3) = b1*PU1b1(1,2) + b2*U(1,1)^-1*U(2,2)^-1 ...
  - A1*V(:,2) - U(2,2)^(-1) * A2 * V(:,1);
% V_(:,3) = b1*PU1b1(1,2) + b2*U(1,1)*U(2,2) ...
%   - A1*V(:,2) - U(2,2)^(-1) * A2 * V(:,1);
% [V U] = qr(V_,0);

% modified Gram Schmidt
q = 3;
for k = 1:(q - 1)
  proj = V(:,k)' * V_(:,q);
  V_(:,q) = V_(:,q) - proj * V(:,k);
  U(k, q) = proj;
end
normQ = norm(V_(:,q));
V(:,q) = V_(:,q) / normQ;
U(q, q) = normQ;

for q=4:order
  e1 = zeros(q-2,1);
  e1(q-2,1) = 1;
  e2 = zeros(q-3,1);
  e2(q-3,1) = 1;
  PU1 = PU_Generation(U,2,q,2);
  PU2 = PU_Generation(U,2,q,3);
  PU1b = PU_Generation(U,1,q,1);
  PU2b = PU_Generation(U,1,q,2);
  V_(:,q) = b1 * PU1b(1,q-1) + b2 * PU2b(1,q-2) - A1*V(:,q-1)...
    - A2*V(:,1:(q-2))*PU1*e1 - A3*V(:,1:(q-3))*PU2*e2;
  % modified Gram Schmidt
  for k = 1:(q - 1)
    proj = V(:,k)' * V_(:,q);
    V_(:,q) = V_(:,q) - proj * V(:,k);
    U(k, q) = proj;
  end
  normQ = norm(V_(:,q));
  V(:,q) = V_(:,q) / normQ;
  U(q, q) = normQ;    
%   [V U] = qr(V_,0);
end


C = inv(V'*W);
D = V' * W;
R = inv(D)*U;
display(C);
display(R);
