function [A0 Aeps Anu] = getParamModelLastDomOnly(SaarBlock, SC_saar, CS_saar, CT_saar, k0, ND)

id = ND;
E = SaarBlock{id}.ES - k0^2 * SaarBlock{id}.ET;
F = SaarBlock{id}.FS - k0^2 * SaarBlock{id}.FT;
A0 = [SaarBlock{id}.MS - k0^2 * SaarBlock{id}.MT, E; F, SC_saar + CS_saar - k0^2 * CT_saar];
Aeps = [- k0^2 * SaarBlock{id}.MTmtr, sparse(size(E, 1), size(E, 2)); 
  sparse(size(F, 1), size(F, 2)), sparse(size(CS_saar, 1), size(CS_saar, 2))];
Anu = [SaarBlock{id}.MSmtr, sparse(size(E, 1), size(E, 2)); 
  sparse(size(F, 1), size(F, 2)), sparse(size(CS_saar, 1), size(CS_saar, 2))];

% for id = ND
%     M = SaarBlock{id}.MS - k0^2 * SaarBlock{id}.MT + nuRel * SaarBlock{id}.MSmtr - k0^2 * epsRel * SaarBlock{id}.MTmtr;
%     
%     if (size(M,1)~=0)
%         idx = find(not(sum(abs(E),1)==0));
%         Ep = zeros(size(E));
%         Ep(:, idx) = M \ E(:, idx);
%         Ep = sparse(Ep);
%         SC_saar = SC_saar - F * Ep;
%         SaarBlock{id}.Ep = Ep;
%     end
%     
% end
% 
% SCdiel_saar = SC_saar + CS_saar - k0^2 * CT_saar;

