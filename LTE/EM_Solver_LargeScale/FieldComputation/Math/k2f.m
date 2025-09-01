% compute frequency from vacuum wavenumber
function f = k2f(k)

f = 2.99792458e8 * k / (2 * pi);