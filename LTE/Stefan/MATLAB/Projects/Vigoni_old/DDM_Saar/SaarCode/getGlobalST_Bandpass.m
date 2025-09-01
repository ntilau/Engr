function [S, T] = getGlobalST_Bandpass(CS, CT)

% get BLOCK
global BLOCK;

% get number of subdomains
nrd = size(BLOCK, 2);

%initialize
S = [];
T = [];
FS = [];
ES = [];
FT = [];
ET = [];
S = sparse(S);
T = sparse(T);
FS = sparse(FS);
ES = sparse(ES);
FT = sparse(FT);
ET = sparse(ET);

for dCnt = 1:nrd 
        S = [S, sparse(size(S, 1), size(BLOCK{dCnt}.MS, 2)); sparse(size(BLOCK{dCnt}.MS, 1), size(S, 2)), BLOCK{dCnt}.MS];
        T = [T, sparse(size(T, 1), size(BLOCK{dCnt}.MT, 2)); sparse(size(BLOCK{dCnt}.MT, 1), size(T, 2)), BLOCK{dCnt}.MT];

        FS = [FS, BLOCK{dCnt}.FS];
        ES = [ES; BLOCK{dCnt}.ES];

        FT = [FT, BLOCK{dCnt}.FT];
        ET = [ET; BLOCK{dCnt}.ET];
end

S = [S, ES; FS, CS];
T = [T, ET; FT, CT];


