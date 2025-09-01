close all;
clear all;

x_min = -1;
x_max = 5;
x = x_min : (x_max-x_min)/100 : x_max;

xi(1) = 1;
xi(2) = 2;
xi(3) = 3;

order = 1;
lambda = ones(length(xi), length(x));
for m = 1:length(xi)
  for n = 1:length(xi)
    if m ~= n
      lambda(m,:) = lambda(m,:).*(x-xi(n))./(xi(m)-xi(n));
    end
  end
end

for k = 1:length(xi)
  figure;
  plot(x, lambda(k,:));
  grid;
end

figure;
plot(x, lambda(1,:) + 2*lambda(2,:) + 3*lambda(3,:));
