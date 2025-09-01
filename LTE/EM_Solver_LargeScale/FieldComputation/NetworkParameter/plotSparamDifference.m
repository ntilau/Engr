% compare the difference (error) of S-Paramemeter of different methods. 
% Struct DUM must have fields string NAME, double array F and cell array S. 
% Therein S contains Parameters arranged in vectors

function h = plotSparamDifference(DumA, DumB)

  
lineWidth = 2.5;
fontSize = 18;
aspectRatio = [3, 2, 1];

h = figure('Name', 'Error in S-Parameters', 'Position', [250, 50, 800, 500]);

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
        legendStr{vecCnt} = sprintf('$S_{%d%d}$', m, n);
    end
end

hAxis = semilogy(freq, abs(deltaSVec), 'LineWidth', lineWidth);
ylim = get(gca, 'YLim');
set(gca, 'YLim', [ylim(1), 1]);

xlabel('Frequency (Hz)', 'Interpreter', 'Latex', 'FontSize', fontSize);
yStr = sprintf('$|S_{ij}^{(\\mathrm{org})} - S_{ij}^{(\\mathrm{rom})}|$');
ylabel(yStr, 'Interpreter', 'Latex', 'FontSize', fontSize);

set(gca, 'FontSize', fontSize, 'PlotBoxAspectRatio', aspectRatio);

if vecCnt <= 10
    legend(hAxis, legendStr, 'Interpreter', 'Latex',...
        'Location', 'South', 'FontSize', round(0.75 * fontSize));
end



