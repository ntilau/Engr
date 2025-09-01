function [mu, freqs, s11] = readSparamMORs11(filename)

fid = fopen( filename, 'r' );
numFreqSteps = fscanf(fid, '%d', 1);
numMuSteps = fscanf(fid, '%d', 1);

freqs = zeros(numFreqSteps,1);
mu = zeros(numMuSteps,1);
s11 = zeros(numMuSteps, numFreqSteps);
s12 = zeros(numMuSteps, numFreqSteps);

for col = 1:numFreqSteps
    for row = 1:numMuSteps
        freqs(col) = fscanf(fid, '%f', 1);
        mu(row) = readComplex(fid);
        stringS11 = fscanf(fid, '%s', 1);
        s11(row,col)= readComplex(fid);
    end
end

fclose( fid );
