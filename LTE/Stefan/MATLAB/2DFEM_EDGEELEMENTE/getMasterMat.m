%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Master Matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function master = getMasterMat(order)

% Import Master Matrices
Scomp   = dlmread('MasterMat\S.mat') ;
T1Comp = dlmread('MasterMat\M1.mat') ;
T2Comp = dlmread('MasterMat\M2.mat') ;
T3Comp = dlmread('MasterMat\M3.mat') ;

% check order to assemble the correct master matrix
num = checkOrder(order) ;

% assemble master matrix
master.S = Scomp(1:num, 1:num) ;
master.T1 = T1Comp(1:num, 1:num) ;
master.T2 = T2Comp(1:num, 1:num) ;
master.T3 = T3Comp(1:num, 1:num) ;