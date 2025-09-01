function muSteps = calcMuSteps(mu0, muMin, muMax, numMuPnts)

muSteps = zeros(numMuPnts,1);
if numMuPnts == 1
  muSteps = (1/(muMin)-1/mu0)*mu0;
else
  deltaMu = (muMax-muMin)/(numMuPnts-1);
  for k=1:numMuPnts
    muSteps(k) = (1/(muMin+(k-1)*deltaMu)-1/mu0)*mu0;
  end
end    

