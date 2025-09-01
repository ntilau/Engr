% GETEAMPLITUDE returns the constant value of normalised 
% electrical field component E0 at the ports

function E0 = getEAmplitude(project, omega)

% define physical constants
epsilon_0 = 8.854e-12;
mu_0 = 4*pi*1e-7;

% wave number
k0 = omega * sqrt(epsilon_0 * mu_0);

beta = sqrt(k0^2 - (pi/project.wg_width)^2);
E0 = j * sqrt(2 * omega * mu_0 / beta / project.wg_width);




