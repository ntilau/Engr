function [S, IAC] = ShurC(AC,BC,CD,sweep,C)
%**************************************************************************
%   [B,Y] = ShurC(AC,BC,CD,BLOCK,C)
%**************************************************************************
%
%   Shur-complement matrix form solver.
%
%**************************************************************************

% Definition of the Shur-complement matrix.--------------------------------
global BLOCK

ND = size(BLOCK,2) + 1;         %Subdomain number

S = C*0;

for id = 1:(ND-1)
        M = BLOCK{id}.M;
        E = BLOCK{id}.E;
        F = BLOCK{id}.F;
        if (size(M,1)~=0)
            idx = find(not(sum(abs(E),1)==0));
            Ep = zeros(size(E));
            Ep(:,idx) = (M\E(:,idx));
            Ep = sparse(Ep);
%             Ep = M\E;
            %Fp = M\(F.');
            S = S - F*Ep;
            BLOCK{id}.Ep = Ep;
            %BLOCK{id}.Fp = Fp;
        end
%     end
end

IAC = sparse(diag((1./diag(AC)))); %inverse of AC
S = S - CD*IAC*BC;
%S = S - CD*IAC*BC;
