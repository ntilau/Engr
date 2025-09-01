% comparing the matrix from debug and releas mode in MATLAB
close all;
clear all;

D = MatrixMarketReader( 'C:\work\examples\rect1\rect1_4\matDebug' );
R = MatrixMarketReader( 'C:\work\examples\rect1\rect1_4\matRelease' );

dif = D-R;
err1 = norm(dif,1)/norm(D,1)
err2 = norm(dif,1)/norm(R,1)

