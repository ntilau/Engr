%% GENERAL SETTINGS
p = PGA();
p = set(p,'Cost',{@(x) x*x',@(x) (x-2)*(x-2)'});
%p = set(p,'Phenotype',{[-5,5,8]});
p = set(p,'Phenotype',{[-5,5,8],[-5,5,8]});
p = set(p,'Population',10);
p = set(p,'CrossoverProb',0.5);
p = set(p,'MutationProb',0.01);

%% INITIALIZE ALGORITHM
p = initialize(p);
p = evolve(p,20);


