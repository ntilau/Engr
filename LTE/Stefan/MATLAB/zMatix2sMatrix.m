% getting the S-Matrix from the Z-Matrix

close all;
clear all;

eta0 = 376.73031346177066;

%f = [0.0:0.05:6]*1e9;
c = 299792458.00000000;
pi_ = 3.1415926535897931;
%k0 = 2*pi_*f/c;

% analytical calculation of reflection coefficent
len1=0.05;
len2=0.025;

%mu = 1:0.05:10;
%mu = 1:0.1:10;

% zW1 = ones(length(mu), length(k0)).*eta0;
% %zW2 = ones(length(mu), length(k0)).*(eta0/2));
% zW2 = ones(length(mu), length(k0)).*(eta0/(2));
% 
% for row = 1:length(mu)
%     zW2(row,:) = zW2(row,:).*sqrt(mu(row));
% end
% 
% gamma1 = zeros(length(mu), length(k0));
% gamma2 = zeros(length(mu), length(k0));
% for row=1:length(mu)
%     gamma1(row,:) = j*k0;
%     for col=1:length(k0)
%         gamma2(row,col) = j*k0(col)*2.*sqrt(mu(row));
%     end
% end
% 
% rho0 = (zW1-zW2)./(zW1+zW2).*ones(length(mu), length(k0));
% rhoLen = rho0.*exp(2*gamma2*len1);
% zLen = zW2.*(1+rhoLen)./(1-rhoLen);
% 
% rho0_1 = (zLen - zW1)./(zLen + zW1);
% rhoLen_1 = rho0_1.*exp(2*gamma1*len2);
% 
% surf(f, mu, abs(rhoLen_1))
% title('analytical solution');

% filename = 'C:\work\examples\coax2\results\coax2_1e+008_1_20\sParam.txt';
% [mus, freqs, s] = readS_Param(filename);
% 
% figure
% surf(freqs, mus, abs(s))
% title(filename)
% axis([freqs(1) freqs(end) mus(1) mus(end) 0 0.8])
% caxis([0 0.6])

% 2D-Plots
filename = 'C:\work\examples\coax2\results\coax2_3e+009_4_15\sParam.txt';
[m, f, s, de] = readS_ParamDet(filename);

figure;
plot(f, abs(s));


% analytical solution
k0 = 2*pi_*f/c;
zW1 = ones(length(m), length(k0)).*eta0;
%zW2 = ones(length(mu), length(k0)).*(eta0/2));
zW2 = ones(length(m), length(k0)).*(eta0/(2));

for row = 1:length(m)
    zW2(row,:) = zW2(row,:).*sqrt(m(row));
end

gamma1 = zeros(length(m), length(k0));
gamma2 = zeros(length(m), length(k0));
for row=1:length(m)
    gamma1(row,:) = j*k0.';
    for col=1:length(k0)
        gamma2(row,col) = j*k0(col)*2.*sqrt(m(row));
    end
end

rho0 = (zW1-zW2)./(zW1+zW2).*ones(length(m), length(k0));
rhoLen = rho0.*exp(2*gamma2*len1);
zLen = zW2.*(1+rhoLen)./(1-rhoLen);

rho0_1 = (zLen - zW1)./(zLen + zW1);
rhoLen_1 = rho0_1.*exp(2*gamma1*len2);

hold;
plot(f, abs(rhoLen_1))







% 3D-Plots
filename = 'C:\work\examples\coax2\results\sParam_coax2_3e9_4_15.txt';
[mus, freqs, s, de] = readS_ParamDet(filename);

figure
limit = 0.8;
abs_s = abs(s);
for col = 1:length(freqs)
    for row = 1:length(mus)
        if(abs_s(row,col) > limit)
            abs_s(row,col) = NaN;
        end
    end
end

cut = find(freqs>1e9);
freqs = freqs(cut);
surf(freqs, mus, abs_s(:,cut))
title('Reduced model: coax')
axis([freqs(1) freqs(end) mus(1) mus(end) 0 0.6])
caxis([0 0.6])
xlabel('frequency [Hz]');
ylabel('relative magnetic permeability');
zlabel('|S_{11}|');
view([230 30]);

% analytical solution
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

figure;
surf(freqs, mus, abs(rhoLen_1))
title('analytical solution');

xlabel('frequency [Hz]');
ylabel('relative magnetic permeability');
zlabel('|S_{11}|');
view([230 30]);


% % plot abs(error)
% figure;
% surf(freqs, mus, abs(rhoLen_1-s))
% axis([freqs(1) freqs(end) mus(1) mus(end) 0 0.4])
% caxis([0 0.4])

% filename = 'C:\work\examples\coax2\sParam.txt';
% [mus, freqs, s, de] = readS_ParamDet(filename);
% 
% figure
% surf(freqs, mus, abs(s))
% title(filename)
% axis([freqs(1) freqs(end) mus(1) mus(end) 0 0.8])
% caxis([0 0.8])
% 
% figure
% limit = 5;
% abs_de = abs(de);
% for col = 1:length(freqs)
%     for row = 1:length(mus)
%         if(abs_de(row,col) > limit)
%             abs_de(row,col) = limit;
%         end
%     end
% end
% 
% % tri = delaunay(freqs(1:length(mus)),mus);
% % trisurf(tri,freqs(1:length(mus)),mus,abs_de(:,1:length(mus)))
% surf(freqs, mus, abs_de)
% title(filename)
% axis([freqs(1) freqs(end) mus(1) mus(end) 0 limit])
% caxis([0 limit])
% % 
% % analytical solution
% k0 = 2*pi_*freqs/c;
% zW1 = ones(length(mus), length(k0)).*eta0;
% %zW2 = ones(length(mu), length(k0)).*(eta0/2));
% zW2 = ones(length(mus), length(k0)).*(eta0/(2));
% 
% for row = 1:length(mus)
%     zW2(row,:) = zW2(row,:).*sqrt(mus(row));
% end
% 
% gamma1 = zeros(length(mus), length(k0));
% gamma2 = zeros(length(mus), length(k0));
% for row=1:length(mus)
%     gamma1(row,:) = j*k0.';
%     for col=1:length(k0)
%         gamma2(row,col) = j*k0(col)*2.*sqrt(mus(row));
%     end
% end
% 
% rho0 = (zW1-zW2)./(zW1+zW2).*ones(length(mus), length(k0));
% rhoLen = rho0.*exp(2*gamma2*len1);
% zLen = zW2.*(1+rhoLen)./(1-rhoLen);
% 
% rho0_1 = (zLen - zW1)./(zLen + zW1);
% rhoLen_1 = rho0_1.*exp(2*gamma1*len2);
% 
% figure;
% surf(freqs, mus, abs(rhoLen_1))
% title('analytical solution');
% 


