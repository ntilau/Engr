%
%
%
function [omega_real, Ez, X, Y] = calcRealSol(x, a, b, mu0, eps0)
s = 1 ;
term = ceil(sqrt(x)) ;
[X, Y] = meshgrid(0:0.01:a, 0:0.01:b) ;
[tmp1, tmp2] = size(X) ;
Ez = zeros(tmp1, tmp2, x) ;

for ii = 1:term
    for jj = 1:term
        m = ii ;
        n = jj ;
        omega_real(s,1) = sqrt(1/(mu0*eps0)*((m*pi/a)^2+(n*pi/b)^2)) ; 
        omega_real(s,2) = ii ;
        omega_real(s,3) = jj ;
        s = s + 1 ;
    end
end

tmp = sortrows(omega_real);
omega_real = tmp(:,1) ;

for ii = 1:x
    Ez(:,:,ii) = sin(tmp(ii,2)*pi/a*X).*sin(tmp(ii,3)*pi/b*Y) ;
end