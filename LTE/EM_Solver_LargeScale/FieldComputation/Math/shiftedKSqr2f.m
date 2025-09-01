% compute frequency from vacuum wavenumber
function f = shiftedKSqr2f(s, kExp)

f = 2.99792458e8 * sqrt(s + kExp^2) / (2 * pi);