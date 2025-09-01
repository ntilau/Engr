function [cost,Grad] = costFunGradLinMuImag(parVec)
% mu is a vector with mu(1)=real(mu) and mu(2)=imag(mu)

%%%%%%%%%%%%%%%%%
% cost function %
%%%%%%%%%%%%%%%%%
mu = parVec(1)+j*parVec(2) % is mu at f=fMin
slopeMuImag = parVec(3)

% % write mu steps in a file
% fid = fopen('muSteps.txt','a');
% fprintf(fid,'%16.12f  %16.12f\n',parVec(1), parVec(2));
% fclose(fid);

global sRef identMat sys0 sys1 sys2 f0 mu0 rhs kSquareSteps scaleRHS...
    scaleIdent fMin fMax numF_Pnts numMuPnts leftVecs f numFktEval;

muMin = mu;
%muMax = mu;
deltaF = (fMax-fMin)/(numF_Pnts-1);
muMax = muMin+j*slopeMuImag*(fMax-fMin);
muSteps = calcMuStepsNew(mu0, muMin, muMax, numF_Pnts);

warning off;

% derAplhaMuReal = -mu0/mu^2;
% derAplhaMuImag = -j*mu0/mu^2;

muStep = (muMax-muMin)/(numF_Pnts-1);
muVals = zeros(1,numF_Pnts);
for k=1:numF_Pnts
  muVals(k) = muMin+(k-1)*muStep;
end
derAplhaMuReal = -mu0./muVals.^2;
derAplhaMuImag = -j*mu0./muVals.^2;

derSmu = zeros(1, numMuPnts*numF_Pnts);

% solve model
% use only s11 => numLeftVec=1
solArray = zeros(1,numF_Pnts);
for stepCnt = 1:numF_Pnts
  fMat = sys0 + kSquareSteps(stepCnt)*sys2 + scaleIdent(stepCnt)*identMat;
  newRHS = (-2)*scaleRHS(stepCnt)*rhs;
  matrix = fMat + muSteps(stepCnt)*sys1;
  [L,U,P] = lu(matrix);
  sol = U\(L\(P*newRHS));
  % sol = matrix\newRHS;
  solArray(stepCnt) = leftVecs(1,:)*sol;
  % derivatives
  derSmu(stepCnt) = -leftVecs(1,:)*(U\(L\(P*sys1*sol)));
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
d_mu_d_slope = (f-fMin).';

% Grad = [sum(2*real(derAplhaMuReal*derSmu.*conj(dif))); ...
%         sum(2*real(derAplhaMuImag*derSmu.*conj(dif))); ...
%         sum(2*real(derAplhaMuImag*derSmu.*conj(dif).*d_mu_d_slope))]

Grad = [sum(2*real(derAplhaMuReal.*derSmu.*conj(dif))); ...
        sum(2*real(derAplhaMuImag.*derSmu.*conj(dif))); ...
        sum(2*real(derAplhaMuImag.*derSmu.*conj(dif).*d_mu_d_slope))];

