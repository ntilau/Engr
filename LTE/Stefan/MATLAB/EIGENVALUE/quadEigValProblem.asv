% Solving the quadratic eigenvalue problem in MATLAB
close all;
clear all;

A0 = MatrixMarketReader( 'A0' );
A1 = MatrixMarketReader( 'A1' );
A2 = MatrixMarketReader( 'A2' );
d = vectorReader( 'D' );

% homogeneous Dirichlet conditions: 
dirHit = 0;
[r c] = size(A0);
A0_dir = deleteDirichlet(A0, d);
A1_dir = deleteDirichlet(A1, d);
A2_dir = deleteDirichlet(A2, d);

[X,e] = polyeig(A0_dir, (-1)*A1_dir, (-1)*A2_dir);
[rx, cx] = size(X);

% fill the rows of the eigenvectors with 0 at dirichlet position
X_fill = fillDirichletMat(X,d); 

% Write eigenvalues and eigenvectors
VectorWriterComplex(e, 'E');
for i=1:r
    VectorWriterComplex(X_fill(1:r,i), strcat('X_', int2str(i)));
end

