function [combMat currentRowNo] = buildAllCombinations(dataCell, currentRow, ...
    currentRowNo, currentPosInRow, combMat)

nParams = length(dataCell);
if currentPosInRow == nParams
    for k = 1:length(dataCell{nParams})
        currentRow(nParams) = dataCell{nParams}(k);
        combMat(currentRowNo,:) = currentRow;
        currentRowNo = currentRowNo+1;
    end
else
    for k = 1:length(dataCell{currentPosInRow})
        currentRow(currentPosInRow) = dataCell{currentPosInRow}(k);
        [combMat currentRowNo] = buildAllCombinations(dataCell, currentRow, ...
            currentRowNo, currentPosInRow+1, combMat);
    end
end
    