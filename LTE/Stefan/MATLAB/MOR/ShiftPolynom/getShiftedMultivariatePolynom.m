function [vCoeffs mPowers] = getShiftedMultivariatePolynom(degree, shift)
% input parameters:
% - input describes polynom p(x_1,...,x_n) = x_1^degree(1) *
% x_2^degree(2) * ... *x_n^degree(n)
% - shift is the shift value
% output:
% polyShift is the vector, containing the coefficients of the polynom
% p(delta_1,...,delta_n) = (shift(1)+delta_1)^degree(1) *
% (shift(2)+delta_2)^degree(2) * ... * (shift(n)+delta_n)^degree(n)
%

numParams = length(shift);
polyShiftCell = cell(numParams,1);
powersCell = cell(numParams,1);
for pCnt = 1:numParams
    polyShiftCell{pCnt} = getShiftedPolynom(degree(pCnt), shift(pCnt));
    powersCell{pCnt} = 0:degree(pCnt);
end

% compute number of factors
nFactors = 1;
for pCnt = 1:numParams
    nFactors = nFactors * length(polyShiftCell{pCnt});
end

mCoeffs = zeros(nFactors,numParams);
currentRowNo = 1;
currentPosInRow = 1;
currentRow = zeros(1,numParams);
mCoeffs = buildAllCombinations(polyShiftCell, currentRow, currentRowNo, ...
    currentPosInRow, mCoeffs);

mPowers = zeros(nFactors,numParams);
currentRowNo = 1;
currentPosInRow = 1;
currentRow = zeros(1,numParams);
mPowers = buildAllCombinations(powersCell, currentRow, currentRowNo, ...
    currentPosInRow, mPowers);

vCoeffs = ones(size(mCoeffs,1),1);
for pCnt = 1:numParams
    vCoeffs = vCoeffs .* mCoeffs(:,pCnt);
end
    
    
    
    