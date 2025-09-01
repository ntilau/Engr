function saveROM(rom, modelName)


numColPermutMat = size(rom.permutMat,2);
% Determine number of nonempty matrices in rom.sysMat
nonempty = 0;
for k = 1:length(rom.sysMat)
    if ~isempty(rom.sysMat{k})
        nonempty = nonempty + 1;
    end
end
sysMatCleared = zeros(nonempty,numColPermutMat);
nonEmptyPos = 1;
for k = 1:length(rom.sysMat)
    if ~isempty(rom.sysMat{k})
        fName = strcat(modelName, 'sysMatRed_', num2str(rom.permutMat(k, 1)));
        for m = 2:numColPermutMat
            fName = strcat(fName, '_', num2str(rom.permutMat(k, m)));
        end
        writeMatFull(rom.sysMat{k}, [fName '.fmat']);
        sysMatCleared(nonEmptyPos,:) = rom.permutMat(k,:);
        nonEmptyPos = nonEmptyPos + 1;
    end
end

writeSysMatRedNames(sysMatCleared, strcat(modelName,'sysMatRedNames.txt'));

for k = 1:length(rom.ident)
    fName = strcat(modelName, 'identRed_', num2str(k-1), '.fmat');
    writeMatFull(rom.ident{k}, fName);
end

for k = 1:rom.numLeftVecs
    writeVector(rom.lVec{k}, strcat(modelName, 'leftVecsRed_', num2str(k-1), '.fvec'));
    writeVector(rom.rhs{k}, strcat(modelName, 'redRhs_', num2str(k-1), '.fvec'));
end
