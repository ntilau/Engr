function Crit = incrementalStoppingCriterion(nwMatOld, nwMatNew)

nFreqs = length(nwMatOld);

if ~iscell(nwMatOld) || ~iscell(nwMatNew)
    error('Network matrices must be a cell array');
end

if length(nwMatNew) ~= nFreqs
    error('Network matrix cell arrays must be of same length');
end

nPorts = size(nwMatOld{1}, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stopping criterion in scattering parameters
critL1 = 0;
critL2 = 0;
critInf = 0;

for iFreq = 1:nFreqs
    delta = abs(nwMatNew{iFreq} - nwMatOld{iFreq});
    
    critL1 = critL1 + sum(sum(delta));
    critL2 = critL2 + sum(sum(delta.^2));
    if max(max(delta)) > critInf
        critInf = max(max(delta));
    end
end

Crit.L1 = critL1 / nPorts^2 / nFreqs;    
Crit.L2 = sqrt(critL2 / nPorts^2 / nFreqs);  
Crit.inf = critInf;
    







