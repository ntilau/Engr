function [Efield] = SolverDDM_saar(SaarBlock, SCdiel_saar, rhs_saar, ND)

G = rhs_saar;
Y = SCdiel_saar \ G;

Efield = [];
for id = 1:ND
    Ep = SaarBlock{id}.Ep;
%     E = SaarBlock{id}.E;
%     F = SaarBlock{id}.F;
    X =  - Ep*Y;
    Efield = [Efield;X];
end
Efield = [Efield;Y];