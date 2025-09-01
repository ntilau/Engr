function [minEig, maxEig] = gerschgorinEstimator(A)

% midpoints
m = diag(A);
gerschgorinRadius = sum(abs(A), 2) - abs(m);

% compute distances of Gerschgorin disks to the origin
dmin = abs(m) - gerschgorinRadius;
dmax = abs(m) + gerschgorinRadius;

minEig = min(dmin);
maxEig = max(dmax);