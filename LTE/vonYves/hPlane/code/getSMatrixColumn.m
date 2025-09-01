% GETSMATRIXCOLUMN returns one column of the S-matrix
function SCol = getSMatrixColumn


global project solution excitation

nonPortVarDim = project.geo.domain.nonPort.scalarDim;

SCol = solution((nonPortVarDim + 1):end) - excitation((nonPortVarDim + 1):end);
 