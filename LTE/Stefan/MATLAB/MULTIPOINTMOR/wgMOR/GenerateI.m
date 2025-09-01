% ***********************************************************************
% ***********************************************************************
%
% A Model Order Reduction Method for the Finite Elment Simulation 
% of inhomogenous Waveguides
%
% Studienarbeit von Alwin Schultschik, 2006
%
% ***********************************************************************
%
% Function to Generate matrices I_psi and I_jV
%
% ***********************************************************************
% ***********************************************************************
% ***********************************************************************

function [I_psi,I_jV]=GenerateI(jV_psi)

% Generate matrices I_psi and I_jV
%
%          | 0 |                    | 0 |
%  I_psi = | I |     and     I_jV = | 0 |
%          | 0 |                    | I |

Iy_length = length(jV_psi);
Ix_length = length(  find( jV_psi > 0)  );

I_psi = sparse(zeros(Iy_length,Ix_length));
I_jV = sparse(zeros(Iy_length,Ix_length));

Ix=1;
for gg=1:max(jV_psi),
  jVPos = find(jV_psi==gg);
  psiPos = find(jV_psi==-gg);
  if isempty(jVPos) == 0,
    I_jV(jVPos,Ix) = 1;     % k0 Positionen
    I_psi(psiPos,Ix) = 1;
    Ix=Ix+1;
  end
    
end

