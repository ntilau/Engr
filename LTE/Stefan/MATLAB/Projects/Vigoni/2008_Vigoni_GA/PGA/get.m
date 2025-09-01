function val = set(p,propName)
% SETS various parameters

switch propName

%%% COST
    case 'Cost'
        % Returns the Cost cell array
        for i = 1:p.cost.Ncost
            val{i} = p.cost.pointer{i};
        end
    case 'Cost'
        % Returns the Length of Cost cell array
        val = p.cost.Ncost

%%% PHENOTYPE
    case 'Phenotype'
        for i = 1:length(p.phenotype)
            val{i} = [p.phenotype.min{i},p.phenotype.max{i},p.phenotype.N{i}];
        end
    otherwise
        error('PGA properties: Specimens, Generations, Cost, NCost, Phenotype')
end



