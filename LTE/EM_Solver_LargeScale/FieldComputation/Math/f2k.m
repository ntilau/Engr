% compute frequency from vacuum wavenumber
function k = f2k(f)

c0 = 2.99792458e8;
k = 2 * pi * f / c0;
