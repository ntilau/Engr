% Read error indicator of adaptive mor iterations.
% Redirect standard output to file using '>>'-operator:
% [wd]> em_wavemodelreduction rect [...] >> output.txt
function [order, indicator] = parseWCAWE_errorIndicator(path, file)

fname = strcat(path, file);

% remove extension from string FILE
extpos = strfind(file, '.');
plotName = file(1:(extpos(end) - 1));

fid = fopen(fname, 'r');

indicator = [];
order = [];
while ~feof(fid)
    line = fgetl(fid);
    if ~strcmp(line(1:7), 'Enlarge')
        pos1 = strfind(line, 'order') + 5;
        pos2 = strfind(line, ':');

        order_str = strtrim(line((pos1 + 1):(pos2 - 1)));
        indicator_str = strtrim(line((pos2 + 1):end));

        order = [order, str2num(order_str)];
        indicator = [indicator, str2double(indicator_str)];
    end
end

fclose(fid);

figure;
set(gcf, 'Position', [200,200,600,300]); 
semilogy(order, indicator,  'LineWidth', 1.5);
ylabel('Error Indicator', 'FontSize', 10);
xlabel('Iteration', 'FontSize', 10);
savePlot(gcf, strcat(path, plotName), {'fig', 'jpeg', 'epsc'});
