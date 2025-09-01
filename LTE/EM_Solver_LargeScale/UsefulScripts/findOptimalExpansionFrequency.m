% find FEXP such that in shifted frequency parameter domain kappaExp = 0
% is in the middle of the interval
function [fExp, ifExp] = findOptimalExpansionFrequency(fSample)

fExpRaw = sqrt(0.5 * (max(fSample)^2 + min(fSample)^2));

[tmp, ifExp] = min(abs(fSample - fExpRaw));

fExp = fSample(ifExp);


