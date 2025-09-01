% compare the difference (error) of Impedance of different methods. 
% Struct DUM must have fields string NAME, double array F and cell array Z. 
% Therein Z contains Parameters arranged in vectors

function h = plotImpDifference(DumA, DumB)

  
lineWidth = 2.5;
fontSize = 16;
aspectRatio = [3, 2, 1];

h = figure('Position', [250, 50, 800, 500]);

[freq, iFreqA, iFreqB] = intersect(DumA.f, DumB.f);

if isempty(freq)
    error('Parameters have no frequencies in common');
end

sMatRawA = sortNetworkParamsByMatrices(DumA.S);
sMatRawB = sortNetworkParamsByMatrices(DumB.S);

sMatA = sMatRawA(iFreqA);
sMatB = sMatRawB(iFreqB);

[sMatA, sMatB] = sParamPhaseCorrection(sMatA, sMatB);

nPorts = size(sMatA{1});

for k = 1:length(sMatA)
    deltaSMat{k} = sMatA{k} - sMatB{k};
end

deltaS = sortNetworkParamsByPorts(deltaSMat);

vecCnt = 0;
for m = 1:nPorts
    for n = 1:m
        vecCnt = vecCnt + 1;
        deltaSVec(:, vecCnt) = deltaS{m,n};
    end
end

semilogy(freq, abs(deltaSVec), 'LineWidth', lineWidth);

set(gca, 'YLim', [1e-12, 1]);

xlabel('Frequency (Hz)', 'Interpreter', 'Latex', 'FontSize', fontSize);
yStr = sprintf('$|S_{ij}^{(org)} - S_{ij}^{(rom)}|$');
ylabel(yStr, 'Interpreter', 'Latex', 'FontSize', fontSize);
set(gca, 'FontSize', fontSize, 'PlotBoxAspectRatio', aspectRatio);
