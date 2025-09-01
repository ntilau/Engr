% This script calculates the geometry parameter of diel_filter1
% Filter is found in:
% Author: Hui-Wen Yao and Kawthar A. Zaki
% Title: Modeling of Generalized Coaxial Probes in Rectangular Waveguide
% Journal: Microwave Theory and Techniques Vol. 43, No. 12, Dec 1995
% all dimensions are inches

wgLength = 0.242 + 0.07 + 0.067 + 0.293 + 0.072 + 0.344 + 0.072 + ...
            0.351 + 0.072 + 0.345 + 0.072 + 0.294 + 0.067 + 0.07 + 0.242
            
c0 = 299792.458e3;
mu0 = 4e-7*pi;
eta0 = mu0*c0;
eta = eta0/sqrt(2)