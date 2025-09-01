function p = init( p )
%INIT prepares for the simulation!

%Zeroes history

p.population.Ngen = 0;
p.population.specimens={};
p.population.cost=[];
p.population.rank=[];
p.population.pareto=[];

chlen = p.phenotype.Nbits;

for i=1:p.population.Nind
    p.population.specimens{1}{i} = randomchromo(chlen);
end

p.population.Ngen = 1;
