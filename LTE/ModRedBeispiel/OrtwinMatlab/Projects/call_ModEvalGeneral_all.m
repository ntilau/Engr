% This script performs the model evaluation

close all;
clear all;

tic

modelName = 'C:\work\examples\coaxParam\coaxParam_1e+008_MU_RELATIVE_3_(1,0)_10\';
modelName = 'C:\work\examples\coax2\coax2_1e+009_MU_RELATIVE_74_(1,0)_2\';
modelName = 'C:\work\examples\coax2\coax2_1e+009_EPSILON_RELATIVE_74_(4,0)_2\';
modelName = 'C:\work\examples\coaxParam\coaxParam_1e+008_EPSILON_RELATIVE_3_(4,0)_2\';
modelName = 'C:\work\examples\patch_antenna_p1\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_2\';
modelName = 'C:\work\examples\patch_antenna\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(3,0)_3\';
modelName = 'C:\work\examples\patch_antenna\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(2,0)_2\';
modelName = 'C:\work\examples\coax2\coax2_2e+009_EPSILON_RELATIVE_74_(4,0)_4\';
modelName = 'C:\work\examples\lump_port_test\wg3_1e+008_EPSILON_RELATIVE_3_(4,0)_3\';
modelName = 'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_3\';
modelName = 'C:\work\examples\bga_ifx_1_4p_lossy\bga_ifx_1_4p_lossy_5e+009_5\';

fNameSpara = modelEvaluationGeneral(modelName);

[parameterNames, numParameterPnts, parameterVals, sMatrices] = loadSmatrix(fNameSpara);
% plot results
figHandle = figure;
sRow = 1;
sCol = 1;
nonOne = length(find(numParameterPnts ~= 1));
if length(parameterNames) == 1 | nonOne == 1
  for k = 1:numParameterPnts(1)
    freqs(k) = parameterVals(1,k);
    sVal(k) = sMatrices{k}(sRow, sCol);
  end
  %plot(freqs*1e-9, abs_s);
  plot(freqs*1e-9, 20*log10(abs(sVal)));
  %semilogy(freqs*1e-9, abs_s);
elseif length(parameterNames) == 2
  pos = 1;
  for fCnt = 1:numParameterPnts(1)
    for pCnt = 1:numParameterPnts(2)
      freqs(fCnt) = parameterVals(1,pos);
      matVals(pCnt) = parameterVals(2,pos);
      sVal(pCnt, fCnt) = sMatrices{pos}(sRow, sCol);
      pos = pos + 1;
    end
  end
  surf(freqs*1e-9, matVals, abs(sVal));
elseif length(parameterNames) == 3
  pos = 1;
  nonOnePos = find(numParameterPnts(2:end) ~= 1) + 1;
  for fCnt = 1:numParameterPnts(1)
    for pCnt = 1:numParameterPnts(nonOnePos)
      freqs(fCnt) = parameterVals(1,pos);
      matVals(pCnt) = parameterVals(2,pos);
      sVal(pCnt, fCnt) = sMatrices{pos}(sRow, sCol);
      pos = pos + 1;
    end
  end
  surf(freqs*1e-9, matVals, abs(sVal));
else
  error('Not yet implemented');
end
hold;
grid;

fNameWsolver = 'C:\work\examples\patch_antenna_wSolver\sParam_e1_5_e2_3.txt';
fNameWsolver = 'C:\work\examples\bga_ifx_1_4p_lossy_pec_wSolver\sParam_lossless.txt';
fNameWsolver = 'C:\work\examples\bga_ifx_1_4p_lossy_pec_wSolver\sParam_llMat.txt';
fNameWsolver = 'C:\work\examples\bga_ifx_1_4p_lossy_pec_wSolver\sParam_4e9_5e9_lossy_local.txt';
fNameWsolver = 'C:\work\examples\lump_port_test\lump_port_test_wSolver\sParam.txt';

[fr sMatWaveSolv] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatWaveSolv(1,1,:), [length(fr) 1]);
%semilogy(fr*1e-9, abs(s11vector),'dr');
plot(fr*1e-9, 20*log10(abs(s11vector)), 'dr');
%plot(fr*1e-9, (abs(s11vector)), 'dr');

figure;
pos = zeros(1,length(s11vector));
for k = 1:length(s11vector)
  pos(k) = find(freqs == fr(k));
end
semilogy(fr*1e-9, abs(s11vector.' - sVal(pos)));
grid;

% fNameWsolver = 'C:\work\examples\patch_antenna_wSolver\sParam_e1_5_e2_3.txt';
% [fr sMatrices] = readSparamWaveSolver(fNameWsolver);
% s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
% %semilogy(fr*1e-9, abs(s11vector),'dr');
% plot(fr*1e-9, abs(s11vector),'dr');

figure;

[r c] = size(sMat{1});
Z0 = 50 * eye(r);
Z_Omega = 50 * eye(r);
Y_Omega = 1/50 * eye(r);
for k = 1:length(sMat)
  sMatRenorm{k} = renormScatMat(sMat{k}, Z0, Z_Omega, Y_Omega);
end

for k = 1:length(sMatRenorm)
  sValRenorm(k) = sMatRenorm{k}(sRow, sCol);
end
%plot(freqs*1e-9, abs_s);
plot(freqs*1e-9, 20*log10(abs(sValRenorm)));
grid;