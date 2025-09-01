function d = computeDominantPoles(Model, shift, nEigs)

% read system matrices and vectors
dirMarker = logical(readFullVector(strcat(Model.path, 'dirMarker.fvec')));
SysMat = readSystemMatrices(Model.path, dirMarker);

iS = findMatrixIndex(SysMat, 'system matrix');
iT = findMatrixIndex(SysMat, 'k^2 matrix');
d = eigs(SysMat(iS).val, - SysMat(iT).val, nEigs, shift);

