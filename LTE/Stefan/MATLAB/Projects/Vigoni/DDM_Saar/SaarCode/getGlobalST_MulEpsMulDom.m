function [S, T, Sdiel, Tdiel] = getGlobalST_MulEpsMulDom(CS, CT, CSd, CTd, nrOfMatDom)

% get BLOCK
global BLOCK;

% get number of subdomains
nrd = size(BLOCK, 2);

%initialize
S = [];
T = [];
Sdiel = [];
Tdiel = [];
FS = [];
ES = [];
FT = [];
ET = [];
S = sparse(S);
T = sparse(T);
Sdiel = sparse(Sdiel);
Tdiel = sparse(Tdiel);
FS = sparse(FS);
ES = sparse(ES);
FT = sparse(FT);
ET = sparse(ET);

for dCnt = 1:nrd 
    if dCnt < (nrd-nrOfMatDom+1)
        S = [S, sparse(size(S, 1), size(BLOCK{dCnt}.MS, 2)); sparse(size(BLOCK{dCnt}.MS, 1), size(S, 2)), BLOCK{dCnt}.MS];
        T = [T, sparse(size(T, 1), size(BLOCK{dCnt}.MT, 2)); sparse(size(BLOCK{dCnt}.MT, 1), size(T, 2)), BLOCK{dCnt}.MT];

        FS = [FS, BLOCK{dCnt}.FS];
        ES = [ES; BLOCK{dCnt}.ES];

        FT = [FT, BLOCK{dCnt}.FT];
        ET = [ET; BLOCK{dCnt}.ET];
    else
        % material exists exclusively in last domain! 
        % part containing material
        for matDomCnt = 1 : nrOfMatDom
          Sdiel{matDomCnt} = [sparse(size(S, 1), size(S, 2)), sparse(size(S, 1), size(BLOCK{dCnt}.MSmtr{matDomCnt}, 2)); sparse(size(BLOCK{dCnt}.MSmtr{matDomCnt}, 1), size(S, 2)), BLOCK{dCnt}.MSmtr{matDomCnt}];
          Tdiel{matDomCnt} = [sparse(size(T, 1), size(T, 2)), sparse(size(T, 1), size(BLOCK{dCnt}.MTmtr{matDomCnt}, 2)); sparse(size(BLOCK{dCnt}.MTmtr{matDomCnt}, 1), size(T, 2)), BLOCK{dCnt}.MTmtr{matDomCnt}];
        end
        
        % part without material
        S = [S, sparse(size(S, 1), size(BLOCK{dCnt}.MS, 2)); sparse(size(BLOCK{dCnt}.MS, 1), size(S, 2)), BLOCK{dCnt}.MS];
        T = [T, sparse(size(T, 1), size(BLOCK{dCnt}.MT, 2)); sparse(size(BLOCK{dCnt}.MT, 1), size(T, 2)), BLOCK{dCnt}.MT];

        FS = [FS, BLOCK{dCnt}.FS];
        ES = [ES; BLOCK{dCnt}.ES];

        FT = [FT, BLOCK{dCnt}.FT];
        ET = [ET; BLOCK{dCnt}.ET];
    end    
end

S = [S, ES; FS, CS + CSd];
T = [T, ET; FT, CT + CTd];

for matDomCnt = 1 : nrOfMatDom
  Sdiel{matDomCnt} = [Sdiel{matDomCnt}, sparse(size(ES, 1), size(ES, 2)); sparse(size(FS, 1), size(FS, 2)), sparse(size(CSd, 1), size(CSd, 2))];
  Tdiel{matDomCnt} = [Tdiel{matDomCnt}, sparse(size(ET, 1), size(ET, 2)); sparse(size(FT, 1), size(FT, 2)), sparse(size(CTd, 1), size(CTd, 2))];
end
