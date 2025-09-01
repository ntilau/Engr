function [c, ceq] = conFun(mu)
% mu is a vector with mu(1)=real(mu) and mu(2)=imag(mu)
% The constraint equations are:
% 0 <= real(mu) <= 15
% -10 <= imag(mu) <= 0

% Nonlinear inequality constraints
c = [-mu(1); mu(1)-15; mu(2); -10-mu(2)];

% Nonlinear equality constraints
ceq = [];