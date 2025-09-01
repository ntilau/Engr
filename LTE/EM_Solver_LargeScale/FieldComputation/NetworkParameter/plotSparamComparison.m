% compare S-Paramemeter of different methods. Struct DUM must have fields
% string NAME, double array F and cell array S. 
% Therein S contains Parameters arranged in vectors

function h = plotSparamComparison(Dum, m, n)

if nargin == 1
    % plot reflection coefficient
    m = 1;
    n = 1;
end
    
color = 'brgkcmy';
lineWidth = 2.5;
fontSize = 16;
aspectRatio = [4, 2, 1];

h = figure('Position', [250, 50, 800, 800]);
hMag = subplot(2,1,1);
hPhase = subplot(2,1,2);

nDums = length(Dum);
legendStr = cell(nDums, 1);
for iDum = 1:nDums       
    freq = Dum(iDum).f;
    S = Dum(iDum).S{m,n};
    legendStr{iDum} = Dum(iDum).Name;
    
    subplot(hMag);
    plot(freq, db(S), color(iDum), 'LineWidth', lineWidth);
    hold on;
    
    subplot(hPhase);
    plot(freq, 180 / pi * angle(S), color(iDum), 'LineWidth', lineWidth);
    hold on;         
end

subplot(hMag);
xlabel('Frequency (Hz)', 'Interpreter', 'Latex', 'FontSize', fontSize);
yStr = sprintf('$|S_{%d%d}|$ (dB)', m, n);
ylabel(yStr, 'Interpreter', 'Latex', 'FontSize', fontSize);
axis tight;
set(gca, 'FontSize', fontSize, 'PlotBoxAspectRatio', aspectRatio);
legend(legendStr, 'Interpreter', 'Latex', ...
    'FontSize', round(0.75 * fontSize), 'Location', 'Best');

subplot(hPhase);
xlabel('Frequency (Hz)', 'Interpreter', 'Latex', 'FontSize', fontSize);
yStr = sprintf('$\\mathrm{phase}(S_{%d%d})$ (deg)', m, n);
ylabel(yStr, 'Interpreter', 'Latex', 'FontSize', fontSize);
axis tight;
ylim([-180, 180]);
set(gca, 'YTick', -180:90:180, ...
    'FontSize', fontSize, 'PlotBoxAspectRatio', aspectRatio);
