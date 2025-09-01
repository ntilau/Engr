function sysMatLastDomPlusShur = computeSysMatLastDomPlusShurFreqEpsMu(SaarBlock, SC_saar, CS_saar, CT_saar, ...
  k0, nuRelArr, epsRelArr, ND)


id = ND;

M = SaarBlock{id}.MS - k0^2 * SaarBlock{id}.MT;
for epsCnt = 1 : length(epsRelArr)
  M = M - k0^2 * epsRelArr(epsCnt) * SaarBlock{id}.MTmtr{epsCnt};
end
for nuCnt = 1 : length(nuRelArr)
  M = M + nuRelArr(nuCnt) * SaarBlock{id}.MSmtr{epsCnt};
end
E = SaarBlock{id}.ES - k0^2 * SaarBlock{id}.ET;
F = SaarBlock{id}.FS - k0^2 * SaarBlock{id}.FT;

% if (size(M,1)~=0)
%   idx = find(not(sum(abs(E),1)==0));
%   Ep = zeros(size(E));
%   Ep(:, idx) = M \ E(:, idx);
%   Ep = sparse(Ep);
%   SC_saar = SC_saar - F * Ep;
%   SaarBlock{id}.Ep = Ep;
% end
% 
% 
% SCdiel_saar = SC_saar + CS_saar - k0^2 * CT_saar;

sysMatLastDomPlusShur = [M E; F (SC_saar + CS_saar - k0^2 * CT_saar)];

