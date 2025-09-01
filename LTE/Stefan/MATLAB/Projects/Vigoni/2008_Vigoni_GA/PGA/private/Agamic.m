function p = Agamic( p )

i = p.population.Ngen;

if (p.cost.Ncost==1)
    % Single cost! Roulette wheel parent selection
    probabilities  = squeeze(p.population.cost(i,:,1))./...
        sum(squeeze(p.population.cost(i,:,1)));
else
    % PARETO front!
    probabilities  = squeeze(p.population.pareto(i,:))./...
        sum(squeeze(p.population.pareto(i,:)));
end

%%% AGAMIC REPRODUCTION
for j = 1:p.population.Nind
    pp = rand;
    k = 0;
    while( pp > 0 )
        k = k + 1;
        pp = pp - probabilities(k);
    end;
    p.population.specimens{p.population.Ngen+1}{j} = ...
        p.population.specimens{p.population.Ngen}{k};
end;