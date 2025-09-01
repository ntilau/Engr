function [A,B,C,Nr]=ResPoles2ABC(rp,cp,Rr,Rc,tol);
%
%	function [A,B,C,Nr] = ResPoles2ABC(rp,cp,Rr,Rc,tol)
% 
% Computes the A,B,C matrices from the poles and the 
% matrices of residues via Gilbert's realizations.
%
% Important: this function should be used only if the
% matrices are full. Sparse matrices are not supported
% (and will never supported by this algorithm).
%
% Input parameters:
%
%   rp: vector containing all real poles
%   cp: vector containing all complex poles with
%       positive imaginary part
%   Rr{k}(i,j): cell array with matrices of residues for real poles
%              (port i, port j, real pole k)
%   Rc{k}(i,j): cell array with matrices of residues for complex poles
%              (port i, port j, complex pole k)
%
% Output parameters:
%
%   A, B, C: Gilbert's realization matrices
%   Nr:		 sum of the ranks of the residue matrices
%            of real poles
%
% -----------------------------
% Authors: Ivan Maio
%          Stefano Grivet-Talocia
% Date: March 19, 2002
% Last revision: July 13, 2006
% -----------------------------
