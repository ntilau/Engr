close all;
clear all;

L = 2;
C = 2;
G = 1.5;
omega_r = 1 / sqrt(L * C);
omega = 0 : 0.01 : 1;
alpha = 0 : 0.001 : 0.5;
V = zeros(length(omega), length(alpha));
for omegaCnt = 1 : length(omega)
  for alphaCnt = 1 : length(alpha)
    s0 = -alpha(alphaCnt) + omega(omegaCnt) * j;
    V(omegaCnt, alphaCnt) = -1 / C * s0 ./ (s0.^2 + s0 * G / C + omega_r^2);
  end
end
figure;
% surf(alpha, omega, abs(V));
contour(alpha, omega, log10(abs(V)));
xlabel('alpha');
ylabel('omega');
grid;

figure;
plot(omega, abs(V(:, 1)));
xlabel('omega');
grid;
