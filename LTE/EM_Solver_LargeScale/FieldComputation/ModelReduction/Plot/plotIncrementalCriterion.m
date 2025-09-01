function h = plotIncrementalCriterion(Model, Rom, fontSize)

nRoms = length(Rom);
nFreqs = length(Model.f);
romDim = zeros(1,nRoms);

totalConvergedRom = 0;
romDim(1) = Rom{1}.dim;

for iRom = 2:nRoms
    % compute delta-S and -Z
    Delta = incrementalStoppingCriterion(Rom{iRom-1}.sMat, Rom{iRom}.sMat);
    
    DeltaScat.L1(iRom) = Delta.L1;
    DeltaScat.L2(iRom) = Delta.L2;
    DeltaScat.inf(iRom) = Delta.inf;          
        
    Delta = incrementalStoppingCriterion(Rom{iRom-1}.zMat, Rom{iRom}.zMat);
    
    DeltaImp.L1(iRom) = Delta.L1;
    DeltaImp.L2(iRom) = Delta.L2;
    DeltaImp.inf(iRom) = Delta.inf;          
           
    romDim(iRom) = Rom{iRom}.dim;   
    
    % determine first ROM which has only converged ritz values in band
    if isfield(Rom{iRom}, 'ErrorEst') && isstruct(Rom{iRom}.ErrorEst)
        nValidFreqs = length(Rom{iRom}.ErrorEst.f);
        if nValidFreqs == nFreqs && totalConvergedRom == 0
            totalConvergedRom = iRom;
        end
    end      
end
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot Delta-S-Criterion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figName = sprintf('Incremental Stopping Criterion (S)');
h(1) = figure('Position', [200, 200, 900, 600], 'Name', figName);

semilogy(romDim(2:end), DeltaScat.L1(2:end), 'b',  'LineWidth', 3)
hold on;
semilogy(romDim(2:end), DeltaScat.L2(2:end), 'r',  'LineWidth', 3)
hold on;
semilogy(romDim(2:end), DeltaScat.inf(2:end), 'g', 'LineWidth', 3)
hold on;

axis tight;
set(gca, 'PlotBoxAspectRatio', [3,2,1]);
% let x start at first rom
xlim([romDim(1), romDim(end)]);

% plot horizontal line at threshold value
line(xlim, ...
    [Model.ErrorCriterion.threshold, Model.ErrorCriterion.threshold], ...
    'color', 'black');

% line(xlim, [0.01, 0.01], 'color', 'black', 'LineStyle', '--');

% plot vertical line when all ritz values in band are converged
yLim = get(gca, 'YLim');
if totalConvergedRom > 0
    line([romDim(totalConvergedRom), romDim(totalConvergedRom)], ...
        yLim, 'color', 'black');
end

xlabel('ROM Dimension', 'Interpreter', 'Latex', 'FontSize', fontSize);
ylabel(['$E(\Delta \mathbf{\mathsf S}_q; \mathcal B_f)$ ',...
    '(Z Formulation)'], 'Interpreter', 'Latex', 'FontSize', fontSize);

legend({'$E_1$', '$E_2$', '$E_{\infty}$'}, 'Interpreter', 'Latex',...
    'Location', 'SouthWest');

set(gca, 'FontSize', fontSize);
yTick = get(gca, 'YTick');
yTick = sort(unique([yTick, Model.ErrorCriterion.threshold, 0.01]));
set(gca, 'YTick', yTick);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot Delta-Z-Criterion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figName = sprintf('Incremental Stopping Criterion (Z)');
h(2) = figure('Position', [200, 200, 900, 600], 'Name', figName);

semilogy(romDim(2:end), DeltaImp.L1(2:end), 'b',  'LineWidth', 3)
hold on;
semilogy(romDim(2:end), DeltaImp.L2(2:end), 'r',  'LineWidth', 3)
hold on;
semilogy(romDim(2:end), DeltaImp.inf(2:end), 'g', 'LineWidth', 3)
hold on;

axis tight;
set(gca, 'PlotBoxAspectRatio', [3,2,1]);
% let x start at first rom
xlim([romDim(1), romDim(end)]);

% plot vertical line when all ritz values in band are converged
yLim = get(gca, 'YLim');
if totalConvergedRom > 0
    line([romDim(totalConvergedRom), romDim(totalConvergedRom)], ...
        yLim, 'color', 'black');
end

xlabel('ROM Dimension', 'Interpreter', 'Latex', 'FontSize', fontSize);
ylabel(['$E(\Delta \mathbf{\mathsf Z}_q; \mathcal B_f)$ ',...
    '(Z Formulation)'], 'Interpreter', 'Latex', 'FontSize', fontSize);

legend({'$E_1$', '$E_2$', '$E_{\infty}$'}, 'Interpreter', 'Latex',...
    'Location', 'SouthWest');
set(gca, 'FontSize', fontSize);
