function [mu, freqs, s11, s12] = readS_ParamDet(filename)

fid = fopen( filename, 'r' );
numMuSteps = fscanf(fid, '%d', 1);
numFreqSteps = fscanf(fid, '%d', 1);

freqs = zeros(numFreqSteps,1);
mu = zeros(numMuSteps,1);
s11 = zeros(numMuSteps, numFreqSteps);
s12 = zeros(numMuSteps, numFreqSteps);

for row = 1:numMuSteps
  for col = 1:numFreqSteps
    mu(row) = fscanf(fid, '%f', 1);
    freqs(col) = fscanf(fid, '%f', 1);
    stringS11 = fscanf(fid, '%s', 1);
    s11(row,col)= readComplex(fid);

    stringS12 = fscanf(fid, '%s', 1);
    s12(row,col)= readComplex(fid);
  end
end

fclose( fid );
