% read vectors rhs and lVec from disc
function [rhs, lVec] = readSystemVectors(modelName, numLeftVecs, dirMarker)

for k = 1:numLeftVecs
    rhsTmp = readFullVector(strcat(modelName, 'rhs_', num2str(k-1), '.fvec'));
    rhs{k} = rhsTmp(~dirMarker);

    lVecTmp = readFullVector(strcat(modelName, 'leftVec_', num2str(k-1), '.fvec'));
    lVec{k} = lVecTmp(~dirMarker);
end