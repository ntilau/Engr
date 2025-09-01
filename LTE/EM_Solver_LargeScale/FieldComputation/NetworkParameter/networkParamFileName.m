% returns formatted filename 
function fname = networkParamFileName(path, freq, type, order)

if isempty(intersect({'A', 'ABCD', 'Y', 'Z', 'S', 'H'}, type))
    error('%s is no valid network parameter type', type);
end

if nargin < 4    
    % full model results   
    prefix = strcat(type, 'full');
    fname = sprintf('%s%s_f_%1.3g_%1.3g_pts%d.txt', ...
        path, prefix, freq(1), freq(end), length(freq));
else
    % ROM results    
    prefix = strcat(type, 'rom');
    fname = sprintf('%s%s_f_%1.3g_%1.3g_pts%d_p%d.txt', ...
        path, prefix, freq(1), freq(end), length(freq), order);
end



