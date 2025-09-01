function scaleRHS = calcScaleRHS(f0, fMin, fMax, numF_Pnts, fCutOff)

c0 = 299792.458e3;
k0 = 2.0*pi*f0/c0;
for excitationCnt = 1:length(fCutOff)
  scaleRHS{excitationCnt} = zeros(numF_Pnts,1);
  if numF_Pnts == 1
    kNow = 2*pi*fMin/c0;
    factor = sqrt(1-(fCutOff(excitationCnt) / fMin)^2)...
      /sqrt(1 - (fCutOff(excitationCnt) / f0)^2);
    % REVISIT: * factor in TE case, / factor in TM case
    scaleRHS{excitationCnt} = kNow/k0 * factor;
  else
    deltaF = (fMax-fMin)/(numF_Pnts-1);
    for k=1:numF_Pnts
      fNow = fMin+(k-1)*deltaF;
      kNow = 2*pi*fNow/c0;
      factor = sqrt(1 - (fCutOff(excitationCnt) / fNow)^2)...
        /sqrt(1 - (fCutOff(excitationCnt) / f0)^2);
      % REVISIT: * factor in TE case, / factor in TM case
      scaleRHS{excitationCnt}(k) = kNow/k0 * factor;
    end
  end
end