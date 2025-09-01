% Script for testing KrylovSubspaceParam2
close all;
clear all;

% for i=1:4
%     for j=1:i
%         A(i,j) = randn(1);
%         A(j,i) = A(i,j);
%         B(i,j) = randn(1);
%         B(j,i) = B(i,j);
%     end
% end
% A
% B
% A*B

order = 3;
path = 'C:\work\examples\coaxParam\';
mA = MatrixMarketReaderComplex(strcat(path, 'mA'));
% mA
mB = MatrixMarketReaderComplex(strcat(path, 'mB'));
% mB
ident = MatrixMarketReaderComplex(strcat(path, 'ident'));
%vb = vectorReader(strcat(path, 'vb'));
for i=1:size(mA)
     vb(i) = i;
end
vb=vb.';

% mA = inv(ident)*mA;
% mB = inv(ident)*mB;

% orthoMat = MatrixMarketReaderComplex(strcat(path, 'orthoMat'));
% erg = orthoMat*orthoMat'

% mA = rand(30)-0.5;
% mB = rand(30)-0.5;
% vb = rand(30,1)-0.5;
% allocate workspace
numEigVec = (order+1)*(order+2)/2;
mX = zeros(length(mA),numEigVec);
mAxOrtho = zeros(length(mA),numEigVec);
mBxOrtho = zeros(length(mA),numEigVec);
mAxCoeff = zeros(numEigVec,numEigVec);
mBxCoeff = zeros(numEigVec,numEigVec);
mF = zeros(numEigVec,numEigVec);

% initialization test (step 0)
mX(:,1) = vb/norm(vb);
mF(1,1) = norm(vb);
Ax = mA*mX(:,1);
%mAxOrtho(:,1) = Ax-(Ax.'*mX(:,1))*mX(:,1);
mAxOrtho(:,1) = Ax-mX(:,1)*(mX(:,1)'*Ax);
testAxOrtho = mAxOrtho(:,1)'*mX(:,1)
Bx = mB*mX(:,1);
%mBxOrtho(:,1) = Bx-(Bx'*mX(:,1))*mX(:,1);
mBxOrtho(:,1) = Bx-mX(:,1)*(mX(:,1)'*Bx);
testBxOrtho = mBxOrtho(:,1)'*mX(:,1)
mAxCoeff(1,1) = mX(:,1)'*Ax;
mBxCoeff(1,1) = mX(:,1)'*Bx;

% mX
% mAxOrtho
% mBxOrtho
% mAxCoeff
% mBxCoeff
% mF

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 0.5
Ab = mA*vb;
%Ab_ortho = Ab-(Ab'*mX(:,1))*mX(:,1);
Ab_ortho = Ab-mX(:,1)*(mX(:,1)'*Ab);
mX(:,2) = Ab_ortho/norm(Ab_ortho);
mF(2,:) = (mX'*Ab).';
mAxCoeff = mX'*mA*mX


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step1
Bb = mB*vb;
%Bb_ortho = Bb-(Bb'*mX(:,1))*mX(:,1);
Bb_ortho = Bb-mX(:,1)*(mX(:,1)'*Bb);
%Bb_ortho = Bb_ortho-(Bb_ortho'*mX(:,2))*mX(:,2);
Bb_ortho = Bb_ortho-mX(:,2)*(mX(:,2)'*Bb_ortho);
mX(:,3) = Bb_ortho/norm(Bb_ortho);
mF(3,:) = (mX'*Bb).';
mAxCoeff = mX'*mA*mX

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% step2
AAb = mA*mA*vb;
AAb_ortho = AAb-mX*(mX'*AAb);
mX(:,4) = AAb_ortho/norm(AAb_ortho);
mX(:,4)'*mX(:,3)
mX(:,4)'*mX(:,2)
mX(:,4)'*mX(:,1)
mF(4,:) = (mX'*AAb)';
mAxCoeff = mX'*mA*mX;

mix = (mA*mB+mB*mA)*vb;
mix_ortho = mix-mX*(mX'*mix);
mX(:,5) = mix_ortho/norm(mix_ortho);
mF(5,:) = (mX'*mix)';
mAxCoeff = mX'*mA*mX;

BBb = mB*mB*vb;
BBb_ortho = BBb-mX*(mX'*BBb);
mX(:,6) = BBb_ortho/norm(BBb_ortho);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 3
AAAb = mA*mA*mA*vb;
AAAb_ortho = AAAb-mX*(mX'*AAAb);
mX(:,7) = AAAb_ortho/norm(AAAb_ortho);
mAxCoeff = mX'*mA*mX;

mix4 = (mA*(mA*mB+mB*mA) + mB*mA*mA)*vb;
mix4_ortho = mix4-mX*(mX'*mix4);
mX(:,8) = mix4_ortho/norm(mix4_ortho);
mAxCoeff = mX'*mA*mX;

mix5 = (mB*(mA*mB+mB*mA) + mA*mB*mB)*vb;
mix5_ortho = mix5-mX*(mX'*mix5);
mX(:,9) = mix5_ortho/norm(mix5_ortho);

mix6 = mB*mB*mB*vb;
mix6_ortho = mix6-mX*(mX'*mix6);
mX(:,10) = mix6_ortho/norm(mix6_ortho);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 4
AAAAb = mA*mA*mA*mA*vb;
AAAAb_ortho = AAAAb-mX*(mX'*AAAAb);
mX(:,11) = AAAAb_ortho/norm(AAAAb_ortho);

mix7 = (mB*mA*mA*mA + mA*(mA*(mA*mB+mB*mA) + mB*mA*mA))*vb;
mix7_ortho = mix7-mX*(mX'*mix7);
mX(:,12) = mix7_ortho/norm(mix7_ortho);

mix8 = (mB*(mA*(mA*mB+mB*mA)+mB*mA*mA) + mA*(mB*(mA*mB+mB*mA) + mA*mB*mB))*vb;
mix8_ortho = mix8-mX*(mX'*mix8);
mX(:,13) = mix8_ortho/norm(mix8_ortho);

mix9 = (mB*(mB*(mA*mB+mB*mA) + mA*mB*mB) + mA*mB*mB*mB)*vb;
mix9_ortho = mix9-mX*(mX'*mix9);
mX(:,14) = mix9_ortho/norm(mix9_ortho);

mix10 = mB*mB*mB*mB*vb;
mix10_ortho = mix10-mX*(mX'*mix10);
mX(:,15) = mix10_ortho/norm(mix10_ortho);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 5
mix11 = mA*mA*mA*mA*mA*vb;
mix11_ortho = mix11-mX*(mX'*mix11);
mX(:,16) = mix11_ortho/norm(mix11_ortho);

mix12 = (mB*mA*mA*mA*mA + mA*(mB*mA*mA*mA + mA*(mA*(mA*mB+mB*mA) + mB*mA*mA)))*vb;
mix12_ortho = mix12-mX*(mX'*mix12);
mX(:,17) = mix12_ortho/norm(mix12_ortho);


mX
mAxOrtho
mBxOrtho
mAxCoeff
mBxCoeff
mF

mX(:,1)'*mX(:,3)
mX(:,2)'*mX(:,3)


X(:,1) = mX(:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v2 = mA*X(:,1);
x2 = v2-X*inv(X(:,1)'*X(:,1))*X'*v2;
x2 = x2/norm(x2);
X(:,2) = x2;
v2 = v2-X(:,1)*inv(X(:,1)'*X(:,1))*X(:,1)'*v2;

v3 = mB*X(:,1);
x3 = v3-X(:,1)*inv(X(:,1)'*X(:,1))*X(:,1)'*v3;
x3 = x3/norm(x3);
X(:,3) = x3;
v3 = v3-X(:,1)*inv(X(:,1)'*X(:,1))*X(:,1)'*v3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v4 = mA*v2;
x4 = v4-X(:,1:3)*inv(X(:,1:3)'*X(:,1:3))*X(:,1:3)'*v4;
x4 = x4/norm(x4);
X(:,4) = x4;
v4 = v4-X(:,1:3)*inv(X(:,1:3)'*X(:,1:3))*X(:,1:3)'*v4

v5 = mB*v2+mA*v3;
x5 = v5-X(:,1:3)*inv(X(:,1:3)'*X(:,1:3))*X(:,1:3)'*v5;
x5 = x5/norm(x5);
X(:,5) = x5;
v5 = v5-X(:,1:3)*inv(X(:,1:3)'*X(:,1:3))*X(:,1:3)'*v5;

v6 = mB*v3;
x6 = v6-X(:,1:3)*inv(X(:,1:3)'*X(:,1:3))*X(:,1:3)'*v6;
x6 = x6/norm(x6);
X(:,6) = x6;
v6 = v6-X(:,1:3)*inv(X(:,1:3)'*X(:,1:3))*X(:,1:3)'*v6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v7 = mA*v4
x7 = v7-X(:,1:6)*inv(X(:,1:6)'*X(:,1:6))*X(:,1:6)'*v7;
x7 = x7/norm(x7);
X(:,7) = x7;
v7 = v7-X(:,1:6)*inv(X(:,1:6)'*X(:,1:6))*X(:,1:6)'*v7;

v8 = mB*v4+mA*v5;
x8 = v8-X(:,1:6)*inv(X(:,1:6)'*X(:,1:6))*X(:,1:6)'*v8;
x8 = x8/norm(x8);
X(:,8) = x8;
v8 = v8-X(:,1:6)*inv(X(:,1:6)'*X(:,1:6))*X(:,1:6)'*v8;

v9 = mB*v5+mA*v6;
x9 = v9-X(:,1:6)*inv(X(:,1:6)'*X(:,1:6))*X(:,1:6)'*v9;
x9 = x9/norm(x9);
X(:,9) = x9;
v9 = v9-X(:,1:6)*inv(X(:,1:6)'*X(:,1:6))*X(:,1:6)'*v9;

v10 = mB*v6;
x10 = v10-X(:,1:6)*inv(X(:,1:6)'*X(:,1:6))*X(:,1:6)'*v10;
x10 = x10/norm(x10);
X(:,10) = x10;
v10 = v10-X(:,1:6)*inv(X(:,1:6)'*X(:,1:6))*X(:,1:6)'*v10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v11 = mA*v7;
x11 = v11-X(:,1:10)*inv(X(:,1:10)'*X(:,1:10))*X(:,1:10)'*v11;
x11 = x11/norm(x11);
X(:,11) = x11;
v11 = v11-X(:,1:10)*inv(X(:,1:10)'*X(:,1:10))*X(:,1:10)'*v11;

v12 = mB*v7+mA*v8;
x12 = v12-X(:,1:10)*inv(X(:,1:10)'*X(:,1:10))*X(:,1:10)'*v12;
x12 = x12/norm(x12);
X(:,12) = x12;
v12 = v12-X(:,1:10)*inv(X(:,1:10)'*X(:,1:10))*X(:,1:10)'*v12;

V=[X(:,1) x2 x4 x7 x11]
V'*V

X'*X
V'*mA*mA*mA*mX(:,1)

