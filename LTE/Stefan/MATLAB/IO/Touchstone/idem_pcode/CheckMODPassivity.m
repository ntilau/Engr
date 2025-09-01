function IsMODPassive = CheckMODPassivity(MOD,mustplot,RootFigHandle);
%
%	IsMODPassive = CheckMODPassivity(MOD,mustplot)
%
% This function checks passivity of the multiport macromodel
% stored in structure MOD. The passivity check is performed
% according to the value of the reference resistance MOD.R0.
% If R0 is vanishing the data are interpreted as admittances.
% Otherwise scattering data are assumed. The passivity test
% is performed in the frequency-domain by checking the
% singular values of the scattering matrix (nonvanishing R0)
% or the eigenvalues of the even part of admittance matrix
% (vanishing R0). The state-space representation is used for
% the generation of frequency-domain data. If no state-space
% representation is present in MOD, the poles-residues
% representation is used. The generation of frequency axis
% is automatic on the basis of the poles location. The bandwidth
% that is checked is twice as large as the highest frequency
% pole. If optional argument mustplot is present and nonvanishing,
% relevant plots are produced.
%
% Output argument IsMODPassive is a logical flag reporting
% the results of the check (0/1). A value of -1 is returned
% if no test could be performed (e.g., missing data in MOD).
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: February 13, 2003
% Last revision: April 16, 2003
% ------------------------------
