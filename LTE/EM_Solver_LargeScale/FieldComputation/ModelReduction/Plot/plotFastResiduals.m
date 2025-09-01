% plot residual
function h = plotFastResiduals(Model, Rom, fontSize)

if nargin < 3
    fontSize = 16;
end

h = figure('position', [200, 200, 900, 600]);
set(gcf, 'Name', 'Relative Residual ');
nRoms = length(Rom);
strLegend = cell(nRoms, 1);
axes_h = zeros(nRoms, 1);
for iRom = 1:nRoms
    dim =Rom{iRom}.dim;
    lineStyle = getLineSpecification(iRom);
    
    % fast residuals
    axes_h(iRom) = semilogy(Model.f, ...
        Rom{iRom}.R(1).relative, lineStyle, 'LineWidth', 3);
    hold on;
    strLegend{iRom} = sprintf('dim = %d', dim);
end
gcf;
xlabel('Frequency (Hz)', 'Interpreter', 'Latex', 'FontSize', fontSize);
ylabel('$r_1(f)$ (Z Formulation)',...
    'Interpreter', 'Latex', 'FontSize', fontSize);

% legend(strLegend)
legendFs = round(0.75 * fontSize);
legend(axes_h, strLegend, 'Interpreter', 'Latex', ...
    'Location', 'SouthEast', 'FontSize', legendFs);

axis tight;
set(gca, 'PlotBoxAspectRatio', [3,2,1]);
set(gca, 'FontSize', fontSize);

