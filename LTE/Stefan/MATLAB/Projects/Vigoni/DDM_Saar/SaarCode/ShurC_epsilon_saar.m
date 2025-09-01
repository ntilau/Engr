function [SaarBlock, SCdiel_saar] = ShurC_epsilon_saar(SaarBlock, SC_saar, CS_saar, CT_saar, k0, nuRel, epsRel, ND)

for id = ND
    M = SaarBlock{id}.MS - k0^2 * SaarBlock{id}.MT + nuRel * SaarBlock{id}.MSmtr - k0^2 * epsRel * SaarBlock{id}.MTmtr;
    E = SaarBlock{id}.ES - k0^2 * SaarBlock{id}.ET;
    F = SaarBlock{id}.FS - k0^2 * SaarBlock{id}.FT;
    
    if (size(M,1)~=0)
        idx = find(not(sum(abs(E),1)==0));
        Ep = zeros(size(E));
        Ep(:, idx) = M \ E(:, idx);
        Ep = sparse(Ep);
        SC_saar = SC_saar - F * Ep;
        SaarBlock{id}.Ep = Ep;
    end
    
end

SCdiel_saar = SC_saar + CS_saar - k0^2 * CT_saar;