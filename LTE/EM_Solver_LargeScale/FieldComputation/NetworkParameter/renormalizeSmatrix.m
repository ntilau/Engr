function sMatRenorm = renormalizeSmatrix(sMat, actualImp, desiredImp)

if ~iscell(sMat)
    S = sMat;
    sMat{1} = S;
end

nFreqs = length(sMat);

n = size(sMat{1},1);
if length(desiredImp) == 1
    desiredImp = desiredImp * ones(1,n);
end

sqrtZ0 = sqrt(diag(actualImp));
Zref = diag(desiredImp);
sqrtZref = sqrt(Zref);
sqrtYref = sqrt(diag(1./desiredImp));
Id = eye(n);
sMatRenorm = cell(nFreqs, 1);

for k = 1:nFreqs
    Z = sqrtZ0 * inv(Id - sMat{k}) * (sMat{k} + Id) * sqrtZ0;
    sMatRenorm{k} = sqrtYref * (Z - Zref) * inv(Z + Zref) * sqrtZref;
end