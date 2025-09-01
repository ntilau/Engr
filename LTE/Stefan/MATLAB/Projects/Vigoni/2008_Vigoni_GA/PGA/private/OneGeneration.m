function p = OneGeneration( p )

%%% EVALUATES GENERATION
p = evaluatecosts(p);

%%% RANKS
p = rank(p);

%%% NEW GENERATION - AGAMIC
p = Agamic(p);

%%% NEW GENERATION - CROSSOVER
p = Crossover(p)

%%% NEW GENERATION - MUTATION
p = Mutation(p);

p.population.Ngen = p.population.Ngen + 1;
