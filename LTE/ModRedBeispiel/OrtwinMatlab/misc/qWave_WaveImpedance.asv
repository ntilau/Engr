% computation of different parameters of qwave1

eta0 = 376.73031346177066;
c0 = 299792458.00000000;

eps_r = 2.2;
mu_r = 1;

wImp = eta0*sqrt(mu_r/eps_r)

k = 7.2e9*(2*pi)/c0*sqrt(eps_r*mu_r)

a = rand(3,1);
b = rand(3,1);
c = rand(3,1);
c = c./norm(c);

a'*cross(cross(a,b),cross(a,c))
cross(a,cross(a,b))'*cross(a,cross(a,c))

cross(a,b)'*c
cross(cross(a,c),cross(b,c))'*c

k0 = 7.2e9*(2*pi)/c0
k0*eta0
