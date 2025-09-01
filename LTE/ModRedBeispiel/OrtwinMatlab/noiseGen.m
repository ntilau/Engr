dim = 100000;
noiseReal = randn(dim,1);
varNoiseReal = var(noiseReal)
noiseComplex = randn(dim,1)+j*randn(dim,1);
varNoseComplex = var(noiseComplex)

noise = randn(121,1) + j*randn(121,1);
var(noise)
varianz = 1e-1;
noise = noise * sqrt(varianz);
var(noise)
filename = ('C:\work\examples\wg_perm_sym\results\wg_perm_sym_1.2e+010_10_10_pN\noise.txt');
VectorWriterComplex(noise, filename);

zeroNoise = zeros(121,1);
VectorWriterComplex(zeroNoise, filename);
