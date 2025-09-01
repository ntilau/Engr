function [mu, freqs, s11, s12] = readSparamMOR_muLine(filename)

fid = fopen( filename, 'r' );
numSteps = fscanf(fid, '%d', 1);

freqs = zeros(numSteps,1);
mu = zeros(numSteps,1);
s11 = zeros(numSteps, 1);
s12 = zeros(numSteps, 1);

for stepCnt = 1:numSteps
  freqs(stepCnt) = fscanf(fid, '%f', 1);
  mu(stepCnt) = readComplex(fid);
  stringS11 = fscanf(fid, '%s', 1);
  s11(stepCnt)= readComplex(fid);
  stringS12 = fscanf(fid, '%s', 1);
  s12(stepCnt)= readComplex(fid);
end

fclose( fid );
