% This script calculates the eigenvalues of the models of different order
close all;
% clear all;

pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\';
fNameModRedTxt = strcat(pathName, 'modelParam.txt');
[f0, mu0, numLeftVecs] = readModParaTxt(fNameModRedTxt);

c0 = 299792.458e3;
k0 = 2.0*pi*f0/c0;

fontsize = 12;
linewidth = 1.5;
figure;
hold;
grid;

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\sParam.txt';
[m, f, s_, de] = readS_ParamDet(filename);
plot(m, abs(s_), 'LineWidth', linewidth, 'Color','red');
title('Auswertung in negative Richtung');

% pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_2\';
% polesMu2 = calcPolesMu(pathName, mu0, k0);
figure;
% plot(real(polesMu2), imag(polesMu2), 'x');
hold;
grid;
% 
% pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_4\';
% polesMu4 = calcPolesMu(pathName, mu0, k0);
% plot(real(polesMu4), imag(polesMu4), 'go');
% 
% pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_6\';
% polesMu6 = calcPolesMu(pathName, mu0, k0);
% plot(real(polesMu6), imag(polesMu6), 'kd');
% 
pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_8\';
polesMu8 = calcPolesMu(pathName, mu0, k0);
plot(real(polesMu8), imag(polesMu8), 'rs');

pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\';
polesMu10 = calcPolesMu(pathName, mu0, k0);
plot(real(polesMu10), imag(polesMu10), 'cv');
% 
% % pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_12\';
% % polesMu12 = calcPolesMu(pathName, mu0, k0);
% % plot(real(polesMu12), imag(polesMu12), 'm^');
% 
pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\';
polesMu20 = calcPolesMu(pathName, mu0, k0);
plot(real(polesMu20), imag(polesMu20), 'm<');

pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20_oneParam\';
polesMu20 = calcPolesMu(pathName, mu0, k0);
plot(real(polesMu20), imag(polesMu20), 'g>');

pathName = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_23\';
polesMu20 = calcPolesMu(pathName, mu0, k0);
plot(real(polesMu20), imag(polesMu20), 'b^');

%axis([0 100 -10 10]);
% legend('MOR 2', 'MOR 4', 'MOR 6', 'MOR 8', 'MOR 10', ...'MOR 12', 
%   'MOR 20');
legend('MOR 8', 'MOR 10', 'MOR 20', 'MOR 20 Mu', 'MOR 23');

fontsize = 12;
linewidth = 1.5;
figure;
hold;
grid;

% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_2\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, abs(s_), 'LineWidth', linewidth, 'Color','blue');
% 
% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_4\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, abs(s_), 'LineWidth', linewidth, 'Color','green');
% 
% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_6\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, abs(s_), 'LineWidth', linewidth, 'Color','black');

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_8\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
[m, f, s_, de] = readS_ParamDet(filename);
plot(m, abs(s_), 'LineWidth', linewidth, 'Color','red');

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
[m, f, s_, de] = readS_ParamDet(filename);
plot(m, abs(s_), 'LineWidth', linewidth, 'Color','cyan');

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
[m, f, s_, de] = readS_ParamDet(filename);
plot(m, abs(s_), 'LineWidth', linewidth, 'Color','magenta');

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20_oneParam\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
[m, f, s_, de] = readS_ParamDet(filename);
plot(m, abs(s_),'--g', 'LineWidth', linewidth);

filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_23\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
[m, f, s_, de] = readS_ParamDet(filename);
plot(m, abs(s_), 'LineWidth', linewidth, 'Color','blue');

% legend('MOR 2', 'MOR 4', 'MOR 6', 'MOR 8', 'MOR 10', ...'MOR 12', 
%   'MOR 20', 'MOR 20 Mu');

legend('MOR 8', 'MOR 10', 'MOR 20', 'MOR 20 Mu', 'MOR 23');

% figure;
% hold;
% grid;

% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_2\sParam.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, abs(s_), 'LineWidth', linewidth, 'Color','blue');
% 
% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_4\sParam.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, abs(s_), 'LineWidth', linewidth, 'Color','green');
% 
% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_6\sParam.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, abs(s_), 'LineWidth', linewidth, 'Color','black');

% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_8\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, angle(s_), 'LineWidth', linewidth, 'Color','red');
% 
% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_10\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, angle(s_), 'LineWidth', linewidth, 'Color','cyan');
% 
% filename = 'C:\work\examples\DualModeDielWG_Filter\results\dualmodedielwg_filter_1.2e+010_21_20\s11_f_12e9_0_12e9_m_1_0p1_100.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% plot(m, angle(s_), 'LineWidth', linewidth, 'Color','magenta');
% 
% % legend('MOR 2', 'MOR 4', 'MOR 6', 'MOR 8', 'MOR 10', ...'MOR 12', 
% %   'MOR 20');
% legend('MOR 8', 'MOR 10', 'MOR 20');


% filename = 'C:\work\examples\DualModeDielWG_Filter\DualModeDielWG_Filter_1.2e+010_21_5\sParam.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% figure
% plot(m, angle(s_), 'LineWidth', linewidth, 'Color','red');
% 
% filename = 'C:\work\examples\DualModeDielWG_Filter\DualModeDielWG_Filter_1.2e+010_21_5\sParam.txt';
% [m, f, s_, de] = readS_ParamDet(filename);
% figure
% plot(m, abs(s_), 'LineWidth', linewidth, 'Color','red');

% order = 2;
% numVecs = (order+1)*(order+2)/2;
% sys0ordN = sys0(1:numVecs,1:numVecs);
% sys2ordN = sys1(1:numVecs,1:numVecs);
% 
% [V,D] = eig(sys0ordN,sys2ordN,'qz');
% for k=1:numVecs
%   eigVals(k) = D(k,k);
% end
% %eigVals = sqrt((eigVals+k0^2)*c0^2/(4*pi^2));
% eigVals = eigVals*mu0+mu0;
% plot(real(eigVals), imag(eigVals), 'x')
% hold;
% 
% order = 4;
% numVecs = (order+1)*(order+2)/2;
% sys0ordN = sys0(1:numVecs,1:numVecs);
% sys2ordN = sys1(1:numVecs,1:numVecs);
% 
% [V,D] = eig(sys0ordN,sys2ordN,'qz');
% for k=1:numVecs
%   eigVals(k) = D(k,k);
% end
% %eigVals = sqrt((eigVals+k0^2)*c0^2/(4*pi^2));
% eigVals = eigVals*mu0+mu0;
% plot(real(eigVals), imag(eigVals), 'dr')
% 
% order = 6;
% numVecs = (order+1)*(order+2)/2;
% sys0ordN = sys0(1:numVecs,1:numVecs);
% sys2ordN = sys1(1:numVecs,1:numVecs);
% 
% [V,D] = eig(sys0ordN,sys2ordN,'qz');
% for k=1:numVecs
%   eigVals(k) = D(k,k);
% end
% %eigVals = sqrt((eigVals+k0^2)*c0^2/(4*pi^2));
% eigVals = eigVals*mu0+mu0;
% plot(real(eigVals), imag(eigVals), 'og')
% 
% order = 8;
% numVecs = (order+1)*(order+2)/2;
% sys0ordN = sys0(1:numVecs,1:numVecs);
% sys2ordN = sys1(1:numVecs,1:numVecs);
% 
% [V,D] = eig(sys0ordN,sys2ordN,'qz');
% for k=1:numVecs
%   eigVals(k) = D(k,k);
% end
% %eigVals = sqrt((eigVals+k0^2)*c0^2/(4*pi^2));
% eigVals = eigVals*mu0+mu0;
% plot(real(eigVals), imag(eigVals), 'sk')
% axis([-1 100 -1 1])

% sys0diag = V.'*sys0ord2*V;
% sys2diag = V.'*sys2ord2*V;
% for k=1:numVecs
%   V(:,k) = V(:,k)/sqrt(sys2diag(k,k));
% end
% sys0diagScale = V.'*sys0ord2*V;
% sys2diagScale = V.'*sys2ord2*V;
% 
% %eigVals2 = eig(inv(sys0ord2)*sys2ord2)
% eigVals2 = eig(inv(sys2ord2)*sys0ord2)
%eigVals


