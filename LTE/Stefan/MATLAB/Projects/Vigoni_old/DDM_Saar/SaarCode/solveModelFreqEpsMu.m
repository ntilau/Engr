function results = solveModelFreqEpsMu(model, sweep, nmode, xy, PO, Np)

% set constants
global c0;

nfreq = sweep.frequency.N;

for k = 1 : nfreq
  % print on screen
  disp(['Frequeny = ',num2str(sweep.frequency.freq(k) * 1e-9),' GHz']);

  % set the fequency dependent values
  k0 = 2 * pi * sweep.frequency.freq(k) / c0;

  % calculate frequency depending scaling matrix for rhs
  freqScalMat = buildFreqScal(nmode, xy, PO, Np, k0);

  % scale rhs
  rhsFreq = model.rhsVec * freqScalMat;

  sysMatFreq = model.S - k0^2 * model.T;
%   for dielCnt = 1 : length(sweep.epsilon)
%     sysMatFreq = sysMatFreq + 1 / muRel * model.Sdiel{dielCnt};
%   end

  for epsCnt1 = 1:sweep.epsilon{1}.N
    sysMatEps1 = sysMatFreq - k0^2 * sweep.epsilon{1}.epsRel(epsCnt1) * model.Tdiel{1};
    for muCnt = 1:sweep.mu{1}.N
      %Afem = S -  k02 * T + nuRel(sweep.epsilon.mlabel) * Sdiel - k02 * sweep.epsilon.epsRel(ik) * Tdiel;
      %             sysMat = sysMatFreq + 1 / sweep.mu.muRel(muCnt) * model.Sdiel - k0^2 * sweep.epsilon.epsRel(ik) * model.Tdiel;
      sysMat = sysMatEps1 + 1 / sweep.mu{1}.muRel(muCnt) * model.Sdiel{1};

      % calculate solution
      sol = sysMat \ rhsFreq;

      % get impedance matrix
      zMat = model.leftVec' * sol;

      % calculate s matrices and store them
      results.sMat{k, epsCnt1, muCnt} = inv(zMat - eye(size(zMat, 1))) * (zMat + eye(size(zMat, 1)));
    end
  end
end

% only for field visualization
results.sol = sol;
