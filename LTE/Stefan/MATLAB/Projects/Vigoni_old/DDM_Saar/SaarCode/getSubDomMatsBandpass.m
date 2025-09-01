function [SaarBlock, CS, CT] = getSubDomMatsBandpass(compMatS, compMatT, ND)

global BLOCK;

dimCompMat = size(compMatS, 1);
indexC = 0;
for dCnt = 1 : ND
    indexC = indexC + size(BLOCK{dCnt}.MS, 1);
end
numColsE = dimCompMat - indexC;

SaarBlock = cell(ND, 1);
currentRow = 0;
for dCnt = 1 : ND
    numRows = size(BLOCK{dCnt}.ES, 1);
    
    SaarBlock{dCnt}.ES = compMatS((currentRow + 1) : (currentRow + numRows), (dimCompMat - numColsE + 1) : dimCompMat);
    SaarBlock{dCnt}.FS = compMatS((dimCompMat - numColsE + 1) : dimCompMat, (currentRow + 1) : (currentRow + numRows));
    SaarBlock{dCnt}.MS = BLOCK{dCnt}.MS;
    
    SaarBlock{dCnt}.ET = compMatT((currentRow + 1) : (currentRow + numRows), (dimCompMat - numColsE + 1) : dimCompMat);
    SaarBlock{dCnt}.FT = compMatT((dimCompMat - numColsE + 1) : dimCompMat, (currentRow + 1) : (currentRow + numRows));
    SaarBlock{dCnt}.MT = BLOCK{dCnt}.MT;

    currentRow = currentRow + numRows;
end

CS = compMatS((currentRow + 1) : dimCompMat, (currentRow + 1) : dimCompMat);
CT = compMatT((currentRow + 1) : dimCompMat, (currentRow + 1) : dimCompMat);

