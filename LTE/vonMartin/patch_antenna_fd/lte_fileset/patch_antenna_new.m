close all;
clear all;
clc;

nPort			= 1;

% Read LTE-MOR-Sweep-Data
filename = '.\3d_3e+009_100\S_f_2.8e+009_3.2e+009_1001.txt';
[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(filename);
f_sweep = parameterVals';
S_WMR = zeros(length(parameterVals), nPort^2);
for iFreq = 1 : length(parameterVals)
	for jPort = 1 : nPort
		for kPort = 1 : nPort
			S_WMR(iFreq, (jPort - 1) * nPort + kPort) = sMatrices{iFreq}(jPort, kPort);
		end
	end
end
absS_WMR				= abs(S_WMR);
dB10S_WMR				= 10 * log10(absS_WMR);
dB20S_WMR				= 20 * log10(absS_WMR);
argS_WMR				= angle(S_WMR);
S_WMR					  = absS_WMR .* exp(1i * argS_WMR);

% Read LTE-Discrete-Sweep-Data
dum = lte_ws2DUM('', 'sParam.txt', 0);

f_discrete = dum.f;
S_discrete = zeros(length(f_discrete), nPort^2);
for iFreq = 1 : length(f_discrete)
	for jPort = 1 : nPort
		for kPort = 1 : nPort
			S_discrete(iFreq, (jPort - 1) * nPort + kPort) = dum.S{jPort, kPort}(iFreq);
		end
	end
end
absS_discrete  	     = abs(S_discrete);
dB10S_discrete  	   = 10 * log10(absS_discrete);
dB20S_discrete  	   = 20 * log10(absS_discrete);
argS_discrete				 = angle(S_discrete);
S_discrete				   = absS_discrete .* exp(1i * argS_discrete);

SdN = S_discrete ./ abs(S_discrete);
SsN = S_WMR(1:10:end,:) ./ abs(S_WMR(1:10:end,:));
idx = abs(SdN-SsN)>1;
S_discrete(idx) = S_discrete(idx)*exp(1i*pi);
clear SdN SsN idx;

% Read CST-Data
path			= '..\patch antenna fd\Result\';
data			= dlmread([path 'a1(1)1(1).sig'], ' ', 4, 0);
f_scaling = dlmread([path 'a1(1)1(1).sig'], ' ', [3 1 3 1]);
f_CST			= data(:, 1) * f_scaling;
S_CST			= zeros(length(f_CST), nPort^2);
clear data;
for iPort = 1 : nPort
	for jPort = 1 : nPort
		filenamea = ['a' num2str(iPort) '(1)' num2str(jPort) '(1).sig'];
		filenamep = ['p' num2str(iPort) '(1)' num2str(jPort) '(1).sig'];
		S_CST(:, (iPort - 1) * nPort + jPort) = dlmread([path filenamea], ' ', 4, 1) .* exp(1i * dlmread([path filenamep], ' ', 4, 1) / 180 * pi);
	end
end
absS_CST	= abs(S_CST);
dB10S_CST = 10 * log10(absS_CST);
dB20S_CST = 20 * log10(absS_CST);
argS_CST	= unwrap(angle(S_CST));
		
%%
projectFIG = '..\..\Presentation\Figures\patchAntenna';
projectJPG = '..\..\Presentation\JPGs\patchAntenna';

figure(1);
close(1);
figure(1);
plot(f_sweep, dB20S_WMR);
hold on;
plot(f_discrete, dB20S_discrete,'.');
xlabel('f (Hz)');
hold on;
legendString = cell(1,nPort^2);
for iPort = 1 : nPort
	for jPort = 1 : nPort
		legendString{(iPort - 1) * nPort + jPort} = ['|S_{' num2str(iPort) num2str(jPort) '}| (dB)'];
	end
end
l = legend(legendString);
set(l, 'Location', 'Southeast');
axis([min(f_sweep) max(f_sweep) -20 0]);
maximize(1);

figure(2);
close(2);
figure(2);
plot(f_CST,dB20S_CST);
xlabel('f (Hz)');
l = legend(legendString);
set(l, 'Location', 'Southeast');
axis([min(f_sweep) max(f_sweep) -20 0]);
maximize(2);

absDeltaS = abs(S_CST - S_WMR);
figure(3);
close(3);
figure(3);
semilogy(f_sweep, absDeltaS);
xlabel('f (Hz)');
axis([min(f_sweep) max(f_sweep) 1e-9 1]);
for iPort = 1 : nPort
	for jPort = 1 : nPort
		legendString{(iPort - 1) * nPort + jPort} = ['|\Delta S_{' num2str(iPort) num2str(jPort) '}|'];
	end
end
l = legend(legendString);
set(l, 'Location', 'Southeast');
maximize(3);

figure(4);
close(4);
figure(4);
plot(f_sweep,sum(abs(S_CST(:,1:nPort)).^2,2),'b',...
		 f_sweep,sum(abs(S_WMR(:,1:nPort)).^2,2),'r');
xlabel('f (Hz)');
legend('CST-Sweep', 'LTE-Sweep');
set(l, 'Location', 'Southeast');
maximize(4);

figure(5);
close(5);
figure(5);
semilogy(f_discrete,abs(S_WMR(1:10:end,:)-S_discrete));
xlabel('f (Hz)');
axis([min(f_sweep) max(f_sweep) 1e-10 1]);
for iPort = 1 : nPort
	for jPort = 1 : nPort
		legendString{(iPort - 1) * nPort + jPort} = ['|errS_{' num2str(iPort) num2str(jPort) '}|'];
	end
end
l = legend(legendString);
set(l, 'Location', 'Southeast');
maximize(5);

saveas(1, [projectFIG '_sParamsLTE.fig']);
saveas(1, [projectJPG '_sParamsLTE.jpg']);
saveas(2, [projectFIG '_sParamsCST.fig']);
saveas(2, [projectJPG '_sParamsCST.jpg']);
saveas(3, [projectFIG '_fastSweepCST_fastSweepLTE.fig']);
saveas(3, [projectJPG '_fastSweepCST_fastSweepLTE.jpg']);
saveas(4, [projectFIG '_energyBalance.fig']);
saveas(4, [projectJPG '_energyBalance.jpg']);
saveas(5, [projectFIG '_discreteSweepLTE_fastSweepLTE.fig']);
saveas(5, [projectJPG '_discreteSweepLTE_fastSweepLTE.jpg']);