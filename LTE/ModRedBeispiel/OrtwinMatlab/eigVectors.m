% eigenvectors of generalized eigenvalue problem

close all;
clear all;

R1 = rand(5);
A = R1.'*R1;

[V1,D1] = eig(A);

R2 = rand(5);
B = R2.'*R2;

[V2,D2] = eig(B);

V1.'*B*V1

[V3,D3] = eig(A,B);
V3.'*A*V3
V3.'*B*V3
V3.'*V3


