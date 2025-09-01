% This script calculates the eigenvalues of the models of different order
% in arbitrary direction

close all;
clear all;

pathName = 'C:\work\examples\DualModeDielWG_Filter\dualmodedielwg_filter_1.2e+010_21_6\';
fNameModRedTxt = strcat(pathName, 'modelParam.txt');
[f0, mu0, numLeftVecs] = readModParaTxt(fNameModRedTxt);

c0 = 299792.458e3;
k0 = 2.0*pi*f0/c0;

fontsize = 12;
linewidth = 1.5;
figure;
hold;
grid;

% pathName = 'C:\work\examples\DualModeDielWG_Filter\dualmodedielwg_filter_1.2e+010_21_4\';
% polesAngle45_4 = calcPolesAngle(pathName, k0, 45);
% plot(real(polesAngle45_4), imag(polesAngle45_4), 'rs');

pathName = 'C:\work\examples\DualModeDielWG_Filter\dualmodedielwg_filter_1.2e+010_21_6\';
polesAngle45_6 = calcPolesAngle(pathName, k0, 0);
plot(real(polesAngle45_6), imag(polesAngle45_6), 'bx');
axis([0 40e9 0 2.5e10]);

pathName = 'C:\work\examples\DualModeDielWG_Filter\dualmodedielwg_filter_1.2e+010_21_8\';
polesAngle45_8 = calcPolesAngle(pathName, k0, 0);
plot(real(polesAngle45_8), imag(polesAngle45_8), 'r<');
axis([0 40e9 0 2.5e10]);

curvesConstRatio;

% pathName = 'C:\work\examples\DualModeDielWG_Filter\dualmodedielwg_filter_1.2e+010_21_6\';
% polesAngle0_6 = calcPolesAngle(pathName, k0, 0);
% plot(real(polesAngle0_6), imag(polesAngle0_6), 'kd');
% 
% pathName = 'C:\work\examples\DualModeDielWG_Filter\dualmodedielwg_filter_1.2e+010_21_6\';
% polesAngle0_6 = calcPolesFreq(pathName, k0);
% plot(real(polesAngle0_6), imag(polesAngle0_6), 'g>');

% pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\';
% polesMu10 = calcPolesMu(pathName, mu0, k0);
% plot(real(polesMu10), imag(polesMu10), 'cv');
% % 
% % % pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_12\';
% % % polesMu12 = calcPolesMu(pathName, mu0, k0);
% % % plot(real(polesMu12), imag(polesMu12), 'm^');
% % 
% pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\';
% polesMu20 = calcPolesMu(pathName, mu0, k0);
% plot(real(polesMu20), imag(polesMu20), 'm<');
% 
% pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20_oneParam\';
% polesMu20 = calcPolesMu(pathName, mu0, k0);
% plot(real(polesMu20), imag(polesMu20), 'g>');
% 
% pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_23\';
% polesMu20 = calcPolesMu(pathName, mu0, k0);
% plot(real(polesMu20), imag(polesMu20), 'b^');
% 
% %axis([0 100 -10 10]);
% % legend('MOR 2', 'MOR 4', 'MOR 6', 'MOR 8', 'MOR 10', ...'MOR 12', 
% %   'MOR 20');
% legend('MOR 8', 'MOR 10', 'MOR 20', 'MOR 20 Mu', 'MOR 23');
