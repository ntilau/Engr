function [freqs, s] = readSdiscrete( filename ) % Function definition line

fid = fopen( filename, 'r' );
numFreqSteps = fscanf(fid, '%d', 1);

freqs = zeros(1, numFreqSteps);
s = zeros(1, numFreqSteps);

for col = 1:(2*numFreqSteps)
  freqsNow = fscanf(fid, '%f', 1);
  string1 = fscanf(fid, '%s', 1);
  string2 = fscanf(fid, '%s', 1);
  if(strcmp(string1, 'port2'))
    freqs((col+1)/2) = freqsNow;
    real = fscanf(fid, '%f', 1);
    imag = fscanf(fid, '%f', 1);
    string3 = fscanf(fid, '%s', 1);
    string3 = fscanf(fid, '%s', 1);
    string3 = fscanf(fid, '%s', 1);
    s((col+1)/2) = real+j*imag;
  else
    string3 = fscanf(fid, '%s', 1);
    string3 = fscanf(fid, '%s', 1);
    string3 = fscanf(fid, '%s', 1);
    string3 = fscanf(fid, '%s', 1);
    string3 = fscanf(fid, '%s', 1);
  end
end

fclose( fid );