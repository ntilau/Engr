function [SaarBlock, SC_saar] = ShurC_saar(SaarBlock, k0, ND)

% initialize variables
dimColS = size(SaarBlock{1}.ES, 2);
dimRowS = size(SaarBlock{1}.FS, 1);
S = sparse(dimRowS, dimColS);

for id = 1:(ND-1)
    
    M = SaarBlock{id}.MS - k0^2 * SaarBlock{id}.MT;
    E = SaarBlock{id}.ES - k0^2 * SaarBlock{id}.ET;
    F = SaarBlock{id}.FS - k0^2 * SaarBlock{id}.FT;
    
    if (size(M,1)~=0)
        idx = find(not(sum(abs(E),1)==0));
%         Ep = zeros(size(E));
        Ep = sparse(size(E,1), size(E,2));
        [L, U, P, Q] = lu(M);
        Ep(:,idx) = Q*(U\(L\(P* E(:,idx))));
        
%         Ep(:,idx) = M \ E(:,idx);
%         Ep = sparse(Ep);
        S = S - F*Ep;
        SaarBlock{id}.Ep = Ep;
    end
    
end
SC_saar = S;