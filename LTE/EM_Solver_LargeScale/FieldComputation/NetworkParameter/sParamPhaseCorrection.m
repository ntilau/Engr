% EM_WaveSolver results may exhibit a 180-deg phase shift, which will be
% corrected by multiplication with -1
function [sMatRaw, sMatRef] = sParamPhaseCorrection(sMatRaw, sMatRef)

nFreqs = length(sMatRaw);
if length(sMatRef) ~= nFreqs
    error('S-Parameter cell arrays must have same length');
end

% phase correction
for iFreq = 1:nFreqs
    sMatRawNormalized = sMatRaw{iFreq} ./ abs(sMatRaw{iFreq});            
    
    sMatRefNormalized = sMatRef{iFreq} ./ abs(sMatRef{iFreq});

    idx = abs(sMatRawNormalized - sMatRefNormalized) > 1;
    sMatRaw{iFreq}(idx) = - sMatRaw{iFreq}(idx);
end
