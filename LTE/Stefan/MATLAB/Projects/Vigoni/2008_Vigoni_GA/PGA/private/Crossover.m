function p = Crossover( p )

N = p.population.Nind;
%%% Prepares couples for mating, random selection
for j = 1:N
    j1 = fix(rand*N)+1;
    j2 = fix(rand*N)+1;
    aux = p.population.specimens{p.population.Ngen+1}{j1};
    p.population.specimens{p.population.Ngen+1}{j1} = ...
        p.population.specimens{p.population.Ngen+1}{j2};
    p.population.specimens{p.population.Ngen+1}{j2} = aux;
end;
   
%%% Cross over vero e proprio
p.settings.NXOver(p.population.Ngen+1) = 0;

for j = 1 : fix(N/2);
    j1 = 2*j-1;
    j2 = 2*j;
    if(rand < p.settings.XOverProb)
        M = length(p.population.specimens{p.population.Ngen+1}{j1});
        k = fix(rand*M)+1;
        aux =  p.population.specimens{p.population.Ngen+1}{j1};
        p.population.specimens{p.population.Ngen+1}{j1}(k:M) = ...
            p.population.specimens{p.population.Ngen+1}{j2}(k:M);
        p.population.specimens{p.population.Ngen+1}{j2}(k:M) = ...
            aux(k:M);
        p.settings.NXOver(p.population.Ngen+1) = ...
            p.settings.NXOver(p.population.Ngen+1) + 1;
    end;
end;