% GETEAMPLITUDE returns the constant value of normalized 
% electrical field component E0 at the ports

function eFieldMag = computeEAmplitude(k0, portWidth)

constants;

beta = sqrt(k0^2 - pi^2 / portWidth^2);
eFieldMag = 1j * sqrt(2 * eta0 / beta / portWidth);




