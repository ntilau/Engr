function IsDataPassive = CheckDataPassivity(DUM,domain,mustplot,RootFigHandle);
%
%	IsDataPassive = CheckDataPassivity(DUM,domain,mustplot)
%
% This function checks passivity of the multiport
% characterized by the raw data in structure DUM.
% The flag domain can be either 'frequency' or 'time'.
% The passivity check is performed according to this
% flag, as detailed below. Also, the value of the reference
% resistance DUM.R0 determines the type of passivity test.
% If R0 is vanishing the data are interpreted as admittances.
% Otherwise scattering data are assumed.
%
% Important: the passivity tests are run also if some responses
% are not available (flagged by zeros in DUM.pindex). In this
% case, the corresponding responses are set to zero and
% the passivity tests have little meaning, since some
% energy is not accounted for.
%
% domain = 'frequency' and DUM.R0 not zero (scattering test)
%
%    The scattering matrix at each available frequency
%    is processed ant its singular values are computed.
%    If flag <mustplot> is set to 1, all singular values
%    are plotted against frequency. Otherwise, only the
%    result of the passivity test (singlar values not larger
%    than one at each available frequency point) is printed
%    to the command window and returned in output argument
%    <IsDataPassive> (1 if passive, 0 if not). A result of
%    -1 is returned if there is some problem with the raw
%    data (e.g., incomplete data)
%
% domain = 'frequency' and DUM.R0 equal to zero (admittance test)
%
%    The admittance matrix at each available frequency
%    is processed and the eigenvalues of its hermitian part computed.
%    If flag <mustplot> is set to 1, all these eigenvalues
%    are plotted against frequency. Otherwise, only the
%    result of the passivity test (real parts of eigenvalues
%    nonnegative at each available frequency point) is printed
%    to the command window and returned in output argument
%    <IsDataPassive> (1 if passive, 0 if not). A result of
%    -1 is returned if there is some problem with the raw
%    data (e.g., incomplete data)
%    
% domain = 'time' and DUM.R0 not zero (scattering test)
%
%    The cumulative energy entering and exiting the device
%    at all times and at all ports is computed. The passivity
%    check is satisfied if at any time this cumulative energy
%    entering the ports is not smaller than that exiting the ports.
%    If flag <mustplot> is set to 1, the difference {energy in}/{energy out}
%    is plotted for all excitations. Otherwise, only the
%    result of the passivity test is printed
%    to the command window and returned in output argument
%    <IsDataPassive> (1 if passive, 0 if not). A result of
%    -1 is returned if there is some problem with the raw
%    data (e.g., incomplete data)
%
% domain = 'time' and DUM.R0 equal to zero (admittance test)
%
%    The cumulative energy entering the device
%    at all times and at all ports is computed. The passivity
%    check is satisfied if at any time this cumulative energy
%    is nonnegative. If flag <mustplot> is set to 1,
%    this cumulative energy is plotted for all excitations.
%    Otherwise, only the result of the passivity test is printed
%    to the command window and returned in output argument
%    <IsDataPassive> (1 if passive, 0 if not). A result of
%    -1 is returned if there is some problem with the raw
%    data (e.g., incomplete data)
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: January 31, 2003
% Last revision: April 11, 2003
% ------------------------------
