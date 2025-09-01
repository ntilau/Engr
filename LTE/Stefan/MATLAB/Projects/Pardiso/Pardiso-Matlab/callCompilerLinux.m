
addpath(genpath('C:\Ortwin\Matlab'));
set(0, 'DefaultFigureWindowStyle', 'docked');

% mex -LC:\work\LibTest\x64\release -lLibTest -v mexTest.c

%% call compiler for dss interface
%mex -v pardisoinit.c
clear all;
mex -I"C:\Program Files\Intel\MKL\9.1.027\include" -L"C:\Program Files\Intel\MKL\9.1.027\em64t\lib" -lmkl_solver -lmkl_em64t -lmkl_lapack -llibguide40 -v -g dss_sym_c.c
dss_sym_c;

% mex -v yprime.c

%% call compiler for dss interface
%mex -v pardisoinit.c
clear all;
mex -I"C:\Program Files\Intel\MKL\9.1.027\include" -L"C:\Program Files\Intel\MKL\9.1.027\em64t\lib" -lmkl_solver -lmkl_em64t -lmkl_lapack -llibguide40 -v -g dssFactorSymPosDef.c
mex -I"C:\Program Files\Intel\MKL\9.1.027\include" -L"C:\Program Files\Intel\MKL\9.1.027\em64t\lib" -lmkl_solver -lmkl_em64t -lmkl_lapack -llibguide40 -v -g dssSolveSymPosDef.c
% [opt handle] = dssFactorSymPosDef;
% [handle opt ptValue] = dssFactorSymPosDef;
[handle] = dssFactorSymPosDef;
dssSolveSymPosDef(handle);


%% call compiler for pardiso files
%mex -v pardisoinit.c
clear all;
mex -I"C:\Program Files\Intel\MKL\9.1.027\include" -L"C:\Program Files\Intel\MKL\9.1.027\em64t\lib" -lmkl_solver -lmkl_em64t -lmkl_lapack -llibguide40 -v -g pardiso_sym_c.c
mex -I"C:\Program Files\Intel\MKL\9.1.027\include" -L"C:\Program Files\Intel\MKL\9.1.027\em64t\lib" -lmkl_solver -lmkl_em64t -lmkl_lapack -llibguide40 -v -g pardiso_sym_complex_c.c

mex -I"C:\Program Files\Intel\MKL\9.1.027\include" -L"C:\Program Files\Intel\MKL\9.1.027\em64t\lib" -lmkl_solver -lmkl_em64t -lmkl_lapack -llibguide40 -v -g -largeArrayDims pardisoReorderLTE.c
mex -I"C:\Program Files\Intel\MKL\9.1.027\include" -L"C:\Program Files\Intel\MKL\9.1.027\em64t\lib" -lmkl_solver -lmkl_em64t -lmkl_lapack -llibguide40 -v -g -largeArrayDims pardisoFactorLTE.c
mex -I"C:\Program Files\Intel\MKL\9.1.027\include" -L"C:\Program Files\Intel\MKL\9.1.027\em64t\lib" -lmkl_solver -lmkl_em64t -lmkl_lapack -llibguide40 -v -g -largeArrayDims pardisoSolveLTE.c
pardiso_sym_c;
pardiso_sym_complex_c;

%%%%%%%%%%
% Test 1 %
%%%%%%%%%%

dim = 8;
A = zeros(dim);
A = [7 0 1 0 0 2 7 0;
  0 -4 8 0 2 0 0 0;
  1 8 1 0 0 0 0 5;
  0 0 0 7 0 0 9 0;
  0 2 0 0 5 1 5 0;
  2 0 0 0 1 -1 0 5;
  7 0 0 9 5 0 11 0;
  0 0 5 0 0 5 0 5];
A = sparse(A);
mtype = -2;
[iparm pt] = pardisoReorderLTE(mtype, A);
tic
   pardisoFactorLTE(pt, mtype, A, iparm);
toc
neqns = size(A);
x = ones(neqns(1),1);
x = (1 : neqns(1))';
b =  A*x;
x = zeros(neqns(1),1);
releaseMemory = true;
tic
   pardisoSolveLTE(pt, mtype, A, iparm, b, x, releaseMemory);
toc
norm(A*x-b)/norm(b)


%%%%%%%%%%
% Test 2 %
%%%%%%%%%%

dim = 300;
A2 = zeros(dim);
A2 = randn(dim);
A2 = A2 + A2';
A2 = sparse(A2);
mtype = -2;
[iparm2 pt2] = pardisoReorderLTE(mtype, A2);
tic
   pardisoFactorLTE(pt2, mtype, A2, iparm2);
toc
neqns = size(A2);
x2 = ones(neqns(1),1);
x2 = (1 : neqns(1))';
b2 = A2*x2;
x2 = zeros(neqns(1),1);
%  solve
releaseMemory = true;
tic
   pardisoSolveLTE(pt2, mtype, A2, iparm2, b2, x2, releaseMemory);
toc
norm(A2*x2-b2)/norm(b2)


%%%%%%%%%%
% Test 3 %
%%%%%%%%%%

% dim = 500;
% A3 = zeros(dim);
% A3 = randn(dim) + j * randn(dim);
% A3 = A3 + A3.';
% A3 = sparse(A3);

% fNameMat = 'system matrix_4';
% A3 = MatrixMarketReader(fNameMat);
% fNameRhs = 'rhs0_4';
% b3 = vectorReader(fNameRhs);
load linearSystemOfEquations;

mtype = 6;
[iparm3 pt3] = pardisoReorderLTE(mtype, A3);
tic
   pardisoFactorLTE(pt3, mtype, A3, iparm3);
toc
neqns = size(A3);
% x3 = (1 + 2j) * (1 : neqns(1))';
% b3 = A3*x3;
% x3 = zeros(neqns(1),1);
x3 = (1 + j) * ones(neqns(1),1);
%  solve
releaseMemory = true;
tic
   pardisoSolveLTE(pt3, mtype, A3, iparm3, b3, x3, releaseMemory);
toc
display(norm(A3 * x3 - b3) / norm(b3));


%% Cpp Test

clear all;

mex -I"/opt/intel/mkl/9.1.023/include" -L"/opt/intel/mkl/9.1.023/lib/em64t/" -lmkl_solver -lmkl_lapack -lmkl_em64t -lmkl -lvml -lguide -lpthread  -v -largeArrayDims pardisoReorderLTE_Cpp.cpp
mex -I"/opt/intel/mkl/9.1.023/include" -L"/opt/intel/mkl/9.1.023/lib/em64t/" -lmkl_solver -lmkl_lapack -lmkl_em64t -lmkl -lvml -lguide -lpthread  -v -largeArrayDims pardisoFactorLTE_Cpp.cpp
mex -I"/opt/intel/mkl/9.1.023/include" -L"/opt/intel/mkl/9.1.023/lib/em64t/" -lmkl_solver -lmkl_lapack -lmkl_em64t -lmkl -lvml -lguide -lpthread  -v -largeArrayDims pardisoSolveLTE_Cpp.cpp


mex -I"C:\Program Files\Intel\MKL\9.1.027\include" -L"C:\Program Files\Intel\MKL\9.1.027\em64t\lib" -lmkl_solver -lmkl_em64t -lmkl_lapack -llibguide40 -v -g -largeArrayDims pardiso_sym_cpp.cpp
pardiso_sym_cpp
mex -I"C:\Program Files\Intel\MKL\9.1.027\include" -L"C:\Program Files\Intel\MKL\9.1.027\em64t\lib" -lmkl_solver -lmkl_em64t -lmkl_lapack -llibguide40 -v -g -largeArrayDims pardiso_sym_complex_cpp.cpp
pardiso_sym_complex_cpp


%%%%%%%%%%
% Test 1 %
%%%%%%%%%%

dim = 8;
A = zeros(dim);
A = [7 0 1 0 0 2 7 0;
  0 -4 8 0 2 0 0 0;
  1 8 1 0 0 0 0 5;
  0 0 0 7 0 0 9 0;
  0 2 0 0 5 1 5 0;
  2 0 0 0 1 -1 0 5;
  7 0 0 9 5 0 11 0;
  0 0 5 0 0 5 0 5];
A = sparse(A);
mtype = -2;
[iparm pt] = pardisoReorderLTE_Cpp(mtype, A);
tic
   pardisoFactorLTE_Cpp(pt, mtype, A, iparm);
toc
neqns = size(A);
x = ones(neqns(1),1);
x = (1 : neqns(1))';
b =  A*x;
x = zeros(neqns(1),1);
releaseMemory = true;
tic
   pardisoSolveLTE_Cpp(pt, mtype, A, iparm, b, x, releaseMemory);
toc
norm(A*x-b)/norm(b)


%%%%%%%%%%%%%%%%%
% ultimate test
%%%%%%%%%%%%%%%%%
load linearSystemOfEquations;

mtype = 6;
[iparm3 pt3] = pardisoReorderLTE_Cpp(mtype, A3);
tic
   pardisoFactorLTE_Cpp(pt3, mtype, A3, iparm3);
toc
neqns = size(A3);
x3 = (1 + j) * ones(neqns(1),1);
%  solve
releaseMemory = true;
tic
   pardisoSolveLTE_Cpp(pt3, mtype, A3, iparm3, b3, x3, releaseMemory);
toc
display(norm(A3 * x3 - b3) / norm(b3));






