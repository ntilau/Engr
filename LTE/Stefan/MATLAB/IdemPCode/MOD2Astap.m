function MOD2Astap(MOD,pathname,name,Options,RootFigHandle);
%
%	MOD2Astap(MOD,pathname,name,Options)
%
% This function generates an ASTAP subcircuit that synthesizes
% the state-space equations coded in structure MOD.
% It is assumed that the state-space equations are a realization
% of a reduced-order model of a linear multiport. The number
% of ports can be desumed by rows of C,D or columns of B,D.
% The field MOD.R0 is used to distinguish between admittance
% representation (MOD.R0 == 0) and scattering representation.
% In the admittance case inputs are port voltages and outputs
% are port currents. In the scattering case
% the input (forcing) vector collects the impinging scattering
% waves into each port, while the output vector collects the
% outgoing scattering waves from each port. Also, the reference
% resistance used for all ports must be the same and is also
% stored in MOD.R0.
%
% It is assumed that the realization has a block-diagonal
% matrix A in the form
%
%   A = blkdiag(A_1,A_2,...,A_N)
%
% where the blocks corresponding to real poles have dimension 1
% and the blocks corresponding to the complex poles have the form
%
%   [sigma omega; -omega sigma] 
%
% where sigma and omega are the real and imaginary part of
% the complex poles. The real and
% complex poles can be intermixed without any prescribed order.
%
% The name of the ASTAP subcircuit is <name>. This subcircuit is
% written to output file <name> (without any extension).
% The file will be placed in the directory pointed by <pathname>.
%
% The additional (optional) input parameter Options.GroundReferences
% determines how the reference nodes for all ports are generated. 
% If set to 0 (default), each port in the synthesized circuit will have a
% "private" (floating) reference node. If it is set to 1, all
% ports will share a common reference node. The latter option is
% useful for grounded multiports.
%
% June 15, 2005: added specification of partial derivatives for all
% dependent sources to increase efficiency.
%
% ------------------------------
% Author: Stefano Grivet Talocia
% Date: June 26, 2002
% Last revision: June 15, 2005
%                (MB) July 18, 2006
% ------------------------------
