% calculate frequency F from shifted frequency parameter KAPPA and
% expansion wavenumber KEXP
function f = kappa2f(kappa, kExp)

constants;
% kappa = k0^2 - kExp^2 =>
f = c0 / (2 * pi) * sqrt(kappa + kExp^2);