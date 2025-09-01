function scaleRHS = calcScaleRHS(f0, fMin, fMax, numF_Pnts, fCutOff, tmFlag)

c0 = 299792.458e3;
k0 = 2.0*pi*f0/c0;
scaleRHS = cell(length(fCutOff),1);
for excitationCnt = 1:length(fCutOff)
  scaleRHS{excitationCnt} = zeros(numF_Pnts,1);
  if numF_Pnts == 1
    kNow = 2*pi*fMin/c0;
    factor = sqrt((fCutOff(excitationCnt) / fMin)^2 - 1)...
      /sqrt((fCutOff(excitationCnt) / f0)^2 - 1);
    % following if statement is necessary, because rhs is always real in
    % lossless case, no matter if expansion frequency is above or below
    % cutoff.
    if f0 < fCutOff(excitationCnt)
      factor = -1i*factor;
    end
    if tmFlag
      scaleRHS{excitationCnt} = kNow / k0 / factor;   % TM mode
    else
      scaleRHS{excitationCnt} = kNow / k0 * factor;   % TE mode
    end
  else
    deltaF = (fMax-fMin)/(numF_Pnts-1);
    for k=1:numF_Pnts
      fNow = fMin+(k-1)*deltaF;
      kNow = 2*pi*fNow/c0;
      factor = sqrt((fCutOff(excitationCnt) / fNow)^2 - 1)...
        /sqrt((fCutOff(excitationCnt) / f0)^2 - 1);
      % following if statement is necessary, because rhs is always real in
      % lossless case, no matter if expansion frequency is above or below
      % cutoff.
      if f0 < fCutOff(excitationCnt)
        factor = -1i*factor;
      end
      if tmFlag
        scaleRHS{excitationCnt}(k) = kNow / k0 / factor;  % TM mode
      else
        scaleRHS{excitationCnt}(k) = kNow / k0 * factor;  % TE mode
      end
    end
  end
end
