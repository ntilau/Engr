function [Z]=ZetaL(Z1,Z2,l,k)

Z = Z1*(Z2+sqrt(-1)*Z1*tan(k*l))/(Z1+sqrt(-1)*Z2*tan(k*l));
