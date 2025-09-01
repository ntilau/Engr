% compute actual error of S- and Z-parameters
function Error = computeActualRomError(Model, Ref, Rom)

Error = struct([]);

% find common frequencies
[commonFreq, iFreqRef, iFreqRom] = intersect(Ref.f, Model.f);

if isempty(commonFreq)
    warning(['Reference solution and ROM ',...
        'solution have no frequencies in common']); %#ok<WNTAG>    
    return;
end

zMatRef = Ref.zMat(iFreqRef);
sMatRef = Ref.sMat(iFreqRef);

for iRom = 1:length(Rom)    
    zMatRom = Rom{iRom}.zMat(iFreqRom);
    sMatRom = Rom{iRom}.sMat(iFreqRom);
    for iFreq = 1:length(commonFreq)
        Error(iRom).zMat{iFreq} = abs(zMatRef{iFreq} - zMatRom{iFreq});
        Error(iRom).sMat{iFreq} = abs(sMatRef{iFreq} - sMatRom{iFreq});
    end
    
    Error(iRom).Z = sortNetworkParamsByPorts(Error(iRom).zMat);
    Error(iRom).S = sortNetworkParamsByPorts(Error(iRom).sMat);    
    Error(iRom).f = commonFreq;
end


