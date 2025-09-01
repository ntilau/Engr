% create S-matrix cell-array from port-based S-params
function freqMat = sortNetworkParamsByMatrices(portMat)

Nfreqs = length(portMat{1});
Nports = length(portMat);

freqMat = cell(1,Nfreqs);

for fCnt = 1:Nfreqs
    % s-matrix fuer eine Frequenz
    freqMat{fCnt} = zeros(Nports);
    for row = 1:Nports
        for col = 1:Nports
            
            freqMat{fCnt}(row,col) = portMat{row,col}(fCnt);
        end
    end
end
