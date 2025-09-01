% ***********************************************************************
% ***********************************************************************
%
% A Model Order Reduction Method for the Finite Elment Simulation 
% of inhomogenous Waveguides
%
% Studienarbeit von Alwin Schultschik, 2006
%
% ***********************************************************************
%
% This script gets the matrices and their frequency dependence of the
% 2d eigenmode solver
%
% ***********************************************************************
% ***********************************************************************
% ***********************************************************************


function [S_k0,S_k1,S_k2,T_k0,T_k1,T_k2, oMult, oInv]  = getFreqDepMat(dirStr, projStr)

%projStr2 = 'Bertazzi_MicroStrip_halfWavePort1';

% Compose or Load Frequency dependent Matrices



    % run solver with f = 0 Hz
    system(['cd ' dirStr projStr ' & EM_eigenmodesolver2d '  projStr ...
        ' 0  1 +SingleLevelCoupling writeMatrices +pg +o \w' ] );
    
    
    
    % read matrices
    S0 = MatrixMarketReader([dirStr projStr '\mat_0']);
    T0 = MatrixMarketReader([dirStr projStr '\mat_1']);

    % find frequency with k = 1
    k1=100;
    c0 = 299792.458e3;
    f1 = c0/(2.0*pi) *k1;
    system(['cd ' dirStr projStr ' & EM_eigenmodesolver2d '  projStr ' ' ...
        num2str(f1) ' 1 +SingleLevelCoupling writeMatrices +pg +o \w' ] );
   
    S1 = MatrixMarketReader([dirStr projStr '\mat_0']);
    T1 = MatrixMarketReader([dirStr projStr '\mat_1']);

    
    % find frequency with k = 2
    k2=2*k1;
    c0 = 299792.458e3;
    f1 = c0/(2.0*pi) *k2;
    system(['cd ' dirStr projStr ' & EM_eigenmodesolver2d '  projStr ' ' ...
        num2str(f1) ' 1 +SingleLevelCoupling writeMatrices +pg +o \w' ] );

    S2 = MatrixMarketReader([dirStr projStr '\mat_0']);
    T2 = MatrixMarketReader([dirStr projStr '\mat_1']);    
    
    
%     S_k0 = S0;
%     S_k2 = (S2 - 2*S1 + S0) / 2 ;
%     S_k1 = S1 - S_k2 -S_k0 ;
    
    
    S_k0 = S0;
    S_11 = (S1 - S0)/k1;
    S_22 = (S2-S0)/k2;
    S_k2 = (S_22-S_11)/k1;
    S_k1 = (2*S_11 - S_22); 
    
    T_k0 = T0;
    T_k1 = 0;
    T_k2 = 0; 

    % Achtung Hack !!!!!!!!!!!!!!!!!!!!!!!!!!
%     system(['cd ' dirStr projStr ' & EM_eigenmodesolver2d '  projStr ...
%         ' ' num2str(12e9)  ' 5 +SingleLevelCoupling writeMatrices +pg +o
%         \w' ] );
    

%     oMult = MatrixMarketReader([dirStr projStr '\orthoMat_0']);
%     oInv = MatrixMarketReader([dirStr projStr '\orthoMat_1']);    
    
    % Aus Berechnente Matrizen Dirichlet Zeilen/Spalten Streichen
    D_Vector = vectorReader([dirStr projStr '\D']);
    InvDirPos = find(D_Vector==0);

    S_k0=S_k0(InvDirPos,InvDirPos);
    S_k1=S_k1(InvDirPos,InvDirPos);
    S_k2=S_k2(InvDirPos,InvDirPos);
    T_k0=T_k0(InvDirPos,InvDirPos);
%     
%     oMult = oMult(InvDirPos,InvDirPos);
%     oInv = oInv(InvDirPos,InvDirPos);

% % ---------------------------------------------------------------------------------
% %                          TEST
% k_test = 300;    
% f_test = k_test*c0/(2.0*pi);
% system(['cd ' dirStr projStr ' & em_eigenmodesolver2d ' projStr ' ' num2str(f_test) ' 1 2 +dx writeMatrices \w'])
% S_test = MatrixMarketReader([dirStr projStr '\mat_0']);
% T_test = MatrixMarketReader([dirStr projStr '\mat_1']); 
% S_test=S_test(InvDirPos,InvDirPos);
% S_diff = (S_test - (S_k0 + k_test*S_k1 + k_test^2*S_k2));
% % ----------------------------------------------------------------
