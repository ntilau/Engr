close all;
clear all;

addpath Matlab_Multipoint
format long;

addpath(genpath('V:\Ortwin\ModRedBeispiel\OrtwinMatlab'));

modelName = 'V:\Ortwin\ModRedBeispiel\langer_dual_coarse\langer_dual_coarse_6e+009_7\';

%%
% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);


ws_path='V:\Ortwin\ModRedBeispiel\langer_dual_coarse';

% delete([ ws_path '\sParam.txt']);

f0 = linspace(freqParam.fMin, freqParam.fMax, freqParam.numPnts)
% f0 = linspace(11e9, 15e9, 81);

for k = 1:length(f0)
%    system(['cd ' ws_path ' & EM_WaveSolver langer_dual_coarse ' num2str(f0(k)) ' -dx -sol +direct +spara ' ] );
end


% fNameSpara = strcat(modelName, 'sSolver_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
%   num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));
% fNameSpara = strcat(fNameSpara, '.txt');
% copyfile([ws_path '\sParam.txt'], fNameSpara)
% fNameWsolver = fNameSpara;


%Load Wavesolver Data
% [fr sMatWaveSolv] = readSparamWaveSC2Mode(fNameWsolver);
[fr sMatWaveSolv] = readSparamWaveSolverModyfied([ ws_path '\sParam.txt']);
s11 = zeros(length(fr),1);
for k = 1:length(fr)
  s11(k) = sMatWaveSolv{k}(1,2);
  s12(k) = sMatWaveSolv{k}(1,1);
end


% s11Cpp = vectorReader('C:\daten\2008_cpp\langer_dual_coarse\s11.test');  
% s12Cpp = vectorReader('C:\daten\2008_cpp\langer_dual_coarse\s12.test');  





fNameSpara = strcat(modelName, 'S_', num2str(freqParam.fMin), '_', ...
  num2str(freqParam.fMax), '_', num2str(freqParam.numPnts), '.txt' );

fNameSpara = [ modelName 'S_f_4e+009_1e+010_101.txt'];

[parameterNamesMulti, numParameterPntsMulti, parameterValsMulti, sMatricesMulti] ...
  = loadSmatrix(fNameSpara);
sValOrig = zeros(numParameterPntsMulti(1),1);
freqsMulti = zeros(numParameterPntsMulti(1),1);
for k = 1:numParameterPntsMulti(1)
  fO(k) = parameterValsMulti(1,k);
  s11Cpp(k) = sMatricesMulti{k}(1, 1);
  s12Cpp(k) = sMatricesMulti{k}(1, 2);

end











% plot results
figHandle=figure(1);
set(figHandle,'color','w');
subplot(3,1,1);
plot(fr*1e-6, 20*log(abs(s12)), 'black');
ylabel('| s_{12} |_{dB}');
xlabel('Frequenz in MHz');
grid on;


subplot(3,1,2);
plot(fr*1e-6, angle(s12), 'black');
ylabel('Phase s_{12}');
xlabel('Frequenz in MHz');
grid on;


subplot(3,1,3);
semilogy(fr*1e-6, abs(s11Cpp.' - s11), 'black');
hold on
semilogy(fr*1e-6, abs(s12Cpp.' - s12.'), 'red');
hold off;
ylabel('Error');
xlabel('Frequenz in MHz');
grid on;



%%
% A1 = readMatFull('V:\Ortwin\ModRedBeispiel\langer_dual_coarse\langer_dual_coarse_6e+009_7_quad\sysMatRed_0');
% A2 = readMatFull('V:\Ortwin\ModRedBeispiel\langer_dual_coarse\langer_dual_coarse_6e+009_7\sysMatRed_0');


