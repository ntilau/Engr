% orthogonality test

tic
filename = 'C:\work\examples\coaxParam\coaxparam_1e+008_(4,0)_2\sysMat0';
sys0 = MatrixMarketReaderSparse(filename);
toc
filename = 'C:\work\examples\coaxParam\coaxparam_1e+008_(4,0)_2\krylov';
kry = readMatFull(filename);
oTest = conj(kry)*kry.'

sysMatReduced0 = conj(kry)*sys0*kry.'

pathName = 'C:\work\examples\coaxParam\coaxparam_1e+008_(4,0)_2\';
fNameSys0 = strcat(pathName, 'sysMatReduced0');
sysRed0 = readMatFull(fNameSys0);
