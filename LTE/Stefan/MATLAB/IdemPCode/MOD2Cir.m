function MOD2Cir(MOD,pathname,name,Options,RootFigHandle);
%
%	MOD2Cir(MOD,pathname,name,Options)
%
% This function generates a SPICE subcircuit that synthesizes
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
% The only dynamic elements included in the synthesis are identical
% capacitances. The capacitance value can be provided via field
% 'Cap' of MOD. If this field is not present, a unitary value is used.
%
% The name of the SPICE subcircuit is <name>. This subcircuit is
% written to output file <name>.cir. Do not include the extension
% in the input string! The file will be placed in the directory
% pointed by <pathname>.
%
% The additional (optional) input parameter Options is used to
% customize the synthesized equivalent circuit.
% - Options.GroundReferences
%   determines how the reference nodes for all ports are generated. 
%   If set to 0 (default), each port in the synthesized circuit will have a
%   "private" (floating) reference node. If it is set to 1, all
%   ports will share a common reference node. The latter option is
%   useful for grounded multiports.
% - Options.ResistorType
%   controls the synthesis of resistors in the equivalent circuit. These
%   resistors are not "true" resistors, but are just dummy components
%   that are used to translate the model equations into a SPICE netlist.
%   Therefore, these resistors might lead to wrong results when employed
%   in a "noise" analysis. Four different types of synthesis are available,
%   according to the value of Options.ResistorType
%   1 --> synthesis as standard resistor (default)
%   2 --> synthesis as a resistor with appended keyword "isnoisy=0" 
%         (available only for HSPICE)
%   3 --> synthesis as current-controlled voltage source
%   4 --> synthesis as voltage-controlled current-source
%
% ------------------------------
% Author: Stefano Grivet Talocia
% Date: June 26, 2002
% Last revision: February 11, 2005
%                (MB) July 18, 2006
% ------------------------------
