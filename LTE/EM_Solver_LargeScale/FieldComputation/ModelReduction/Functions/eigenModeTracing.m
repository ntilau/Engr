% rearrange order of ritz pairs (V,D) corresponding to the reference
% Vectors Vref
% return:
%       D...     current ritz values, rearranged
%       V...     current ritz vectors, rearranged
function [V, D] = eigenModeTracing(Vref, massMat, D, V)

% append zeros at ritz vecors of previous order
dimDiff = size(V,1) -  size(Vref, 1);
Vref = [Vref; zeros(dimDiff,size(Vref, 1))];

rayleigh = Vref' * massMat * V;

% search indices of max entries in rayleigh coefficient matrix
[raylRow raylCol] = size(rayleigh);

tmpVecs = V;
tmpVals = D;

for n = 1:raylCol
    [maxVal maxRowInd] = max(abs(rayleigh));
    [maxVal maxColInd] = max(maxVal);
    
    prev = maxRowInd(maxColInd);
    curr = maxColInd;
 
    % set row and col of max entry to zero
    if n < raylRow
        rayleigh(prev,:) = 0;
    end
    rayleigh(:,curr) = 0;

    % rearrange ritz vectors
    if n <= raylRow
        V(:,prev) = tmpVecs(:,curr);
        D(prev,prev) = tmpVals(curr,curr);
    else
        V(:,n) = tmpVecs(:,curr);
        D(n,n) = tmpVals(curr,curr);
    end
end


