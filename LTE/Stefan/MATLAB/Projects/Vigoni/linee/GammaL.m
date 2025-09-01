function [G]=GammaL(Z1,Z2,l,k)

G = (Z2-Z1)/(Z2+Z1) * exp(-sqrt(-1)*2*k*l);
