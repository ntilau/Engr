function MODfull = MODFill(MOD,tol,RootFigHandle);
%
%	MODfull = MODFill(MOD,tol)
%
% This function processes the macromodel representation
% stored in structure MOD and produces a new structure
% MODfull by filling all empty fields. In particular,
%
% - if only the state-space representation is available,
%   the poles-residues representation is computed and stored.
%   This conversion is exact. In case of sparse systems,
%   it is assumed that the ABCD matrices are in
%   Gilbert canonical form.
%
% - if only the poles-residues representation is available,
%   a Gilbert state-space realization is computed and stored.
%   For full systems,
%     this conversion is not exact, and requires a threshold
%     for the determination of ranks of residue matrices. This
%     threshold is passed in optional argument tol, the default
%     being 1e-3.
%   For sparse systems,
%     the conversion is performed by appending all poles
%     exciting each column of the transfer matrix. In case
%     of common poles through different columns, these poles
%     are replicated and a larger (and sparser) system is
%     realized.
%
% - if both representations are already present (or none),
%   no action is taken.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: February 13, 2003
% Last revision: April 19, 2003
% ------------------------------
