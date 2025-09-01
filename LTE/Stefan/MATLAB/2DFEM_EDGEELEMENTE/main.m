%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%      2D Edge Elements for Generalised Eigenvalue Problem using         %
%   E-field Formulation and homogenuous Dirichlet Boundary Conditions    %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% startup
clear all ;
close all ;
clc ;

% variable definition
name  = 'MeshDaten\box' ;

% set material parameters
eps0 = 8.854187818e-12 ;
mu0  = 1.256637061e-6 ;

% set parameters
ORDER      = 1 ;            % order of hierachical vector basis function (1-3)
EIGENVAL   = 150e6 ;        % guess of eigenfrequency in Hz
NUM_EIGS   = 2 ;            % number of eigenvalues to calculate (< dim(S))
SIGMA      = eps0*mu0*(2*pi*EIGENVAL)^2 ; % convert to generalized eigenvalue
SPARSE_IT  = 1 ;            % 1: use sparse matrix
                            % 0: do not use sparse matrix
ORTHO      = 1 ;            % 1: use modified Arnoldi (orthogonalisation)
                            % 0: use standard Arnoldi,

% import data
proj = projectReader(name) ;

% calculate degrees of freedom
DOF = calcDOF(proj) ;

% convert into consistent mesh format
proj = convertTopology(proj) ;

% get system matrices
[S, T] = getSysMatrices(proj, ORDER, SPARSE_IT) ;

% impose dirichlet boundary conditions
[S, T] = imposeDBC(proj, S, T, ORDER) ;

% calculate discrete grad-operator
if ORTHO
    G = calcGrad(proj, ORDER) ;
end

% calculate eigenvalues and eigenvectors
if ORTHO
    [vec, val] = run_eigs(S, T, G, NUM_EIGS, SIGMA) ;
else
    [vec, val] = eigs(S,T,NUM_EIGS,SIGMA) ;
end

% calculate eigenfrequency
val = diag(sqrt(val/(eps0*mu0))/2/pi) ;  % convert eigenvalues to Hz

% calculate analytical solution
val_real = calcAnalytSol(proj, NUM_EIGS, eps0, mu0) ;

% plot realpart of eigenvalues
plot(sort(val), '+') ; hold on ; plot(val_real,'o') ;

% visualize e-field for specific eigenvalue
showSolution(real(val(1)), real(vec(:,1)), proj, ORDER) ;

% error
% err(ORDER) = (val_real(2)-val(1))/val_real(2);
