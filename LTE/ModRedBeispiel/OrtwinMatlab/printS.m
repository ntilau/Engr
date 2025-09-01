function printS(solArray, numK_Steps, numMuSteps, fMin, deltaF, muMin, ...
  deltaMu, filename)

fid = fopen( filename, 'wt' );

fprintf(fid, '%i', numK_Steps);
fprintf(fid, ' %i \n', numMuSteps);

for kCnt = 1:numK_Steps
  for muCnt = 1:numMuSteps
    pos = (kCnt-1)*numMuSteps+muCnt;
    data(:, pos) = [(fMin+(kCnt-1)*deltaF); ...
      (muMin+(muCnt-1)*deltaMu)];
  end
end

data = [data; real(solArray(1,:)); imag(solArray(1,:))];  % s_11
data = [data; real(solArray(2,:)); imag(solArray(2,:))];  % s_12

fprintf(fid,'%4.16f  %4.16f s11: (%4.16f,%4.16f) s12: (%4.16f,%4.16f) \n'...
  , data);
fclose( fid );
    
