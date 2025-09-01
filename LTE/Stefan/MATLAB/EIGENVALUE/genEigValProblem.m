% Solving the generalized matrix problem in MATLAB
% close all;
% clear all;

S = MatrixMarketReader( 'S' );
T = MatrixMarketReader( 'T' );
d = vectorReader( 'D' );

% homogeneous Dirichlet conditions: 
dirHit = 0;
Sdir = deleteDirichlet(S, d);
Tdir = deleteDirichlet(T, d);

[V D] = eig(Sdir, Tdir);
L = Sdir*V;
R = Tdir*V*D;
R = L-R;
for k=1:size(D)
    e1(k,1) = D(k,k);
    r(k,1) = norm(R(:,k));
end

e = sort(sqrt(e1));

X_fill = fillDirichletMat(V,d);
e_fill = fillDirichletVec(e,d);

% Write eigenvalues and eigenvectors
VectorWriterComplex(e_fill, 'E');
for i=1:r
    VectorWriterComplex(X_fill(1:r,i), strcat('X_', int2str(i)));
end