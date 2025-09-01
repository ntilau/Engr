function epsSteps = calcEpsSteps(epsExp, epsMin, epsMax, numEpsPnts)

epsSteps = zeros(numEpsPnts,1);
if numEpsPnts == 1
  epsSteps = (epsMin-epsExp)/epsExp;
else
  deltaEps = (epsMax-epsMin)/(numEpsPnts-1);
  for k=1:numEpsPnts
    epsSteps(k) = (epsMin+(k-1)*deltaEps-epsExp)/epsExp;
  end
end    

