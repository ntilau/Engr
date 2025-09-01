function p = Mutation( p )

N = p.population.Nind;
M = length(p.population.specimens{p.population.Ngen+1}{1});

p.settings.NMut(p.population.Ngen+1) = 0;

for j = 1:N
    for k = 1:M
        if(rand < p.settings.MutProb)
            if (p.population.specimens{p.population.Ngen+1}{j}(k) == '1')
               p.population.specimens{p.population.Ngen+1}{j}(k) = '0';
            else
               p.population.specimens{p.population.Ngen+1}{j}(k) = '1';
            end;
            p.settings.NMut(p.population.Ngen+1) = ...
                p.settings.NMut(p.population.Ngen+1) + 1;
        end;
    end;
end;
   
