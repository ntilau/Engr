% reduce number of krylov vectors by singular decompostion

H_ = MatrixMarketReader( 'Hess' );
[r c] = size(H_);
H = H_(:,2:c);
H = H_;
[U,S,V] = svd(H,0);
[numRowU numColU] = size(U);

for k=1:ceil((c-1)/2)
%for k=1:ceil(c)
    VectorWriter(U(:,k), strcat('U_', int2str(k)));
    %VectorWriter(U(:,numColU-k+1), strcat('U_', int2str(k)));
    %VectorWriter(V(:,k), strcat('U_', int2str(k)));
end
