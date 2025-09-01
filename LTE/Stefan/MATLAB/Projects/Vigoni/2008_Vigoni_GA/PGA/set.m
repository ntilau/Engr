function p = set(p,varargin)
% SETS various parameters

propertyArgIn = varargin;

invalidate = 0;

while length(propertyArgIn) >= 2,
    prop = propertyArgIn{1};
    val = propertyArgIn{2};
    propertyArgIn = propertyArgIn(3:end);

    switch prop
%%% Probabilità di Crossover
        case 'CrossoverProb'
            p.settings.XOverProb = val;
            invalidate = 0;

%%% Probabilità di Crossover
        case 'MutationProb'
            p.settings.MutProb = val;
            invalidate = 0;

%%% Della popolazione possiamo solo dire quanti specimen vogliamo
        case 'Population'
            p.population.Nind = floor(val);
            invalidate = 1;
            
%%% Gestione dell'array di puntatori a funzione costo    
        case 'Cost'
            if (~iscell(val))
                disp('Usage: p = set(p,''Cost'',{@cost1, @cost2, ...}');
                disp('       accepts a cell array of function pointers');
            else
                for i = 1:length(val)
                    p.cost.pointer{i} = val{i};
                end
                p.cost.Ncost = length(val);
                invalidate = 1;
            end
            
%%% Gestione del fenotipo            
        case 'Phenotype'
            if (~iscell(val))
                disp('Usage: p = set(p,''Phenotype'',{[mim1,max1,N1], [min2,max2,N2], ...}');
                disp('       accepts a cell array of three elements array');
                disp('       arrays contains minimum and maximum values for variation range');
                disp('       and the number of bits for its discretization');
            else
                Nbits = 0;
                for i = 1:length(val)
                    p.phenotype.min{i} = val{i}(1);
                    p.phenotype.max{i} = val{i}(2);
                    p.phenotype.N{i}   = floor(val{i}(3));
                    Nbits = Nbits + floor(val{i}(3));
                end
                p.phenotype.Npar = length(val);
                p.phenotype.Nbits = Nbits;
                invalidate = 1;
            end
            
%%% Otherwise            
        otherwise
            error('PGA properties: CrossoverProb, MutationProb, Population, Cost, Phenotype Use set(p,PropertyName,''help'' for more');
    end
end

if (invalidate==1)
    %%% All is lost!
    p.population.Ngen = 0;
    p.population.specimens={};
    p.population.cost=[];
    p.population.rank=[];
    p.population.pareto=[];
end
 