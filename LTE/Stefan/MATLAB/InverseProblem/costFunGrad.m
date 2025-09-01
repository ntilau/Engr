function [cost,Grad] = costFunGrad(muVec)
% mu is a vector with mu(1)=real(mu) and mu(2)=imag(mu)

%%%%%%%%%%%%%%%%%
% cost function %
%%%%%%%%%%%%%%%%%
mu = muVec(1)+j*muVec(2)

% % write mu steps in a file
% fid = fopen('muSteps.txt','a');
% fprintf(fid,'%16.12f  %16.12f\n',muVec(1), muVec(2));
% fclose(fid);

global sRef identMat sys0 sys1 sys2 f0 mu0 rhs kSquareSteps scaleRHS...
    scaleIdent fMin fMax numF_Pnts numMuPnts leftVecs f numFktEval;

muMin = mu;
muMax = mu;

muSteps = calcMuStepsNew(mu0, muMin, muMax, numMuPnts);

warning off;

derAplhaMuReal = -mu0/mu^2;
derAplhaMuImag = -j*mu0/mu^2;
% muStep = (muMax-muMin)/(numF_Pnts-1);
% muVals = zeros(1,numF_Pnts);
% for k=1:numF_Pnts
%   muVals(k) = muMin+(k-1)*muStep;
% end
% derAplhaMuReal = -mu0./muVals.^2;
% derAplhaMuImag = -j*mu0./muVals.^2;
% derSmu = zeros(1, numMuPnts*numF_Pnts);

% solve model
% use only s11 => numLeftVec=1
solArray = zeros(1, numMuPnts*numF_Pnts);
for kStepCnt = 1:numF_Pnts
  fMat = sys0 + kSquareSteps(kStepCnt)*sys2 + scaleIdent(kStepCnt)*identMat;
  newRHS = (-2)*scaleRHS(kStepCnt)*rhs;
  for muStepCnt = 1:numMuPnts
    matrix = fMat + muSteps(muStepCnt)*sys1;
    [L,U,P] = lu(matrix);
    sol = U\(L\(P*newRHS));
    % sol = matrix\newRHS;
    solArray(1, (kStepCnt-1)*numMuPnts+muStepCnt) = ...
      leftVecs(1,:)*sol;
    % derivatives
    derSmu(kStepCnt) = -leftVecs(1,:)*(U\(L\(P*sys1*sol)));
  end
end
warning on;

% subtract excitation
solArray(1,1:end) = solArray(1,1:end)-1;

numFktEval = numFktEval+1;
dif = solArray-sRef.';
cost = sum(abs(dif).^2);

%%%%%%%%%%%%
% gradient %
%%%%%%%%%%%%
% Grad = [sum(derAplhaMuReal*derSmu.*conj(dif)+dif.*conj(derSmu*derAplhaMuReal)); ...
%         sum(derAplhaMuImag*derSmu.*conj(dif)+dif.*conj(derSmu*derAplhaMuImag))];

Grad = [sum(2*real(derAplhaMuReal.*derSmu.*conj(dif))); ...
        sum(2*real(derAplhaMuImag.*derSmu.*conj(dif)))];
