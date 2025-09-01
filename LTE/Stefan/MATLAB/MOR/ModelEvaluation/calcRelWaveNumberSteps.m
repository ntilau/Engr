function wNumSteps = calcRelWaveNumberSteps(f0, fMin, fMax, numF_Pnts)

c0 = 299792.458e3;
k0 = 2.0*pi*f0/c0;
if numF_Pnts == 1
  kNow = 2*pi*fMin/c0;
  wNumSteps = (kNow-k0) / k0;
else
  deltaF = (fMax-fMin)/(numF_Pnts-1);
  for k=1:numF_Pnts
      kNow = 2*pi*(fMin+(k-1)*deltaF)/c0;
      wNumSteps(k) = (kNow-k0) / k0;
  end
end
