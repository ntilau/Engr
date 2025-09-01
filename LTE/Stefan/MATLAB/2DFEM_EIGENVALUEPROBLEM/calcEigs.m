%
%
%
function [Vec, Val] = calcEigs(S, T, x)

[EVec, EVal] = eigs(S, T, x, 'sm') ;
for ii = 1:x
    Vec(:,ii) = EVec(:, x+1-ii) ;
    Val(:,ii) = EVal(:, x+1-ii) ;
end