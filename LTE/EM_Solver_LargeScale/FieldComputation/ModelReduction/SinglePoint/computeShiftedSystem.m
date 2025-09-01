% returns shifted matrix A0, factors A0Factor and solution X0 in fExp
function [A0, A0Factor, X0, Time] = computeShiftedSystem(Model, SysMat, rhs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% factorize FE matrix in expansion point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Param.name = 'k0';
Param.val = f2k(Model.fExp);
A0 = buildFemMatrix(SysMat, Param);
disp('Factorizing A0...');
A0Factor = matrixFactor(A0, -2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% solve system in expansion point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

X0 = pardisoSolveLTE(A0Factor.mtype, A0Factor.iparm, A0Factor.pt, ...
    A0Factor.val, A0Factor.ia, A0Factor.ja, A0Factor.ncol, rhs, false);

Time.solveSys0 = toc;







