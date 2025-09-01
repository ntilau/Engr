function h = plotSparam(varargin)

h = figure;
for k = 1:length(varargin)
    S = db(abs(varargin{k}.S{1,1}));
    freqFactor = scale2Hz(varargin{k}.FrequencyUnits);
    f = freqFactor * varargin{k}.f;
    lineType = getLineSpecification(k);
    plotHandle(k) = semilogy(f, S, lineType);   
    legendtxt{k} = strcat('S_{11} ', addslashes(varargin{k}.Name));
    hold on;
end

title('Magnitude of Scattering Parameter in dB');
legend(plotHandle, legendtxt, 'Location', 'Best');

return;
