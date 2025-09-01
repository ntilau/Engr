function portMat = sortNetworkParamsByPorts(freqMat)

Nports = size(freqMat{1},1);
portMat = cell(Nports);
Nfreqs = length(freqMat);

for row = 1:Nports
    for col = 1:Nports
        portMat{row,col} = zeros(Nfreqs,1);
        for fCnt = 1:Nfreqs
            portMat{row,col}(fCnt) = freqMat{fCnt}(row,col);
        end
    end
end