function [mu, freqs, s] = readS_Param( filename ) % Function definition line

fid = fopen( filename, 'r' );
numMuSteps = fscanf(fid, '%d', 1);
numFreqSteps = fscanf(fid, '%d', 1);

freqs=zeros(numFreqSteps,1);
mu = zeros(numMuSteps,1);
s=zeros(numMuSteps, numFreqSteps);

for row = 1:numMuSteps
    for col = 1:numFreqSteps
        mu(row) = fscanf(fid, '%f', 1);
        freqs(col) = fscanf(fid, '%f', 1);
        stringS11 = fscanf(fid, '%s', 1);
        string = fscanf(fid, '%s', 1);
        pos1 = findstr(string, '(');
        pos2 = findstr(string, ',');
        pos3 = findstr(string, ')');
        eval(['s(row,col)=', string((pos1+1):(pos2-1)), '+j*', ...
                string((pos2+1):(pos3-1)), ';']);
    end
end

fclose( fid );
