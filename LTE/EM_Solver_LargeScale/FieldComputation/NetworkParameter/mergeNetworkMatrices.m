function [sMatAll, fAll] = mergeNetworkMatrices(sMatA, fA, sMatB, fB)

[fAll, ifA, ifB] = union(fA, fB);

nFreqs = length(fAll);

fA = fA(ifA);
fB = fB(ifB);

sMatA = sMatA(ifA);
sMatB = sMatB(ifB);

sMatAll = cell(nFreqs, 1);
fCnt = 0;

while ~isempty(fA) && ~isempty(fB)
    fCnt = fCnt + 1;
    [fNext, iFArray] = min([fA(1), fB(1)]);
            
    if iFArray == 1          
        sMatAll{fCnt} =  sMatA{1};
        fA(1) = [];
        sMatA = sMatA(2:end);
    else
        sMatAll{fCnt} =  sMatB{1};
        fB(1) = [];
        sMatB = sMatB(2:end);
    end
end

for k = 1:length(fA)
    fCnt = fCnt + 1;
    sMatAll{fCnt} = sMatA{k};
end

for k = 1:length(fB)
    fCnt = fCnt + 1;
    sMatAll{fCnt} = sMatB{k};
end

    