function kSquareSteps = calcK_SquareRelSteps(f0, fMin, fMax, numF_Pnts)

kSquareSteps = zeros(numF_Pnts,1);
c0 = 299792.458e3;
k0 = 2.0*pi*f0/c0;
if numF_Pnts == 1
  kNow = 2*pi*fMin/c0;
  kSquareSteps = kNow^2 / k0^2 - 1;
else
  deltaF = (fMax-fMin)/(numF_Pnts-1);
  for k=1:numF_Pnts
      kNow = 2*pi*(fMin+(k-1)*deltaF)/c0;
      kSquareSteps(k) = kNow^2 / k0^2 - 1;
  end
end
