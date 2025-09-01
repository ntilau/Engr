function h = plotScatErrorNorm(Rom, Error, fontSize, threshold)

linewidth = 2.5;
nRoms = length(Rom);
nErrors = length(Error);
if nRoms ~= nErrors
    error('Cell arrays Rom and Error must have same length');
end

romDim = zeros(1,nRoms);
errorNormL1 = zeros(1,nRoms);
errorNormL2 = zeros(1,nRoms);
errorNormInf = zeros(1,nRoms);

errorEstNormL1 = zeros(1,nRoms);
errorEstNormL2 = zeros(1,nRoms);
errorEstNormInf = zeros(1,nRoms);

isFullyConverged = false(1,nRoms);

for iRom = 1:nRoms    
    ErrorNorm = computeErrorNorms(Error(iRom).sMat);
    errorNormL1(iRom) = ErrorNorm.L1;
    errorNormL2(iRom) = ErrorNorm.L2;
    errorNormInf(iRom) = ErrorNorm.inf;
           
    romDim(iRom) = Rom{iRom}.dim;
        
    if isfield(Rom{iRom}, 'ErrorEst') && ~isempty(Rom{iRom}.ErrorEst) &&...
            all(Rom{iRom}.ErrorEst.iFreq)
        isFullyConverged(iRom) = true;
        ErrorEstNorm = computeErrorNorms(Rom{iRom}.ErrorEst.sParam);
        errorEstNormL1(iRom) = ErrorEstNorm.L1;
        errorEstNormL2(iRom) = ErrorEstNorm.L2;
        errorEstNormInf(iRom) = ErrorEstNorm.inf;
    end                               
end

figName = sprintf('Norm of Estimated Error in S-Parameters');
h = figure('Position', [200, 200, 900, 600], 'Name', figName);

semilogy(romDim, errorNormL1, 'b',  'LineWidth', linewidth)
hold on;
semilogy(romDim, errorNormL2, 'r',  'LineWidth', linewidth)
hold on;
semilogy(romDim, errorNormInf, 'g', 'LineWidth', linewidth)
hold on;

if any(isFullyConverged)
    semilogy(romDim(isFullyConverged), errorEstNormL1(isFullyConverged),...
        'b--x', 'LineWidth', linewidth)
    hold on;
    semilogy(romDim(isFullyConverged), errorEstNormL2(isFullyConverged),...
        'r--x', 'LineWidth', linewidth)
    hold on;
    semilogy(romDim(isFullyConverged), errorEstNormInf(isFullyConverged),...
        'g--x', 'LineWidth', linewidth)
    hold on;
end
  
xlabel('ROM Dimension', 'Interpreter', 'Latex', 'FontSize', fontSize);
ylabel('$E(\mathbf{\mathsf S}; \mathcal B_f)$ (Z Formulation)', ...
    'Interpreter', 'Latex', 'FontSize', fontSize);

axis tight;
set(gca, 'PlotBoxAspectRatio', [3,2,1]);

if nargin >= 4    
    % plot horizontal line at threshold value
    line(xlim, [threshold, threshold], 'color', 'black');
end

if any(isFullyConverged)
    iFirstFullyConverged = find(isFullyConverged, 1);
    yLim = get(gca, 'YLim');    
    line([romDim(iFirstFullyConverged), romDim(iFirstFullyConverged)], ...
        yLim, 'color', 'black');    
end

legend({'$E_1$', '$E_2$', '$E_{\infty}$'}, 'Interpreter', 'Latex',...
    'Location', 'SouthWest');
set(gca, 'FontSize', fontSize);

