% main
%
%

% clear workspace and close all other open windows
clear all ;
close all ;
clc ;

% variable definition
name  = 'MeshDaten\Diel' ;

% set parameters
order = 2 ;     % order of nodal basis function (1 or 2)
x = 5 ;        % number of eigenvalues to calculate

% import data
proj = projectReader(name) ;

% geometry
a = 1 ;
b = 1 ;

% read boundary conditions
dirichlet = proj.bcInfo.dirichlet ;

% set material parameters
eps0 = 8.854187818e-12 ;
mu0  = 1.256637061e-6 ;

% get system matrices
[S, T] = getSysMatrices(proj, order) ;

% attach boundary conditions (dirichlet)
[S, T] = attachBC(proj, order, S, T, dirichlet) ;

% get the xth smallest eigenvalues and -vectors
[Ez_calc, Val] = calcEigs(S, T, x) ;

% calc eigenfrequencies
omega_calc = sqrt(Val(find(Val~=0))/(mu0*eps0)) ;

% calc and show exact eigenfrequencies and eigenvectors
[omega_real, Ez_real, X, Y] = calcRealSol(x, a, b, mu0, eps0) ;

% plot solution (eigenvalues and eigenvectors)
plotSol(omega_calc, omega_real, Ez_calc, Ez_real, X, Y, x, proj, order) ;

% write solution
solutionWriter(Ez_calc, proj, name) ;
