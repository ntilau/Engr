function Efield = SolverDDM_saarLastDomPlusShurFreqEpsMu(SaarBlock, SC_saar, CS_saar, CT_saar, k0, nuRelArr, ...
  epsRelArr, ND, rhsFreqExtend)



sysMatLastDomPlusShur = computeSysMatLastDomPlusShurFreqEpsMu(SaarBlock, SC_saar, CS_saar, CT_saar, k0, nuRelArr, ...
  epsRelArr, ND);

sol = sysMatLastDomPlusShur \ rhsFreqExtend;

Y = sol((size(sol, 1) - size(SC_saar, 1) + 1) : (size(sol, 1)), 1 :  size(sol, 2));

% G = rhs_saar;
% Y = SCdiel_saar \ G;

Efield = [];
% for id = 1:ND
%     Ep = SaarBlock{id}.Ep;
% %     E = SaarBlock{id}.E;
% %     F = SaarBlock{id}.F;
%     X =  - Ep*Y;
%     Efield = [Efield;X];
% end
% Efield = [Efield;Y];

for id = 1 : (ND - 1)
    Ep = SaarBlock{id}.Ep;
%     E = SaarBlock{id}.E;
%     F = SaarBlock{id}.F;
    X =  - Ep*Y;
    Efield = [Efield;X];
end
Efield = [Efield; sol];

