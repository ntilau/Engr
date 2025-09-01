function [S] = ShurC_epsilon_v1(AC,BC,CD,sweep,S,C)
%**************************************************************************
%   [B,Y] = ShurC(AC,BC,CD,BLOCK,C)
%**************************************************************************
%
%   Shur-complement matrix form solver.
%
%**************************************************************************

% Definition of the Shur-complement matrix.--------------------------------
global BLOCK

ND = size(BLOCK,2);         %Subdomain number

for id = ND
    M = BLOCK{id}.M;
    E = BLOCK{id}.E;
    F = BLOCK{id}.F;
    if (size(M,1)~=0)
        idx = find(not(sum(abs(E),1)==0));
        Ep = zeros(size(E));
        %spparms('spumoni',1)
        Ep(:,idx) = (M\E(:,idx));
        Ep = sparse(Ep);
        %Fp = M\(F.');
        S = S - F*Ep;
        BLOCK{id}.Ep = Ep;
        %BLOCK{id}.Fp = Fp;
    end
    
end
S = S + C;

