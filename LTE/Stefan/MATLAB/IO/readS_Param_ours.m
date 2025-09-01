function [freqs, s] = readS_ParamOurs( filename ) % Function definition line

% reads s11

fid = fopen( filename, 'r' );

for row = 1:numMuSteps
    for col = 1:numFreqSteps
        freqs(col) = fscanf(fid, '%f', 1);
        string1 = fscanf(fid, '%s', 1);
        string1 = fscanf(fid, '%s', 1);
        string1 = fscanf(fid, '%s', 1);
        string1 = fscanf(fid, '%s', 1);
        string1 = fscanf(fid, '%s', 1);

        string = fscanf(fid, '%s', 1);
        pos1 = findstr(string, '(');
        pos2 = findstr(string, ',');
        pos3 = findstr(string, ')');
        eval(['s(row,col)=', string((pos1+1):(pos2-1)), '+j*', ...
                string((pos2+1):(pos3-1)), ';']);
    end
end

fclose( fid );
