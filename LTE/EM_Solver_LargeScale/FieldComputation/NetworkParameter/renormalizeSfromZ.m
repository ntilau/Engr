% desiredImp ...    vector of desired reference port impedances
% actualImp ...   vector of present port impedances
function S = renormalizeSfromZ(Z, actualImp, desiredImp)

Z0 = diag(actualImp);
Zref = diag(desiredImp);
Yref = diag(1./desiredImp);

Z = sqrt(Z0) * Z * sqrt(Z0);

S = sqrt(Yref) * (Z - Zref) * inv(Z + Zref) * sqrt(Zref);