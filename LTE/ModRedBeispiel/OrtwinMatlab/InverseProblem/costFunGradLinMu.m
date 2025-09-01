function [cost, Grad] = costFunGradLinMu(parVec)
toc
%%%%%%%%%%%%%%%%%
% cost function %
%%%%%%%%%%%%%%%%%
muMin = parVec(1)+j*parVec(2);  % is mu at f=fMin
muMax = parVec(3)+j*parVec(4);  % is mu at f=fMax
muMin
muMax

% % write mu steps in a file
% fid = fopen('muSteps.txt','a');
% fprintf(fid,'%16.12f  %16.12f\n',muVec(1), muVec(2));
% fclose(fid);

global sRef identMat sys0 sys1 sys2 f0 mu0 rhs kSquareSteps scaleRHS...
    scaleIdent fMin fMax numF_Pnts numMuPnts leftVecs f numFktEval;

deltaF = (fMax-fMin)/(numF_Pnts-1);
muParSteps = calcMuStepsNew(mu0, muMin, muMax, numF_Pnts);

warning off;

muStep = (muMax-muMin)/(numF_Pnts-1);
muVals = zeros(1,numF_Pnts);
for k=1:numF_Pnts
  muVals(k) = muMin+(k-1)*muStep;
end
derAplhaMuReal = -mu0./muVals.^2;
derAplhaMuImag = -j*mu0./muVals.^2;
% derAplhaMuReal = -mu0/mu^2;
% derAplhaMuImag = -j*mu0/mu^2;

derSmu = zeros(1, numMuPnts*numF_Pnts);

% solve model
% use only s11 => numLeftVec=1
solArray = zeros(1,numF_Pnts);
for stepCnt = 1:numF_Pnts
  fMat = sys0 + kSquareSteps(stepCnt)*sys2 + scaleIdent(stepCnt)*identMat;
  newRHS = (-2)*scaleRHS(stepCnt)*rhs;
  matrix = fMat + muParSteps(stepCnt)*sys1;
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
if nargout > 1  % fun called with two output arguments
  d_muReal_d_muMin = 1-f./(fMax-fMin);
  d_muReal_d_muMax = f./(fMax-fMin);
  d_muImag_d_muMin = d_muReal_d_muMin;
  d_muImag_d_muMax = d_muReal_d_muMax;

  Grad = [sum(2*real(derAplhaMuReal.*derSmu.*conj(dif)).*d_muReal_d_muMin.'), ...
          sum(2*real(derAplhaMuImag.*derSmu.*conj(dif)).*d_muImag_d_muMin.'), ...
          sum(2*real(derAplhaMuReal.*derSmu.*conj(dif)).*d_muReal_d_muMax.'), ...
          sum(2*real(derAplhaMuImag.*derSmu.*conj(dif)).*d_muImag_d_muMax.')];
  toc      
end

