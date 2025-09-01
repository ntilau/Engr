% examination of Hessenberg matrix


H_ = MatrixMarketReader( 'Hess' );
[r c] = size(H_);
H = H_(:,2:c);
[U,S,V] = svd(H);

[z s] = size(S);
for k=1:s
    x(k) = S(k,k);
end
figure;
semilogy(x);


% H5_ = MatrixMarketReader( 'Hess5' );
% [r c] = size(H5_);
% H5 = H5_(:,2:c);
% [U5,S5,V5] = svd(H5);
% 
% [z5 s5] = size(S5);
% for k=1:s5
%     x5(k) = S5(k,k);
% end
% figure;
% semilogy(x5);
% 

% H8_ = MatrixMarketReader( 'Hess8' );
% [r c] = size(H8_);
% H8 = H8_(:,2:c);
% [U8,S8,V8] = svd(H8);
% 
% [z8 s8] = size(S8);
% for k=1:s8
%     x8(k) = S8(k,k);
% end
% figure;
% semilogy(x8);
% 
% H11_ = MatrixMarketReader( 'Hess11' );
% [r c] = size(H11_);
% H11 = H11_(:,2:c);
% [U11,S11,V11] = svd(H11);
% 
% [z11 s11] = size(S11);
% for k=1:s11
%     x11(k) = S11(k,k);
% end
% figure;
% semilogy(x11);
