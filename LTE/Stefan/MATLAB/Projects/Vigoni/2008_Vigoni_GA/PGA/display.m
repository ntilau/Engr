function display(p)

disp('+---------------------------------+');
disp('| PGA: Pareto Genetic Algorithm   |');
disp('| (C) 2008 S. Selleri, v. 0.0     |');
disp('+---------------------------------+');
%%% POPULATION
disp('+-+-> Population data:');
disp(['| +-> Number specimens Nind = ',int2str(p.population.Nind)]);
disp(['| +-> Number generations performed Ngen = ',int2str(p.population.Ngen)]);
disp('|');
%%% PHENOTYPE
disp('+-+-> Phenotype data:');
disp(['| +-> Number of parameters Npar = ',int2str(p.phenotype.Npar)]);
for i=1:p.phenotype.Npar;
    disp(['| +-> Parameter (',int2str(i),') ',...
        'Bounds: [',num2str(p.phenotype.min{i}),', '...
        num2str(p.phenotype.max{i}),'] discretized in N = ',...
        int2str(p.phenotype.N{i}), ' bits']);
end
disp(['| +-> Total Number of bits = ',int2str(p.phenotype.Nbits)]);
disp('|');
%%% COST
disp('+-+-> Cost functions data:');
disp(['| +-> Number of cost functions Ncost = ',int2str(p.cost.Ncost)]);
for i=1:p.cost.Ncost;
    disp(['| +-> Cost function (',int2str(i),') ',...
        'Pointer : ',char(p.cost.pointer{i})]);
end

