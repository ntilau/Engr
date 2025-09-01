function [eigError, iRefEig, iRomEig] = calcEigError(refEig, romEig)

nRefEigs = length(refEig);
nRomEigs = length(romEig);
nErrors = min(nRomEigs, nRefEigs);

% create difference matrix
deltaEig = zeros(nRefEigs, nRomEigs);
for k = 1:nRefEigs
    for m = 1:nRomEigs
        deltaEig(k,m) = abs(refEig(k) - romEig(m));
    end
end

% search for minima in difference matrix
iRefEig = zeros(nErrors, 1);
iRomEig = zeros(nErrors, 1);
for k = 1:nErrors
    [colMin, iArrayRowMin] = min(deltaEig);
    [totalMin, iColMin] = min(colMin);
    iRowMin = iArrayRowMin(iColMin);
    deltaEig(iRowMin, :) = inf;
    deltaEig(:, iColMin) = inf;
           
    eigError.abs(k) = totalMin;
    eigError.rel(k) = totalMin / refEig(iRowMin);
    iRefEig(k) = iRowMin;
    iRomEig(k) = iColMin;
end


