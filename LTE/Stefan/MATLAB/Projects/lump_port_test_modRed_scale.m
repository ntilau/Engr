close all;
clear all;

tic

order = 6;

modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_3_\';
% buildRedModelTranspBC(modelName, order);
% buildRedModelTranspBC_ModScal(modelName, order);

% fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 's_11_f_50000000_150000000_201.txt'];

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);

% plot results
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)), 'g');
hold;


modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_12\';
% buildRedModelIdent_ModScal(modelName, 12);
fNameSpara = modelEvaluationIdent(modelName);
fNameSpara = [modelName 's_11_f_50000000_150000000_201.txt'];

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);

% plot results
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)), 'b');

modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_12_C++\';
% buildRedModelIdent_ModScal(modelName, 12);
fNameSpara = modelEvaluationIdent(modelName);
fNameSpara = [modelName 'S_f_5e+007_1.5e+008_201.txt'];

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);

% plot results
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)), 'c');



fNameWsolver = ...
  'C:\work\examples\lump_port_test\lump_port_test_wSolver\sParamReference.txt';

[fr sMatWaveSolv] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatWaveSolv(1,1,:), [length(fr) 1]);
%semilogy(fr*1e-9, abs(s11vector),'dr');
plot(fr*1e-9, 20*log10(abs(s11vector)), 'dr');
%plot(fr*1e-9, (abs(s11vector)), 'dr');




figure;
fNameWsolver = ...
  'C:\work\examples\lump_port_test\lump_port_test_wSolver\sParamABC.txt';

[fr sMatWaveSolv] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatWaveSolv(1,1,:), [length(fr) 1]);
%semilogy(fr*1e-9, abs(s11vector),'dr');
plot(fr*1e-9, 20*log10(abs(s11vector)), 'ob');
%plot(fr*1e-9, (abs(s11vector)), 'dr');


pos = zeros(1,length(s11vector));
for k = 1:length(s11vector)
  pos(k) = find(parameterVals(1,:) == fr(k));
end
semilogy(fr*1e-9, abs(s11vector.' - sVal(pos)));
grid;

toc

figure;
modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_10\';
order = 10;
% buildRedModelIdent_ModScal(modelName, order);
fNameSpara = modelEvaluationIdent(modelName);
% fNameSpara = [modelName 's_11_f_8000000000_17000000000_201_MU_RELATIVE_sample_5_5_1.txt'];
[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);

% plot results
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)));



figure;
modelName = ...
'C:\work\examples\lump_port_test\ABC_test_modRed\wg3_1e+008_12\';
% buildRedModelTranspBC_ModScal(modelName, order);
% fNameSpara = modelEvaluationGeneral(modelName);
fNameSpara = [modelName 's_11_f_50000000_150000000_201.txt'];

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);

% plot results
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)), 'y');
hold;

modelName = ...
'C:\work\examples\lump_port_test\ABC_test_modRed\wg3_1e+008_12_ident\';
%buildRedModelIdent_ModScal(modelName, order);
%fNameSpara = modelEvaluationIdent(modelName);
fNameSpara = [modelName 's_11_f_50000000_150000000_201.txt'];

[parameterNames, numParameterPnts, parameterVals, sMatrices] ...
    = loadSmatrix(fNameSpara);

% plot results
sVal = zeros(numParameterPnts(1),1);
freqs = zeros(numParameterPnts(1),1);
for k = 1:numParameterPnts(1)
  freqs(k) = parameterVals(1,k);
  sVal(k) = sMatrices{k}(1, 1);
end
plot(freqs*1e-9, 20*log10(abs(sVal)), 'b');

