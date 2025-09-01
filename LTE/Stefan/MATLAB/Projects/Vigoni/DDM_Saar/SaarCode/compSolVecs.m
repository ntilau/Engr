function Efield = compSolVecs(sol, SaarBlock, ND, SC_saar)


Y = sol((size(sol, 1) - size(SC_saar, 1) + 1) : (size(sol, 1)), 1 :  size(sol, 2));

Efield = [];

for id = 1 : (ND-1)
    Ep = SaarBlock{id}.Ep;
    X =  - Ep*Y;
    Efield = [Efield;X];
end
Efield = [Efield; sol];
