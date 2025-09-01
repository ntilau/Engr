function [val_real] = calcAnalytSol(proj, NUM_EIGS, eps0, mu0)

x=0;
y=0;
m = linspace(0,ceil(sqrt(NUM_EIGS)),ceil(sqrt(NUM_EIGS))+1);
n = linspace(0,ceil(sqrt(NUM_EIGS)),ceil(sqrt(NUM_EIGS))+1);
k = 1 ;

for ii = 1:proj.nodeDim
    if (x<proj.netz.node(ii).x)
        x = proj.netz.node(ii).x
    end
    if (y<proj.netz.node(ii).y)
        y = proj.netz.node(ii).y
    end
end

for ii = 1:ceil(sqrt(NUM_EIGS))
    for jj = 1:ceil(sqrt(NUM_EIGS))
        val_(k) = 1/2/sqrt(eps0*mu0)*sqrt((m(ii)/x)^2+(n(jj)/y)^2) ;
        k = k+1 ;
    end
end
val_ = sort(val_) ;
val_real = val_(2:end) ;