function p = evaluatecosts( p )
%Evaluate the costs for the CURRENT generation

igen = p.population.Ngen;
for ispec=1:p.population.Nind
    v = decodespecimen(p,igen,ispec);
    for icos = 1:p.cost.Ncost
        p.population.cost(igen,ispec,icos) = p.cost.pointer{icos}(v);
    end
end



