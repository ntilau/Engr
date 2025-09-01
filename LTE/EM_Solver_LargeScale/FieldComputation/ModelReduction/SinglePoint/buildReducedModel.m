function Rom = buildReducedModel(Model, SysMat, Q, X0, rhs, lhs)


for k = 1:length(SysMat)
    Rom.SysMat(k).name = SysMat(k).name;
    Rom.SysMat(k).paramList = SysMat(k).paramList;
    Rom.SysMat(k).val = Q.' * SysMat(k).val * Q;
%     Rom.SysMat(k).val = 0.5 * (Rom.SysMat(k).val' + Rom.SysMat(k).val);
end

Rom.lhs = Q.' * lhs;
% computation of Krylov space is done in real arithmetic
Rom.rhs = Q.' * rhs;
Rom.X0 = Q.' * X0;

Rom.dim = size(Q, 2);
Rom.order = Rom.dim / size(rhs, 2);
if Rom.order == 1
    % compute projections onto Krylov subspace    
    fprintf(1, '\n');
    warning(['Reduced matrices are beeing computed ', ...
        'completely in every iteration']); %#ok<WNTAG>
end

Rom.sparamFilename = ...
    generateNetworkparamFilename('S', Model, Rom.order);
Rom.zparamFilename = ...
    generateNetworkparamFilename('Z', Model, Rom.order);



    