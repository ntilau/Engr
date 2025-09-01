function cVal = readComplex(fid)
% cVal = readComplex(FID) reads a complex number out of the file 
% specified by FID.
% FID is an integer file identifier obtained from FOPEN.

a='0';
while a~='('
    a = fscanf(fid, '%c', 1);     % read '('
end
real = fscanf(fid, '%f', 1);
fscanf(fid, '%c', 1);     % read ','
imag = fscanf(fid, '%f', 1);
fscanf(fid, '%c', 1);     % read ')'
cVal = real+j*imag;
