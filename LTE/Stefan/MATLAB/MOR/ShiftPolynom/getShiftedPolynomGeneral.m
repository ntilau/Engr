function polyShift = getShiftedPolynomGeneral(poly, shift)
% input parameters:
% - poly contains the coefficient a_n ... a_0 of a polynom p(x) = a_n x^n +
% a_{n-1} x^{n-1} + ... + a_1 x + a_0
% - shift is the shift value
% output: 
% polyShift is the vector, containing the coefficients of the polynom
% p(delta) = a_n (shift+delta)^n + ... + a_1 (shift+delta) +a_0

numCoeffs = length(poly);
polyShift = zeros(numCoeffs,1);
pascMat = pascal(numCoeffs);
for coeffCnt = 1:numCoeffs
    for pascalCnt = 1:coeffCnt
        polyShift(pascalCnt) = polyShift(pascalCnt) + poly(coeffCnt) * ...
            pascMat(coeffCnt-pascalCnt+1,pascalCnt) * shift^(coeffCnt-pascalCnt+1-1);
    end
end


