% returns formatted filename 
function fname = generateNetworkparamFilename(prefix, Model, order)

if nargin == 2 || order == -1
    % full model results    
    fname = sprintf('%s%s_f_%1.3g_%1.3g_pts%d.txt', ...
        Model.resultPath, prefix, Model.f(1), Model.f(end), Model.nFreqs);
else
    % ROM results    
    fname = sprintf('%s%s_f_%1.3g_%1.3g_pts%d_p%d.txt', ...
        Model.resultPath, prefix, Model.f(1), ...
        Model.f(end), Model.nFreqs, order);
end



