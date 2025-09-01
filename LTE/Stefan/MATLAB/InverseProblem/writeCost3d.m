function writeCost3d(lowBndMu, upBndMu, numMuRealPnts, ...
  numMuImagPnts, cost3d, fNameCost3d)

% write costs in a file
fid = fopen(fNameCost3d,'w');

fprintf(fid, '%i %i \n', numMuRealPnts, numMuImagPnts);
deltaMuReal = (upBndMu(1)-lowBndMu(1))/(numMuRealPnts-1);
deltaMuImag = (upBndMu(2)-lowBndMu(2))/(numMuImagPnts-1);
for muRealCnt = 1:numMuRealPnts
  muRealAct = lowBndMu(1)+(muRealCnt-1)*deltaMuReal; 
  for muImagCnt = 1:numMuImagPnts
    muImagAct = lowBndMu(2)+(muImagCnt-1)*deltaMuImag;
    fprintf(fid,'%16.12f  %16.12f %16.12f \n', muRealAct, muImagAct,...#
      cost3d(muRealCnt, muImagCnt));
  end
end

fclose(fid);
