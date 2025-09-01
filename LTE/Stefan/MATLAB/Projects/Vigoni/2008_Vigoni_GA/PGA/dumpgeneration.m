function dumpgeneration(p,igen,ispec)

%%% POPULATION
if(nargin==2)
    if(igen>0 & igen<=p.population.Ngen)
        disp(['+-+-> Dumping Generation # ',int2str(igen),' :']);
        for i=1:p.population.Nind
            disp(['| +-+-> Specimen # ',int2str(i)]);
            disp(['| | +-> Ch:  ',p.population.specimens{igen}{i}]);
            disp(['| | +-> Par: ',num2str(decodespecimen(p,igen,i))]);
            disp(['| | +-> Co:  ',num2str(p.population.cost(igen,i,:))]);
            disp(['| | +-> Ran: ',num2str(p.population.rank(igen,i,:))]);
            if (p.cost.Ncost>1)
                disp(['| | +-> Pareto Front: ',int2str(p.population.pareto(igen,i))]);
            end
            disp(['| |']);
        end
    else
        disp(['+-+-> Generation # ',int2str(igen),' cannot be recovered ']);
    end
elseif (nargin==3)
    if(igen>0 & igen<=p.population.Ngen)
        if(ispec>0 & ispec<=p.population.Nind)
            disp(['+-+-> Dumping Generation # ',int2str(igen),' and Specimen # ',int2str(ispec),' :']);
            disp(['| +-> Ch:  ',p.population.specimens{igen}{ispec}]);
            disp(['| +-> Par: ',num2str(decodespecimen(p,igen,ispec))]);
            disp(['| +-> Co:  ' num2str(p.population.cost(igen,ispec,:))]);
            disp(['| +-> Ran: ',num2str(p.population.rank(igen,ispec,:))]);
            if (p.cost.Ncost>1)
                disp(['| +-> Pareto Front: ',int2str(p.population.pareto(igen,ispec))]);
            end
            disp(['|']);
        else
            disp(['+-> Specimen # ',int2str(ispec),' cannot be recovered ']);
        end
    else
        disp(['+-> Generation # ',int2str(igen),' cannot be recovered ']);
    end
else
    error('Missing generation number');
end
