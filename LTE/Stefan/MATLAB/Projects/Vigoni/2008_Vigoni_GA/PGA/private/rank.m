function p = rank( p )

%ranks the population
for i=1:p.cost.Ncost
    caux = p.population.cost(p.population.Ngen,:,i);
    [aux,ix0]=sort(caux);
    ix1(ix0) = 1:p.population.Nind;
    p.population.rank(p.population.Ngen,:,i)=ix1;
end

% Also in Pareto sense
if (p.cost.Ncost>1)
    for i=1:p.population.Nind
        %%% Supponiamo sia sul fronte...
        p.population.pareto(p.population.Ngen,i) = 1;
        for j=1:p.population.Nind
            if (i~=j)
                %%% Supponiamo sia dominato...
                dom = 1;
                for k = 1:p.cost.Ncost
                    if ( p.population.cost(p.population.Ngen,i,k) <= ...
                         p.population.cost(p.population.Ngen,j,k) )
                         %%% no, non è dominato da questo j!
                        dom = 0;
                    end
                end
                if (dom == 1)
                    %%% Tutti i costi di i sono maggiori di j !!!
                    p.population.pareto(p.population.Ngen,i) = 0;
                end
            end
        end
    end
end

%% Memorizza il fronte storico
p = UpdateFront (p);


%% DA TOGLIERE, solo DEBUG
NN = 25;
idx=1;
for i=-NN:NN
    for j=-NN:NN
        x(1) = i*5/NN;
        x(2) = j*5/NN;
        c1(idx) = x*x';
        c2(idx) = (x-2)*(x-2)';
        idx = idx + 1;
    end
end
plot(c1,c2,'oc');
hold on;
for i=1:p.population.Ngen
    plot(p.population.cost(i,:,1),p.population.cost(i,:,2),'og');
end

plot(p.population.cost(p.population.Ngen,:,1),p.population.cost(p.population.Ngen,:,2),'ob');

for j=1:p.population.Ngen-1
    for i=1:p.population.Nind
        if (p.population.pareto(j,i)==1)
            plot(p.population.cost(j,i,1),p.population.cost(j,i,2),'*y');
        end
    end
end

for i=1:p.population.Nind
    if (p.population.pareto(p.population.Ngen,i)==1)
        plot(p.population.cost(p.population.Ngen,i,1),p.population.cost(p.population.Ngen,i,2),'*r');
    end
end

for i=1:length(p.population.front)
    plot(p.population.cost(p.population.front(i).Ngen,p.population.front(i).Nind,1),...
        p.population.cost(p.population.front(i).Ngen,p.population.front(i).Nind,2),'sk');
end
hold off
axis([0 20 0 20]);

pause
        




