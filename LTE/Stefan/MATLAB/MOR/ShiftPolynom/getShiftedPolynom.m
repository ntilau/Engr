function polyShift = getShiftedPolynom(degree, shift)
% input parameters:
% - input describes polynom p(x) = x^degree 
% - shift is the shift value
% output: 
% polyShift is the vector, containing the coefficients of the polynom
% p(delta) = (shift+delta)^degree 

polyShift = zeros(degree+1,1);
pascMat = pascal(degree+1);
for pascalCnt = 1:(degree+1)
    polyShift(pascalCnt) = polyShift(pascalCnt) + ...
        pascMat(degree-pascalCnt+2,pascalCnt) * shift^(degree-pascalCnt+1);
end


