function h = plotSectionError(Model, maxSectionError, fontSize)

if nargin < 3
    fontSize = 18;
end

h = figure('Name', 'Section Error', 'Position', [200, 100, 900, 600]);
set(gca, 'FontSize', fontSize);
semilogy(2:(Model.iRomConverged-1), maxSectionError(2:end), ...
    'greens', 'LineWidth', 2);

switch Model.ErrorCriterion.type
    case 'L2'
        strNormType = '2';
    case 'L1'
        strNormType = '1';
    case 'inf'
        strNormType = '\infty';
    otherwise
        warning('Unknown type of chosen Norm'); %#ok<WNTAG>
        strNormType = normType;
end

strYlabel = sprintf(...
    'Section error $E_{%s}(\\Delta \\mathbf S, \\mathcal B)$', strNormType);
ylabel(strYlabel, 'Interpreter', 'latex');
xlabel('Reduced model order', 'Interpreter', 'latex');
grid on;
set(gca, 'PlotBoxAspectRatio', [3,2,1]);
