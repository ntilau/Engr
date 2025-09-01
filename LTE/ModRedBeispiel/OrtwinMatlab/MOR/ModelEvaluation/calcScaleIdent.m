function scaleIdent = calcScaleIdent(f0, fMin, fMax, numF_Pnts, fCutOff)


% TE Modes
c0 = 299792.458e3;
mu0 = 4e-7*pi;
eta0 = mu0*c0;
for excitationCnt = 1:length(fCutOff)
  scaleIdent{excitationCnt} = zeros(numF_Pnts,1);
  if numF_Pnts == 1
    kNow = 2*pi*fMin/c0;
    factor = sqrt(1-(fCutOff(excitationCnt) / fMin)^2)...
      /sqrt(1 - (fCutOff(excitationCnt) / f0)^2);
    scaleIdent{excitationCnt} = j*kNow*eta0*factor;
  else
    deltaF = (fMax-fMin)/(numF_Pnts-1);
    for k=1:numF_Pnts
      fNow = fMin+(k-1)*deltaF;
      kNow = 2*pi*fNow/c0;
      factor = sqrt(1 - (fCutOff(excitationCnt) / fNow)^2)...
        /sqrt(1 - (fCutOff(excitationCnt) / f0)^2);
      scaleIdent{excitationCnt}(k) = j*kNow*eta0*factor;
    end
  end
end



% TM Modes
% c0 = 299792.458e3;
% mu0 = 4e-7*pi;
% eta0 = mu0*c0;
% for excitationCnt = 1:length(fCutOff)
%   scaleIdent{excitationCnt} = zeros(numF_Pnts,1);
%   if numF_Pnts == 1
%     kNow = 2*pi*fMin/c0;
%     factor = sqrt(1-(fCutOff(excitationCnt) / fMin)^2)...
%       /sqrt(1 - (fCutOff(excitationCnt) / f0)^2);
%     scaleIdent{excitationCnt} = j*kNow*eta0/factor;
%   else
%     deltaF = (fMax-fMin)/(numF_Pnts-1);
%     for k=1:numF_Pnts
%       fNow = fMin+(k-1)*deltaF;
%       kNow = 2*pi*fNow/c0;
%       factor = sqrt(1 - (fCutOff(excitationCnt) / fNow)^2)...
%         /sqrt(1 - (fCutOff(excitationCnt) / f0)^2);
%       scaleIdent{excitationCnt}(k) = j*kNow*eta0/factor;
%     end
%   end
% end