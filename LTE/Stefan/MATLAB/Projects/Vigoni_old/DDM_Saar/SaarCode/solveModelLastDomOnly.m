function results = solveModelLastDomOnly(model, sweep, nmode, xy, PO, Np)

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

%     sysMatFreq = model.S - k0^2 * model.T;
    sysMatFreq = model.A0;
    
    for ik = 1:sweep.epsilon.N
        sysMatEps = sysMatFreq + sweep.epsilon.epsRel(ik) * model.Aeps;
        for muCnt = 1 : sweep.mu.N
            %Afem = S -  k02 * T + nuRel(sweep.epsilon.mlabel) * Sdiel - k02 * sweep.epsilon.epsRel(ik) * Tdiel;
%             sysMat = sysMatFreq + 1 / sweep.mu.muRel(muCnt) * model.Sdiel - k0^2 * sweep.epsilon.epsRel(ik) * model.Tdiel;
            sysMat = sysMatEps + 1 / sweep.mu.muRel(muCnt) * model.Anu;

            % calculate solution
            sol = sysMat \ rhsFreq;

            % get impedance matrix
            zMat = model.leftVec' * sol;

            % calculate s matrices and store them
            results.sMat{ik, muCnt, k} = inv(zMat - eye(size(zMat, 1))) * (zMat + eye(size(zMat, 1)));
        end
    end
end

% only for field visualization
results.sol = sol;
