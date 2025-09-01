% Calculating eigenvalues
close all;
clear all;

% %A_mult = MatrixMarketReader( 'MatMult' );
% A_inv = MatrixMarketReader( 'MatInv' );
% d = vectorReader( 'D' );
% 
% %A_mult_dir = deleteDirichlet(A_mult, d);
% A_inv_dir = deleteDirichlet(A_inv, d);
% e = eig(A_inv_dir);
% 
% e_abs = abs(e);
% con = max(e_abs)/min(e_abs)
% 
% % Write eigenvalues and eigenvectors
% VectorWriterComplex(con, 'cond');
% 
% % A2 = inv(A_inv_dir)*A_mult_dir;
% % e2 = eig(A2);
% % 
% % x_vor = vectorReader( 'x_vor' );
% % x_nach = vectorReader( 'x_nach' );
% % A = inv(A_inv)*A_mult;
% % x_nach2 = A*x_vor;
% % 
% % fehler1 = norm(x_nach-x_nach2)/norm(x_nach);
% % fehler2 = norm(x_nach-x_nach2)/norm(x_nach2);
% % 

dim = 100

for k=1:dim
    mA(k,k) = k+3;
    if k>1
        mA(k-1,k) = k+9;
        mA(k,k-1) = k+9;
    end
end

for k=1:dim
    mB(k,k) = (k+1)*k;
    if k>5
        mB(k-5,k) = k-74;
        mB(k,k-5) = k-74;
    end
end


e=sort(eig(mA,mB));
