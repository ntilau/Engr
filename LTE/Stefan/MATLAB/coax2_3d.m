% 3D-Plots of coax2

close all;
clear;

eta0 = 376.73031346177066;

%f = [0.0:0.05:6]*1e9;
c = 299792458.00000000;
pi_ = 3.1415926535897931;
%k0 = 2*pi_*f/c;

% analytical calculation of reflection coefficent
len1=0.05;
len2=0.025;

%filename = 'C:\work\examples\coax2\results\sParam_coax2_3e9_4_15.txt';
%filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_9\sParam.txt';
%[mus, freqs, s, de] = readS_ParamDetOld(filename);
%filename = 'C:\work\examples\coax2\coax2_3e+009_4_10\sParam.txt';
filename = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_10_pN_simple\sParam.txt';
%filename = 'C:\work\examples\coaxParam\coaxParam_1e+008_1_5\sParam_ref.txt';
%filename = 'C:\work\examples\coax\coax2\coax2_3e+009_4_7\s_f_2e+009_2e+007_4e+009_m_3_0.02_5.txt';
%filename = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_10_pN\s11_f_1e9_1p75e7_4p5e9_m_1_0p03_7.txt';
% filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_10_opt_ortho\s_f_1e+009_3e+007_7e+009_m_1_0.03_7.txt';
% filename = 'C:\work\Testbed\examples\EM_WaveModelReductionProblems\coax2\references\s_f_2e+009_2e+007_4e+009_m_3_0.02_5.txt';
%[mus, freqs, s, de] = readS_ParamDet(filename);
% Impedance formulation:
% filename = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_10_pN\s_11_f_1e+009_4.5e+009_301_m_1_7_301.txt';
%filename = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_10_pN\s_11_f_1e+009_4.5e+009_101_m_1_7_101.txt';
filename = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_10_pN\s_11_f_1e+009_4.5e+009_301_m_1_7_301.txt';
[mus, freqs, s, s12] = readSparamMOR(filename);
% filename = 'C:\work\examples\coax\coax2\coax2_3e+009_(4,0)_7_ref\s_f_1e+009_3e+009_51_m_(1,0)_(3,0)_51.txt';
% [mus, freqs, s, s12] = readSparamMOR(filename);

figHandle = figure;
%surf(abs(s))
%limit = 0.62;
limit = 1.1;
abs_s = abs(s);
% for col = 1:length(freqs)
%     for row = 1:length(mus)
%         if(abs_s(row,col) > limit)
%             abs_s(row,col) = NaN;
%         end
%     end
% end

fontsize = 14;

%cut = find(freqs>1e9 & freqs<4.5e9);
%cut = find(freqs>1e7);
%freqs = freqs(cut);
%surf(freqs*1e-9, mus, abs_s(:,cut));
surf(freqs*1e-9, mus, abs_s);
colormap('gray');
set(figHandle,'color','w');
%title('Reduced model: coax')
set(0, 'DefaultAxesFontSize', fontsize);
axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end) 0 0.6 0 0.6]);
% caxis([0 0.6])
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('\mu_r', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
%view([-119.00 68.00]);
view([0 90]);

%print -deps coax3dTopViewTransparent -zbuffer -r600;
%print('-dbitmap', 'Z:\ortwin\Eigene Dateien\Worddokumente\Compumag 2005\coax2_3d')

%% analytical solution

% less points for better b/w plot
% musBack = mus;
mus = 1:6e-2:7;
% mus = mus(1:2:length(mus));
% freqsBack = freqs;
freqs = 1e9:35000000:4.5e9;
% freqs = freqs(1:2:length(freqs));

k0 = 2*pi_*freqs/c;
zW1 = ones(length(mus), length(k0)).*eta0;
%zW2 = ones(length(mu), length(k0)).*(eta0/2));
zW2 = ones(length(mus), length(k0)).*(eta0/(2));

for row = 1:length(mus)
    zW2(row,:) = zW2(row,:).*sqrt(mus(row));
end

gamma1 = zeros(length(mus), length(k0));
gamma2 = zeros(length(mus), length(k0));
for row=1:length(mus)
    gamma1(row,:) = j*k0.';
    for col=1:length(k0)
        gamma2(row,col) = j*k0(col)*2.*sqrt(mus(row));
    end
end

rho0 = (zW1-zW2)./(zW1+zW2).*ones(length(mus), length(k0));
rhoLen = rho0.*exp(2*gamma2*len1);
zLen = zW2.*(1+rhoLen)./(1-rhoLen);

rho0_1 = (zLen - zW1)./(zLen + zW1);
rhoLen_1 = rho0_1.*exp(2*gamma1*len2);

figHandle = figure;
surf(freqs*1e-9, mus, abs(rhoLen_1))
set(figHandle,'color','w');
axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end) 0 0.6])
%title('analytical solution');

xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('Relative magnetic permeability', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
view([-119.00 68.00]);
% %view([-122.00 82.00]);

%% Simple and less stable method: model computed at 21.07.2007
fNameSpara = 'C:\work\examples\coax\coax2\results\coax2_3e+009_MU_RELATIVE_74_(4,0)_10_simple_new\S_f_1e+009_4.5e+009_101_MU_RELATIVE_74_(1,0)_(7,0)_101.txt';
% fNameSpara = 'C:\work\examples\coax\coax2\results\coax2_3e+009_MU_RELATIVE_74_(4,0)_10_stable_new\S_f_1e+009_4.5e+009_101_MU_RELATIVE_74_(1,0)_(7,0)_101.txt';
% fNameSpara = 'C:\work\examples\coax\coax2\coax2_3e+009_MU_RELATIVE_74_(4,0)_10\S_f_1e+009_4.5e+009_101_MU_RELATIVE_74_(1,0)_(7,0)_101.txt';
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
  = loadSmatrix(fNameSpara);

% plot results
figHandle = figure;
set(figHandle,'color','w');

% % one parameter plot
% sVal = zeros(numParameterPnts(1),1);
% freqs = zeros(numParameterPnts(1),1);
% for k = 1:numParameterPnts(1)
%   freqs(k) = parameterVals(1,k);
%   sVal(k) = sMatrices{k}(1, 1);
% end
% plot(freqs*1e-9, abs(sVal));

% two parameter plot
pos = 1;
nonOnePos = find(numParameterPnts(2:end) ~= 1) + 1;
freqs = zeros(numParameterPnts(1),1);
matVals = zeros(numParameterPnts(2),1);
sVal = zeros(numParameterPnts(nonOnePos),numParameterPnts(1));
for fCnt = 1:numParameterPnts(1)
  for pCnt = 1:numParameterPnts(nonOnePos)
    freqs(fCnt) = parameterVals(1,pos);
    matVals(pCnt) = parameterVals(2,pos);
    sVal(pCnt, fCnt) = sMatrices{pos}(1, 1);
    pos = pos + 1;
  end
end
surf(freqs*1e-9, matVals, abs(sVal));
AZ = -119.00;
EL = 68.00;
view(AZ, EL);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('Relative magnetic permeability', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
axis([1 4.5 1 7 0 1]);
%title('\epsilon_{r2} = 8', 'FontSize', fontsize);
set(gca,'FontSize',fontsize);
title('', 'FontSize', fontsize);

fontsize = 10;
figHandle = figure;
set(figHandle,'color','w');
surf(freqs*1e-9, matVals, abs(sVal - conj(rhoLen_1)));
AZ = -119.00;
EL = 68.00;
view(AZ, EL);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('Relative magnetic permeability', 'FontSize', fontsize);
zlabel('|Error S_{11}|', 'FontSize', fontsize);
axis([1 4.5 1 7 1e-6 1]);
set(gca,'FontSize',fontsize);
set(gca, 'ZTick', [1e-6 1e-4 1e-2 1e-0]);



%% Simple and less stable method
filename = 'C:\work\examples\coax\coax2\results\coax2_3e+009_4_15_simple\sParam_total.txt';
[mus, freqs, s, de] = readS_ParamDet(filename);

figHandle = figure;
limit = 0.8;
abs_s = abs(s);
for col = 1:length(freqs)
    for row = 1:length(mus)
        if(abs_s(row,col) > limit)
            abs_s(row,col) = NaN;
        end
    end
end

fontsize = 20;

cut = find(freqs > 1e9 & freqs < 4.5e9);
freqs = freqs(cut);
% % less points for better b/w plot
% freqs = freqs(1:2:length(freqs));
% mus = mus(1:2:length(mus));

[r c] = size(s);
surf(freqs*1e-9, mus, abs_s(:, cut));
set(figHandle,'color','w');
% title('Reduced model: coax - simple approach')
axis([freqs(1)*1e-9 freqs(end)*1e-9 mus(1) mus(end) 0 0.6])
caxis([0 0.6])
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('Relative magnetic permeability', 'FontSize', fontsize);
zlabel('|S_{11}|', 'FontSize', fontsize);
view([-119.00 68.00]);
% view([-122.00 82.00]);



% 
% % % plot abs(error)
% % figure;
% % surf(freqs, mus, abs(rhoLen_1-s))
% % axis([freqs(1) freqs(end) mus(1) mus(end) 0 0.4])
% % caxis([0 0.4])
% 
% % filename = 'C:\work\examples\coax2\sParam.txt';
% % [mus, freqs, s, de] = readS_ParamDet(filename);
% % 
% % figure
% % surf(freqs, mus, abs(s))
% % title(filename)
% % axis([freqs(1) freqs(end) mus(1) mus(end) 0 0.8])
% % caxis([0 0.8])
% % 
% % figure
% % limit = 5;
% % abs_de = abs(de);
% % for col = 1:length(freqs)
% %     for row = 1:length(mus)
% %         if(abs_de(row,col) > limit)
% %             abs_de(row,col) = limit;
% %         end
% %     end
% % end
% % 
% % % tri = delaunay(freqs(1:length(mus)),mus);
% % % trisurf(tri,freqs(1:length(mus)),mus,abs_de(:,1:length(mus)))
% % surf(freqs, mus, abs_de)
% % title(filename)
% % axis([freqs(1) freqs(end) mus(1) mus(end) 0 limit])
% % caxis([0 limit])
% % % 
% % % analytical solution
% % k0 = 2*pi_*freqs/c;
% % zW1 = ones(length(mus), length(k0)).*eta0;
% % %zW2 = ones(length(mu), length(k0)).*(eta0/2));
% % zW2 = ones(length(mus), length(k0)).*(eta0/(2));
% % 
% % for row = 1:length(mus)
% %     zW2(row,:) = zW2(row,:).*sqrt(mus(row));
% % end
% % 
% % gamma1 = zeros(length(mus), length(k0));
% % gamma2 = zeros(length(mus), length(k0));
% % for row=1:length(mus)
% %     gamma1(row,:) = j*k0.';
% %     for col=1:length(k0)
% %         gamma2(row,col) = j*k0(col)*2.*sqrt(mus(row));
% %     end
% % end
% % 
% % rho0 = (zW1-zW2)./(zW1+zW2).*ones(length(mus), length(k0));
% % rhoLen = rho0.*exp(2*gamma2*len1);
% % zLen = zW2.*(1+rhoLen)./(1-rhoLen);
% % 
% % rho0_1 = (zLen - zW1)./(zLen + zW1);
% % rhoLen_1 = rho0_1.*exp(2*gamma1*len2);
% % 
% % figure;
% % surf(freqs, mus, abs(rhoLen_1))
% % title('analytical solution');
% % 
% 
% 

% filename = 'C:\work\examples\coaxParam\coaxParam_1e+008_(1,0)_4_eps\s_11_f_1e+008_2e+008_101_e_4_1_101.txt';
% [mus, freqs, s, s12] = readSparamMOR(filename);
% 
% figHandle = figure;
% limit = 1.1;
% abs_s = abs(s);
% 
% fontsize = 24;
% 
% surf(freqs*1e-9, mus, abs_s);

%% test

dim = 5;
A0 = rand(dim);
A0 = A0 * A0';
A1 = rand(dim);
A1 = A1 * A1';
A2 = rand(dim);
A2 = A2 * A2';
[X E] = polyeig(A0, A1, A2);
A0d = X' * A0 * X;
A1d = X' * A1 * X;
A2d = X' * A2 * X;
display(A0d);
display(A1d);
display(A2d);
