function [V1,V2]=BlockSolver(A,B,C,D,IC,ID,flag)
%This function solve the block linear system of the following form
%
%   |A | B||V1|   |I1|
%   |--|--||  |=  |  |
%   |C | D||V2|   |I2|
%
%

[NAr,NAc]   =   size(A);
[NBr,NBc]   =   size(B);
[NCr,NCc]   =   size(C);
[NDr,NDc]   =   size(D);
[NI1r,NI1c] =   size(IC);
[NI2r,NI2c] =   size(ID);
if NI1r==1
    for i=1:length(IC)
        I1(i,1)=IC(i);
    end
elseif NI1c==1
    IC=I1;
else
    disp('ERROR: I1 must be a vector.');
end
if NI2r==1
    for i=1:length(ID)
        I2(i,1)=ID(i);
    end
elseif NI2c==1
    I2=ID;
else
    disp('ERROR: I2 must be a vector.');
end
%---------Checkings
if (NAr==NAc)&(NAr==NBr)
else
    disp('ERROR: A and B row number must be the same. A must be a squared matrix.');
    return
end
if (NDr==NDc)&(NCr==NDr)
else
    disp('ERROR: C and D row number must be the same. D must be a squared matrix.');
    return
end
if (NCc==NAc)
else
    disp('ERROR: A and C column number must be the same.');
    return
end    
if (NBc==NDc)
else
    disp('ERROR: B and D column number must be the same.');
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%DEBUG
% fA = full(A);
% fB = full(B);
% fC = full(C);
% fD = full(D);
% M = [fA,fB;fC,fD];
% I = [I1;I2];
% V = M\I;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iD  =   inv(D);
iI2 =   iD*I2;
%first unknown block solution
V1  =   (A-B*iD*C)\(I1-B*iI2);
%second unknown blok solution
if flag==1
    V2  =   iI2-iD*C*V1;
else
    V2  =   0;
end