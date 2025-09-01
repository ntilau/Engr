function printSnewLineMu(solArray, fMin, fMax, numF_Pnts, muMin, muMax, ...
  numMuPnts, filename)

if numF_Pnts ~= numMuPnts
  error('Number of frequency and material points must be the same!');
end
  
fid = fopen( filename, 'wt' );

fprintf(fid, '%i \n', numMuPnts);

if numF_Pnts == 1
  deltaF = 0;
else
  deltaF = (fMax-fMin)/(numF_Pnts-1);
end

if numMuPnts == 1
  deltaMu = 0;
else
  deltaMu = (muMax-muMin)/(numMuPnts-1);
end

for stepCnt = 1:numF_Pnts
  data(:, stepCnt) = [(fMin+(stepCnt-1)*deltaF); ...
    real((muMin+(stepCnt-1)*deltaMu)); imag((muMin+(stepCnt-1)*deltaMu))];
end

data = [data; real(solArray(1,:)); imag(solArray(1,:))];  % s_11
data = [data; real(solArray(2,:)); imag(solArray(2,:))];  % s_12

fprintf(fid,'%f  (%f,%4f) s11: (%4.16f,%4.16f) s12: (%4.16f,%4.16f) \n'...
  , data);
  
fclose( fid );
    
