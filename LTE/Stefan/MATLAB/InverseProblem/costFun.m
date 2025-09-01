function cost = costFun(muVec)
% mu is a vector with mu(1)=real(mu) and mu(2)=imag(mu)

mu = muVec(1)+j*muVec(2)

global sRef identMat sys0 sys1 sys2 f0 mu0 rhs kSquareSteps scaleRHS...
    scaleIdent fMin fMax numF_Pnts numMuPnts leftVecs f numFktEval;

muMin = mu;
muMax = mu;

muSteps = calcMuStepsNew(mu0, muMin, muMax, numMuPnts);

warning off;
% solve model
% use only s11 => numLeftVec=1
solArray = zeros(1, numMuPnts*numF_Pnts);
for kStepCnt = 1:numF_Pnts
  fMat = sys0 + kSquareSteps(kStepCnt)*sys2 + scaleIdent(kStepCnt)*identMat;
  newRHS = (-2)*scaleRHS(kStepCnt)*rhs;
  for muStepCnt = 1:numMuPnts
    matrix = fMat + muSteps(muStepCnt)*sys1;
%     [L,U,P] = lu(matrix);
%     sol = U\(L\(P*newRHS));
    sol = matrix\newRHS;
    solArray(1, (kStepCnt-1)*numMuPnts+muStepCnt) = ...
      leftVecs(1,:)*sol;
  end
end
warning on;

% subtract excitation
solArray(1,1:end) = solArray(1,1:end)-1;

deltaF = f(2)-f(1);
numFktEval = numFktEval+1;
dif = solArray-sRef.';

cost = sum(abs(dif).^2);