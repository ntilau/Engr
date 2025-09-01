function currentROM = computeCurrentROM(currentROM, sysMat, rhs, K, currentCol, transposeFlag)


currentDim = size(currentROM.sysMat{1},1);
for matCnt = 1:length(currentROM.sysMat)
    if ~isempty(sysMat{matCnt})
        sysMatNew = zeros(currentCol);
        sysMatNew(1:currentDim,1:currentDim) = currentROM.sysMat{matCnt};
        if transposeFlag
            sysMatNew((currentDim+1):end, (currentDim+1):end) = ...
                K(:,(currentDim+1):currentCol).' * sysMat{matCnt} * K(:,(currentDim+1):currentCol);
            newOffDiagBlock = K(:,1:currentDim).' * sysMat{matCnt} * K(:,(currentDim+1):currentCol);
            sysMatNew(1:currentDim, (currentDim+1):end) = newOffDiagBlock;
            sysMatNew((currentDim+1):end, 1:currentDim) = newOffDiagBlock.';
        else
            sysMatNew((currentDim+1):end, (currentDim+1):end) = ...
                K(:,(currentDim+1):currentCol)' * sysMat{matCnt} * K(:,(currentDim+1):currentCol);
            newOffDiagBlock = K(:,1:currentDim)' * sysMat{matCnt} * K(:,(currentDim+1):currentCol);            
            sysMatNew(1:currentDim, (currentDim+1):end) = newOffDiagBlock;
            sysMatNew((currentDim+1):end, 1:currentDim) = newOffDiagBlock';
        end
        currentROM.sysMat{matCnt} = sysMatNew;
    end
end
for rhsCnt = 1:length(currentROM.rhs)
    if ~isempty(rhs{rhsCnt})
        rhsNew = zeros(currentCol,1);
        rhsNew(1:currentDim) = currentROM.rhs{rhsCnt};
        if transposeFlag
            rhsNew((currentDim+1):end) = K(:,(currentDim+1):currentCol).' * rhs{rhsCnt};
        else
            rhsNew((currentDim+1):end) = K(:,(currentDim+1):currentCol)' * rhs{rhsCnt};
        end
        currentROM.rhs{rhsCnt} = rhsNew;
    end
end
