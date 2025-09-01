close all;
clear all;

num_iter = 10;

lambda(1) = 1;
lambda(2) = 9;

A = zeros(length(lambda));
for k = 1:length(lambda)
  A(k,k) = lambda(k);
end
b = zeros(length(lambda),1);
x = zeros(length(lambda), num_iter);
x(:,1) = [9; 1];

for k = 2:10
  d = -(A*x(:,k-1)-b); 
  alpha = (d'*d)/(d'*A*d);
  x(:,k) = x(:,k-1) + alpha*d;
  f(k) = 0.5*x(:,k)'*A*x(:,k);
  
end

x1 = -10:0.1:10;
x2 = -10:0.1:10;
F = zeros(length(x1), length(x2));
for k1 = 1:length(x1)
  for k2 = 1:length(x2)
    y = [x1(k1); x2(k2)];
    F(k1,k2) = 0.5*y'*A*y;
  end
end

contour(x1,x2,F',f);
hold;
plot(x(1,:), x(2,:))

figure;
surfc(x2,x1,F);
