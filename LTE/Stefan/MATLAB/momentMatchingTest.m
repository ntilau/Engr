close all;
clear all;

dim = 10;

for k = 1:4
  A{k} = rand(dim);
  A{k} = A{k}+A{k}';
end

Ainv = inv(A{1});

for k = 1:3
  C{k} = -Ainv * A{k+1};
  D{k} = -Ainv' * (A{k+1})';
end

b = rand(dim,1);
c = rand(dim,1);

g = Ainv * b;
z = Ainv' * c;

m(2) = c' * (C{2} + C{1} * C{1}) * g;
m(3) = c' * (C{3} + C{1} * C{2} + C{2} * C{1} + C{1}*C{1}*C{1}) * g;
m(4) = c' * (C{3}*C{1} + C{1}*C{3} + C{1}*C{2}*C{1} + C{1}*C{1}*C{2} + ...
  C{2}*C{1}*C{1} + C{1}*C{1}*C{1}*C{1} + C{2}*C{2}) * g;
m

V(:,1) = g;
V(:,2) = C{1} * g;
V(:,3) = C{1} * V(:,2) + C{2} * g;
%V(:,4) = C{1} * V(:,3) + C{2} * V(:,2) + C{3} * V(:,1);
[Ur,S,Vs] = svd(V,0);
% Ur = V;

W(:,1) = z;
W(:,2) = D{1} * z;
W(:,3) = D{1} * W(:,2) + D{2} * z;
%W(:,4) = D{1} * W(:,3) + D{2} * W(:,2) + D{3} * W(:,1);
[Ul,Sl,Vl] = svd(W, 0);
% Ul = Ur;
% Ur = Ul;

% % orthogonalization once again: modified Gram Schmidt
% K = [V W];
% [r c] = size(K);
% R = zeros(c,c);
% for k = 1:c
%   R(k,k) = norm(K(:,k));
%   K(:,k) = K(:,k)/R(k,k);
%   for l = (k+1):c
%     R(k,l) = K(:,k)'*K(:,l);
%     K(:,l) = K(:,l)-R(k,l)*K(:,k);
%   end
% end
% Ul = K(:,c/2+1:c);


for k = 1:4
  Ar{k} = Ul' * A{k} * Ur;
end
br = Ul'*b;
cr = Ur'*c;

Arinv = inv(Ar{1});

for k = 1:3
  Cr{k} = -Arinv * Ar{k+1};
end

gr = Arinv * br;
zr = Arinv' * cr;

mr(2) = cr' * (Cr{2} + Cr{1} * Cr{1}) * gr;
mr(3) = cr' * (Cr{3} + Cr{1} * Cr{2} + Cr{2} * Cr{1} + ...
  Cr{1}*Cr{1}*Cr{1}) * gr;
mr(4) = cr' * (Cr{3}*Cr{1} + Cr{1}*Cr{3} + Cr{1}*Cr{2}*Cr{1} + ...
  Cr{1}*Cr{1}*Cr{2} + Cr{2}*Cr{1}*Cr{1} + Cr{1}*Cr{1}*Cr{1}*Cr{1} + ...
  Cr{2}*Cr{2}) * gr;
mr

