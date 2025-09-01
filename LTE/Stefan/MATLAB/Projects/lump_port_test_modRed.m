close all;
clear all;

tic

order = 15;

modelName = ...
  'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_3\';

buildRedModelTranspBC_ModScal(modelName, order);

fNameSpara = modelEvaluationGeneral(modelName);

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);

% plot results
figHandle = figure;
sVal = plotScatParams(parameterNames, numParameterPnts, ...
  parameterVals, sMatrices);

fNameWsolver = ...
  'C:\work\examples\lump_port_test\lump_port_test_wSolver\sParam.txt';

[fr sMatWaveSolv] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatWaveSolv(1,1,:), [length(fr) 1]);
%semilogy(fr*1e-9, abs(s11vector),'dr');
plot(fr*1e-9, 20*log10(abs(s11vector)), 'dr');
%plot(fr*1e-9, (abs(s11vector)), 'dr');

figure;
pos = zeros(1,length(s11vector));
for k = 1:length(s11vector)
  pos(k) = find(parameterVals(1,:) == fr(k));
end
semilogy(fr*1e-9, abs(s11vector.' - sVal(pos)));
grid;

toc
