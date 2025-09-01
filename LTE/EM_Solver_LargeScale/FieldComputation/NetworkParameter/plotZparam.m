function h = plotSparam(varargin)

h = figure;
for k = 1:length(varargin)
    S_mat = getFreqOrderedNetworkMatrix(varargin{k}.S);
    Z_mat = s2z(S_mat);
    Z = getDUMformattedNetworkMatrix(Z_mat);   
    
    freqFactor = to_hz(varargin{k}.FrequencyUnits);
    f = freqFactor * varargin{k}.f;
    
    lineType = generateLineSpec(k);
    plotHandle(k) = semilogx(f, imag(Z{1,1}), lineType);   
    legendtxt{k} = addslashes(varargin{k}.Name);
    hold on;
end

title('Imaginary Part of Impedance');
legend(plotHandle, legendtxt, 'Location', 'Best');

return;
