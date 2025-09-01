function h = plotResidualNorm(Model, Rom, fontSize)

nRoms = length(Rom);
nFreqs = length(Model.f);
romDim = zeros(1,nRoms);

totalConvergedRom = 0;
bandwidth = Model.f(end) - Model.f(1);
for iRom = 1:nRoms
    resL1 = 0;
    resL2 = 0;
    resInf = 0;
        
    romDim(iRom) = Rom{iRom}.dim;
    
    for k = 1:Model.nPorts
        for iFreq = 1:(nFreqs - 1)
            deltaF = Model.f(iFreq + 1) - Model.f(iFreq);
            
            resL1 = resL1 + Rom{iRom}.R(k).relative(iFreq) * deltaF;
            resL2 = resL2 + Rom{iRom}.R(k).relative(iFreq).^2 * deltaF;
            
            if max(Rom{iRom}.R(k).relative) > resInf
                resInf = max(Rom{iRom}.R(k).relative);
            end
        end
    end    
    
    Residual.L1(iRom) = resL1 / bandwidth / Model.nPorts;
    Residual.L2(iRom) = sqrt(resL2 / bandwidth / Model.nPorts);
    Residual.inf(iRom) = resInf;
    
    % determine first ROM which has only converged ritz values in band
    if isfield(Rom{iRom}, 'ErrorEst') && isstruct(Rom{iRom}.ErrorEst)
        nValidFreqs = length(Rom{iRom}.ErrorEst.f);
        if nValidFreqs == nFreqs && totalConvergedRom == 0
            totalConvergedRom = iRom;
        end
    end
    
end
          
figName = sprintf('Norm of Residuals');
h = figure('Position', [200, 200, 900, 600], 'Name', figName);


semilogy(romDim, Residual.L1, 'b',  'LineWidth', 3)
hold on;
semilogy(romDim, Residual.L2, 'r',  'LineWidth', 3)
hold on;
semilogy(romDim, Residual.inf, 'g', 'LineWidth', 3)
hold on;

axis tight;

% plot vertical line at first rom with only converged ritz values in band
yLim = get(gca, 'YLim');
if totalConvergedRom > 0
    line([romDim(totalConvergedRom), romDim(totalConvergedRom)], ...
        yLim, 'color', 'black');
end

xlabel('ROM Dimension', 'Interpreter', 'Latex', 'FontSize', fontSize);
ylabel('$E(r_1, \dots, r_{N_p}; \mathcal B_f)$ (Z Formulation)', ...
    'Interpreter', 'Latex', 'FontSize', fontSize);

legend({'$E_1$', '$E_2$', '$E_{\infty}$'}, 'Interpreter', 'Latex',...
    'Location', 'NorthEast');
set(gca, 'PlotBoxAspectRatio', [3,2,1]);
set(gca, 'FontSize', fontSize);

