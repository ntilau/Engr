% GETSMATRIXCOLUMN returns one column of the Z-matrix
function ZCol = getZMatrixColumn

global project solution excitation

nonPortVarDim = project.geo.domain.nonPort.scalarDim;

ZCol = solution((nonPortVarDim + 1):end);
 